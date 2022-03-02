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
    
    func save(at foldersTasks: [FolderTasks]) {
        let foldersTasks = foldersTasks
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func saveTasks(indexFolder: Int, tasks: [TaskList]) {
        let foldersTasks = fetchFoldersTasks()
        foldersTasks[indexFolder].tasks.removeAll()
        foldersTasks[indexFolder].tasks = tasks
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func addTask(indexFolder: Int, task: TaskList) {
        let foldersTasks = fetchFoldersTasks()
        foldersTasks[indexFolder].tasks.append(task)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func editTask(indexFolder: Int, indexTask: Int ,newTask: TaskList) {
        let foldersTasks = fetchFoldersTasks()
        foldersTasks[indexFolder].tasks[indexTask] = newTask
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func deleteTask(indexFolder: Int, indexTask: Int) {
        let foldersTasks = fetchFoldersTasks()
        foldersTasks[indexFolder].tasks.remove(at: indexTask)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func moveRowTask(indexFolder: Int, task: TaskList, sourceIndex: Int, destinationIndex: Int) {
        let foldersTasks = fetchFoldersTasks()
        foldersTasks[indexFolder].tasks.remove(at: sourceIndex)
        foldersTasks[indexFolder].tasks.insert(task, at: destinationIndex)
        
        guard let data = try? JSONEncoder().encode(foldersTasks) else { return }
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func fetchFoldersTasks() -> [FolderTasks] {
        guard let data = userDefaults.object(forKey: tasksKey) as? Data else { return [] }
        guard let foldersTasks = try? JSONDecoder().decode([FolderTasks].self, from: data) else { return [] }
        
        return foldersTasks
    }
}
