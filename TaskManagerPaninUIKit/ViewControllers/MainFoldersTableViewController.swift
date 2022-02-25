//
//  MainFoldersTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

class MainFoldersTableViewController: UITableViewController {
    
    var foldersTasks = [FolderTasks()]
    
private let addFolderButton = UIBarButtonItem(
        image: UIImage(systemName: "folder.badge.plus"),
        style: .done,
        target: self,
        action: #selector(addFolder))
    
private let addTaskButton = UIBarButtonItem(
        image: UIImage(systemName: "square.and.pencil"),
        style: .done,
        target: self,
        action: #selector(addTask))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Folders for Task"
        navigationItem.rightBarButtonItem = addTaskButton
        navigationItem.leftBarButtonItem = addFolderButton
        
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
        content.secondaryText = String("\(countTasks)")
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
            print("Index add", indexPath)
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
    
    @objc func addFolder() {
        showAlert()
    }
    
    @objc func addTask() {
        print("addTask")
    }
    
    @objc private func addButtonPressed() {
        print("Edit")
    }

}

extension MainFoldersTableViewController {
    
    private func showAlert(with folderList: FolderTasks? = nil, index: Int? = nil) {
        let title = folderList != nil ? "Edit Folder Name" : "New Folder"
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Please enter the title of the folder")
        
        alert.action(with: folderList) { newValue in
            if let folderList = folderList, let index = index {
                
                self.foldersTasks[index].title = newValue
                StorageManager.shared.editFolder(
                    folder: folderList,
                    indexFolder: index,
                    newTitle: newValue
                )
                self.foldersTasks[index].title = newValue
                
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
        StorageManager.shared.save(at: folderTask)
        
        tableView.reloadData()
    }
}
