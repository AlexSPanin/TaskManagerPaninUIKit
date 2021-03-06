//
//  MainFoldersTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

class MainFoldersTableViewController: UITableViewController {
    
    var foldersTasks = [FolderTasks()]
    var isChange: Bool = false {
        didSet {
            self.tableView.reloadData()
            isChange = false
        }
    }
    private var rowLongPressed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(tablePressed))
        tableView.addGestureRecognizer(recognizer)
        tableView.rowHeight = 45
        tableView.separatorColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        tableView.allowsSelection = true
        
        setupNavigationBar()
        
        DataManager.shared.createTempData()
        foldersTasks = StorageManager.shared.fetchFoldersTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foldersTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foldersRows", for: indexPath)
        let folder = foldersTasks[indexPath.row]
        let countTasks = folder.tasks.count
        
        var content = cell.defaultContentConfiguration()
        content.text = folder.title
        content.textProperties.lineBreakMode = .byTruncatingMiddle
        content.textProperties.alignment = .natural
        content.secondaryText = String("\(countTasks)")
        content.secondaryTextProperties.color = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        content.secondaryTextProperties.alignment = .natural
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let folderTasks = foldersTasks[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.foldersTasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            StorageManager.shared.save(at: self.foldersTasks)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: folderTasks, index: indexPath.row)
            
            isDone(true)
        }
        editAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currentFolder = foldersTasks.remove(at: sourceIndexPath.row)
        foldersTasks.insert(currentFolder, at: destinationIndexPath.row)
        StorageManager.shared.save(at: foldersTasks)
        tableView.isEditing = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksTableViewController else { return }
        setActiveFolder(indexPath.row)
        tasksVC.foldersTasks = foldersTasks
        tasksVC.indexFolder = indexPath.row
    }
    
    @objc func tablePressed(_ recognizer: UILongPressGestureRecognizer) {
        rowLongPressed += 1
        if rowLongPressed == 1 {
            tableView.isEditing.toggle()
        } else { rowLongPressed = 0 }
    }
    
    @objc func addFolder() {
        showAlert()
    }
    
    @objc func addTask() {
        if foldersTasks.isEmpty { showAlert() }
        guard let indexFolder = foldersTasks.firstIndex( where: \.isActive) else { return }
        let task = TaskList()
        
        let stuyryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addTaskVC = stuyryboard.instantiateViewController(withIdentifier: "AddTasksViewController") as? AddTasksViewController else { return }
        addTaskVC.delegate = self
        addTaskVC.mode = .edit
        addTaskVC.indexFolder = indexFolder
        addTaskVC.indexTask = foldersTasks[indexFolder].tasks.count
        foldersTasks[indexFolder].tasks.append(task)
        addTaskVC.foldersTasks = foldersTasks
        
        present(addTaskVC, animated: true)
        
    }
    
    private func setActiveFolder(_ index: Int) {
        let foldersTasks = foldersTasks
        if foldersTasks.contains(where: { folder in folder.isActive }) {
            for foldersTask in foldersTasks {
                foldersTask.isActive = false
            }
            foldersTasks[index].isActive = true
        } else {
            foldersTasks[0].isActive = true
        }
        StorageManager.shared.save(at: foldersTasks)
    }
    // MARK: -  Show Alert for add Folders
    
    private func showAlert(with folderTasks: FolderTasks? = nil, index: Int? = nil) {
        let title = folderTasks != nil ? "Edit Folder Name" : "New Folder"
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Please enter the title of the folder")
        
        alert.action(with: folderTasks) { newValue in
            if folderTasks != nil, let index = index {
                self.foldersTasks[index].title = newValue
                StorageManager.shared.save(at: self.foldersTasks)
                self.setActiveFolder(index)
                self.tableView.reloadData()
            } else {
                self.save(folderTitle: newValue)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(folderTitle: String) {
        let folderTask = FolderTasks()
        folderTask.title = folderTitle
        
        foldersTasks.append(folderTask)
        StorageManager.shared.save(at: foldersTasks)
        setActiveFolder(foldersTasks.count - 1)
        tableView.reloadData()
    }
}

extension MainFoldersTableViewController: TasksTableViewControllerDelegate {
    func update(indexFolder: Int, foldersTasks: [FolderTasks], isChange: Bool) {
        
        self.foldersTasks = foldersTasks
        self.isChange = isChange
    }
}
