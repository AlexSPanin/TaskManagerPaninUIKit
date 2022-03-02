//
//  ExtentionAddTasksViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 02.03.2022.
//

import UIKit

// MARK: - Create User interface

extension AddTasksViewController {
    func createUI() {
        
        let changeFolderButton = UIBarButtonItem(
            image: UIImage(systemName: "folder"),
            style: .done,
            target: self,
            action: #selector(changeFolder)
        )
        let editTaskButton = UIBarButtonItem(
            image: UIImage(systemName: mode == .edit ? "square.and.pencil" : "square.text.square"),
            style: .done,
            target: self,
            action: #selector(editTask)
        )
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.tintColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        
        navigationItem.rightBarButtonItem = editTaskButton
        navigationItem.leftBarButtonItem = changeFolderButton
        
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
        
        // MARK: - create textField and TexView
        
        let textField = UITextField()
        textField.placeholder = "Title for new task"
        textField.textAlignment = .natural
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .none
        textField.layer.borderWidth = mode == .edit ? 1 : 0
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        textField.isEnabled = mode == .edit
        
        titleTaskTextField = textField
        
        titleTaskTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTaskTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.textAlignment = .natural
        textView.layer.borderWidth = mode == .edit ? 1 : 0
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        textView.dataDetectorTypes = [.all]
        textView.allowsEditingTextAttributes = true
        textView.keyboardDismissMode = .onDrag
        textView.keyboardType = .twitter
        textView.autocapitalizationType = UITextAutocapitalizationType.sentences
        textView.isEditable = mode == .edit
        
        noteTaskTextView = textView
        
        let title = UILabel()
        title.text = "Title:"
        title.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        title.font = .systemFont(ofSize: 13)
        
        let note = UILabel()
        note.text = "Your Task"
        note.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        note.font = .systemFont(ofSize: 13)
        
        let stackV = UIStackView(arrangedSubviews: [title, titleTaskTextField, note, noteTaskTextView])
        
        stackV.axis = .vertical
        stackV.spacing = 2
        stackV.distribution = UIStackView.Distribution.fill
        
        view.addSubview(stackV)
        
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stackV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}


