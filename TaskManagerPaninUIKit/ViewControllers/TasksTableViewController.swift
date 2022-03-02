//
//  TasksTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit
protocol TasksTableViewControllerDelegate {
    
    func update(indexFolder: Int, foldersTasks: [FolderTasks], isChange: Bool)
}

class TasksTableViewController: UITableViewController {
    
    var indexFolder: Int!
    var foldersTasks: [FolderTasks]!
    var isChange: Bool = false {
        didSet {
            title = foldersTasks[indexFolder].title
            self.tableView.reloadData()
            isChange = false
        }
    }
    private var rowLongPressed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = foldersTasks[indexFolder].title
        tableView.rowHeight = 80
        tableView.separatorColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        let addTaskButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .done,
                target: self,
                action: #selector(addTask))
        navigationItem.rightBarButtonItem = addTaskButton
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(tablePressed))
        tableView.addGestureRecognizer(recognizer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
        print("WillTrans TaskTable")

    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foldersTasks[indexFolder].tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksRows", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let tasks = foldersTasks[indexFolder].tasks[indexPath.row]
        content.text = tasks.title
        content.secondaryText = tasks.note
        content.secondaryTextProperties.lineBreakMode = .byTruncatingMiddle
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.foldersTasks[self.indexFolder].tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.save(at: self.foldersTasks)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let currentTask = foldersTasks[indexFolder].tasks.remove(at: sourceIndexPath.row)
        foldersTasks[indexFolder].tasks.insert(currentTask, at: destinationIndexPath.row)
        StorageManager.shared.save(at: foldersTasks)
        tableView.isEditing = false
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let previewTaskVC = segue.destination as? AddTasksViewController else { return }
        
        previewTaskVC.delegate = self
        previewTaskVC.mode = .preview
        previewTaskVC.indexFolder = indexFolder
        previewTaskVC.indexTask = indexPath.row
        previewTaskVC.foldersTasks = foldersTasks
    }
    
    @objc func addTask() {
        
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
    
    @objc func tablePressed(_ recognizer: UILongPressGestureRecognizer) {
        rowLongPressed += 1
        if rowLongPressed == 1 {
            tableView.isEditing.toggle()
        } else { rowLongPressed = 0 }
    }

}

extension TasksTableViewController: TasksTableViewControllerDelegate {
    
    func update(indexFolder: Int, foldersTasks: [FolderTasks], isChange: Bool) {
        self.indexFolder = indexFolder
        self.foldersTasks = foldersTasks
        self.isChange = isChange
    }
    
}
