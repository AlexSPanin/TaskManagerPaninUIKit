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
            
            let task = TaskList()
            task.title = "My first Task"
            task.note = "Hi! Welcome to the team!"
            
            
            let folder = FolderTasks()
            folder.date = Date()
            folder.title = "For example"
            folder.tasks = [task]
                
            UserDefaults.standard.set(true, forKey: "Check")
            UserDefaults.standard.removeObject(forKey: "Tasks")
            StorageManager.shared.save(at: folder)
        }
    }
}
