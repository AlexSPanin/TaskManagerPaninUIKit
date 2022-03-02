//
//  TasksList.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

// MARK: - enum for setting status edit or preview for addTasksVC

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
    var note = AttributedString(nsAttributedString: NSAttributedString(string: ""))
}

class AttributedString : Codable {

    let attributedString : NSAttributedString

    init(nsAttributedString : NSAttributedString) {
        self.attributedString = nsAttributedString
    }

    public required init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        guard let attributedString = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(singleContainer.decode(Data.self)) as? NSAttributedString else {
            throw DecodingError.dataCorruptedError(in: singleContainer, debugDescription: "Data is corrupted")
        }
        self.attributedString = attributedString
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false))
    }
}
