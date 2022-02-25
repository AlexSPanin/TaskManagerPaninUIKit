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
        
        if !UserDefaults.standard.bool(forKey: "Check") {
            
            let folder = FolderTasks()
            folder.date = Date()
            folder.title = "For example"
            folder.tasks = [
                TaskList(date: Date(), title: "Task 1", note: "Hello, User!!"),
                TaskList(date: Date(), title: "Task 2", note: "Input First Task")
            ]
          
            UserDefaults.standard.set(true, forKey: "Check")
            UserDefaults.standard.removeObject(forKey: "Tasks")
            StorageManager.shared.save(at: folder)
        }
    }
}
