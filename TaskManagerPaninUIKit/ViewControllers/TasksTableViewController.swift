//
//  TasksTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    var folderTasks: FolderTasks?
    var indexFolder: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = folderTasks?.title
        tableView.rowHeight = 80
        let addTaskButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .done,
                target: self,
                action: #selector(addTask))
        navigationItem.rightBarButtonItem = addTaskButton
        
        
        
        
        
        
        
        
//        navigationItem.rightBarButtonItem = editButtonItem
//        let button = navigationItem.rightBarButtonItem
//        button?.tintColor = .yellow

    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folderTasks?.tasks.count ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksRows", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let tasks = folderTasks?.tasks[indexPath.row]
        content.text = tasks?.title
        content.secondaryText = tasks?.note
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let folderTasks = folderTasks?.tasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            guard let indexFolder = self.indexFolder else { return }
            StorageManager.shared.deleteTask(indexFolder: indexFolder, indexTask: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            print("\(String(describing: folderTasks?.title))")

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
        guard let folderTasks = folderTasks else { return }
        guard let indexFolder = indexFolder else { return }

        let currentFolder = folderTasks.tasks.remove(at: sourceIndexPath.row)
        folderTasks.tasks.insert(currentFolder, at: destinationIndexPath.row)
        
   //     StorageManager.shared.moveRowFolder(folder: folderTasks, indexFolder: indexFolder)
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let taskVC = segue.destination as? AddTasksViewController else { return }
        let task = folderTasks?.tasks[indexPath.row]
        taskVC.task = task
        taskVC.titleFolder = folderTasks?.title
    }
    
    @objc func addTask() {
        print("addTask")
    }


}
