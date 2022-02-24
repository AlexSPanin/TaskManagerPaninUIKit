//
//  DataManager.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData() {
        if !UserDefaults.standard.bool(forKey: "Chek") {
            
            let folder = FolderTasks()
            folder.title = "For example"
            
            let task = TaskList()
            task.title = "Task1"
            task.note = "Hello, User!!"
            
            folder.task.append(task)

            UserDefaults.standard.set(true, forKey: "Check")
        }
    }
}
