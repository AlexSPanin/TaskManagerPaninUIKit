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
    
    var foldersTasks: [FolderTasks]!
    var indexFolder: Int!
    
    var isChange: Bool = false {
        didSet {
            self.tableView.reloadData()
            isChange = false
            print("Didset TaskTable")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = foldersTasks[indexFolder].title
        tableView.rowHeight = 80
        let addTaskButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .done,
                target: self,
                action: #selector(addTask))
        navigationItem.rightBarButtonItem = addTaskButton
        print("DidLoad TaskTable")
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
        StorageManager.shared.moveRowTask(indexFolder: indexFolder, task: currentTask,
                                          sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
  
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    
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


}

extension TasksTableViewController: TasksTableViewControllerDelegate {
    
    func update(indexFolder: Int, foldersTasks: [FolderTasks], isChange: Bool) {
        self.indexFolder = indexFolder
        self.foldersTasks = foldersTasks
        self.isChange = isChange
    }
    
}
