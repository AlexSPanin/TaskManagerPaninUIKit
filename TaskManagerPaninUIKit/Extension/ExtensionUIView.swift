//
//  ExtentionView.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 27.02.2022.
//

import UIKit

// MARK: - extention for animet border style edit - preview

extension UIView {
    func animateBorderWidth(toValue: CGFloat, duration: Double) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = layer.borderWidth
        animation.toValue = toValue
        animation.duration = duration
        layer.add(animation, forKey: "Width")
        layer.borderWidth = toValue
    }
}

