//
//  ExtentionNSAttributedString.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 02.03.2022.
//

import UIKit

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
