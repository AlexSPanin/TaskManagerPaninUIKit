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
            print("Didset TaskTable")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupNavigationBar()
        tableView.rowHeight = 45
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
        
        print(countTasks)
        
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
            StorageManager.shared.deleteFolder(indexFolder: indexPath.row)
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currentFolder = foldersTasks.remove(at: sourceIndexPath.row)
        foldersTasks.insert(currentFolder, at: destinationIndexPath.row)
        StorageManager.shared.save(at: foldersTasks)
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
    
    func printActiveFolders() {
        for foldersTask in foldersTasks {
            if foldersTask.isActive { print(foldersTasks.count,foldersTask.title, foldersTask.isActive)}
        }
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
        self.printActiveFolders()
    }
    
    
}
// MARK: - Create Bar Buttons

extension MainFoldersTableViewController {
    
    private func setupNavigationBar() {
        guard let navigation = navigationController else { return }
        
        let addFolderButton = UIBarButtonItem(
                image: UIImage(systemName: "folder.badge.plus"),
                style: .done,
                target: self,
                action: #selector(addFolder))
        
        let addTaskButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .done,
                target: self,
                action: #selector(addTask))
        
        title = "Folders"
       navigation.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        navigation.navigationBar.standardAppearance = navBarAppearance
        navigation.navigationBar.scrollEdgeAppearance = navBarAppearance
    
        navigationItem.rightBarButtonItem = addTaskButton
        navigationItem.leftBarButtonItem = addFolderButton
        navigation.navigationBar.tintColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    
    }
    
}

// MARK: -  Show Alert for add Folders

extension MainFoldersTableViewController {
    
    private func showAlert(with folderList: FolderTasks? = nil, index: Int? = nil) {
        let title = folderList != nil ? "Edit Folder Name" : "New Folder"
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Please enter the title of the folder")
        
        alert.action(with: folderList) { newValue in
            if let folderList = folderList, let index = index {
                
                self.foldersTasks[index].title = newValue
                StorageManager.shared.editFolder(
                    folderTasks: folderList,
                    indexFolder: index,
                    newTitle: newValue
                )
                self.foldersTasks[index].title = newValue
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
        StorageManager.shared.addFolder(at: folderTask)
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
