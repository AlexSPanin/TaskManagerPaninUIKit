//
//  MainFoldersTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

class MainFoldersTableViewController: UITableViewController {
    
    var foldersTasks = [FolderTasks()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Folders for Task"
        navigationItem.rightBarButtonItem = editButtonItem
        
        DataManager.shared.createTempData()
        foldersTasks = StorageManager.shared.fetchFoldersTasks()
        
        print(tabBarController?.selectedViewController)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foldersTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foldersRows", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let folder = foldersTasks[indexPath.row]
        let countTasks = folder.tasks.count
        content.text = folder.title
        content.secondaryText = String("\(countTasks)")
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let folderTasks = foldersTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.deleteFolder(indexFolder: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            print("\(folderTasks.title)")
//            {
//                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksTableViewController else { return }
        let folder = foldersTasks[indexPath.row]
        tasksVC.folderTasks = folder
        tasksVC.indexFolder = indexPath.row
    }
    
    
    @objc private func addButtonPressed() {
        print("Edit")
    }

}
