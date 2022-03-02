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

    func fetchFoldersTasks() -> [FolderTasks] {
        guard let data = userDefaults.object(forKey: tasksKey) as? Data else { return [] }
        guard let foldersTasks = try? JSONDecoder().decode([FolderTasks].self, from: data) else { return [] }
        return foldersTasks
    }
}
