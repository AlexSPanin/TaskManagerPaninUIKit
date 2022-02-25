//
//  TasksList.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import Foundation



class FolderTasks: Codable {
    var date = Date()
    var title = ""
    var tasks = [TaskList]()
}

class TaskList: Codable {
    var date = Date()
    var title = ""
    var note = ""
}

