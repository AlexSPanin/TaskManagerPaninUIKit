//
//  StoradgeManager.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "Tasks"
    
    private init() {}
    
    func save(at item: FolderTasks) {
        var foldersTasks = fetchFoldersTasks()
        foldersTasks.append(item)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func fetchFoldersTasks() -> [FolderTasks] {
        guard let data = userDefaults.object(forKey: tasksKey) as? Data else { return [] }
        guard let foldersTasks = try? JSONDecoder().decode([FolderTasks].self, from: data) else { return [] }
        
        return foldersTasks
    }
    
    func editFolder(folder: FolderTasks, indexFolder: Int, newTitle: String) {
        
        
    }
    
    
    func done(folder: FolderTasks, indexFolder: Int) {
        var foldersTasks = fetchFoldersTasks()
       
        foldersTasks.remove(at: indexFolder)
        foldersTasks.insert(folder, at: indexFolder)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func deleteFolder(indexFolder: Int) {
        var foldersTasks = fetchFoldersTasks()
        
        foldersTasks.remove(at: indexFolder)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func deleteTask(indexFolder: Int, indexTask: Int) {
        let foldersTasks = fetchFoldersTasks()
        foldersTasks[indexFolder].tasks.remove(at: indexTask)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
}
