//
//  ExtentionView.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 27.02.2022.
//

import UIKit

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

// MARK: - Create User interface

extension AddTasksViewController {
    func createUI() {
        
        let changeFolderButton = UIButton()
        changeFolderButton.tintColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        changeFolderButton.setImage(UIImage(systemName: "folder"), for: .normal)
        changeFolderButton.addTarget(self, action: #selector(changeFolder), for: .touchDown)
        changeFolderButton.contentHorizontalAlignment = .left
        
        let shareTaskButton = UIButton()
        shareTaskButton.tintColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        shareTaskButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareTaskButton.addTarget(self, action: #selector(shareTask), for: .touchDown)
        shareTaskButton.contentHorizontalAlignment = .right
        
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        
        titleFolderLabel = label
        
        titleFolderLabel.translatesAutoresizingMaskIntoConstraints = false
        titleFolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let textField = UITextField()
        textField.placeholder = "Enter title task"
        textField.textAlignment = .natural
        textField.contentVerticalAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        titleTaskTextField = textField
        
        titleTaskTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTaskTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.textAlignment = .natural
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.dataDetectorTypes = [.all]
        textView.layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        textView.allowsEditingTextAttributes = true
        
        noteTaskTextView = textView
        
        let title = UILabel()
        title.text = "Title:"
        title.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        
        let note = UILabel()
        note.text = "Your Task"
        note.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        
        let stackH = UIStackView(arrangedSubviews: [changeFolderButton, titleFolderLabel, shareTaskButton])
        
        stackH.axis = .horizontal
        stackH.spacing = 2
        stackH.distribution = UIStackView.Distribution.fillEqually
        
        
        
        let stackV = UIStackView(arrangedSubviews: [stackH, title, titleTaskTextField, note, noteTaskTextView])
        
        stackV.axis = .vertical
        stackV.spacing = 5
        stackV.distribution = UIStackView.Distribution.fill
        
        view.addSubview(stackV)
        
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        stackV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}


