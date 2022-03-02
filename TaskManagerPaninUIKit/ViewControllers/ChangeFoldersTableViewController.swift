//
//  ChangeFoldersTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 01.03.2022.
//

import UIKit

class ChangeFoldersTableViewController: UITableViewController {
    
    var delegate: AddTasksViewControllerDelegate!
    var indexFolder: Int!
    var indexTask: Int!
    var foldersTasks: [FolderTasks]!
    var isChange: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        StorageManager.shared.save(at: foldersTasks)
        isChange.toggle()
        delegate?.update(indexFolder: indexFolder, indexTask: indexTask, foldersTasks: foldersTasks, isChange: isChange)
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foldersTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folders", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = foldersTasks[indexPath.row].title
        content.textProperties.lineBreakMode = .byTruncatingMiddle
        content.textProperties.alignment = .natural
        content.textProperties.color = foldersTasks[indexPath.row].isActive ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        content.secondaryText = foldersTasks[indexPath.row].isActive ? "\u{2713}" : ""
        content.secondaryTextProperties.color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        content.secondaryTextProperties.alignment = .natural
        cell.contentConfiguration = content
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeFolder(indexPath.row)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
       true
    }
    
    private func changeFolder(_ newIndexFolder: Int) {
        
        let task = foldersTasks[indexFolder].tasks[indexTask]
        foldersTasks[indexFolder].tasks.remove(at: indexTask)
        foldersTasks[newIndexFolder].tasks.insert(task, at: 0)
        indexFolder = newIndexFolder
        indexTask = 0
        
        for foldersTask in foldersTasks {
            foldersTask.isActive = false
        }
        foldersTasks[newIndexFolder].isActive = true
        isChange = true
    }

}
