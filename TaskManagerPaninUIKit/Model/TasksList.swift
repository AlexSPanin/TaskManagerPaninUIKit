//
//  TasksList.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import Foundation

enum Mode {
    case edit
    case preview
    
    mutating func togle() {
        switch self {
        case .edit:
            self = .preview
        case .preview:
            self = .edit
        }
    }
}

class FolderTasks: Codable {
    var isActive: Bool = false
    var date = Date()
    var title = ""
    var tasks = [TaskList]()
}

class TaskList: Codable {
    var date = Date()
    var title = ""
    var note = ""
}

