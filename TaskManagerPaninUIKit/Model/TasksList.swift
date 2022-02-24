//
//  TasksList.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import Foundation

class FolderTasks {
    var date = Date()
    var title = ""
    var task = [TaskList()]
}


class TaskList {
    var date = Date()
    var title = ""
    var note = ""
}
