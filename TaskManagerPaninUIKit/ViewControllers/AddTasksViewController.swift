//
//  AddTasksViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

protocol AddTasksViewControllerDelegate {
    func update(indexFolder: Int, indexTask: Int, foldersTasks: [FolderTasks], isChange: Bool)
}

class AddTasksViewController: UIViewController {
    
    var delegate: TasksTableViewControllerDelegate!
    var mode: Mode!
    var indexFolder: Int!
    var indexTask: Int!
    var foldersTasks: [FolderTasks]!
    
    var isChange: Bool = false {
        didSet {
            navigationItem.title = folderTasks.title
            titleTaskTextField.text = task.title
            noteTaskTextView.attributedText = task.note.attributedString
        }
    }
    
    var titleFolderLabel = UILabel()
    var titleTaskTextField = UITextField()
    var noteTaskTextView = UITextView()
    var navigationBar = UINavigationBar()
    
    private var folderTasks: FolderTasks {
        foldersTasks[indexFolder]
    }
    private var task: TaskList {
        foldersTasks[indexFolder].tasks[indexTask]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTaskTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTexView),
                                               name:  UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTexView),
                                               name:  UIResponder.keyboardWillHideNotification, object: nil)
        createUI()
        navigationItem.title = folderTasks.title
        titleTaskTextField.text = task.title
        titleTaskTextField.font = UIFont.systemFont(ofSize: 20)
        noteTaskTextView.attributedText = task.note.attributedString
        noteTaskTextView.font = UIFont.systemFont(ofSize: 15)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let title = titleTaskTextField.text else { return }
        guard let note = noteTaskTextView.attributedText else { return }
  
        if title.isEmpty {
            folderTasks.tasks.remove(at: indexTask)
        } else {
            task.title = title
            task.note = AttributedString(nsAttributedString: note)
            StorageManager.shared.save(at: foldersTasks)
            isChange = true
            delegate?.update(indexFolder: indexFolder, foldersTasks: foldersTasks, isChange: isChange)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.noteTaskTextView.resignFirstResponder()
    }
    
    @objc func updateTexView(_ parameter: Notification) {
        let userInfo = parameter.userInfo
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)
        
        if parameter.name == UIResponder.keyboardWillHideNotification {
            noteTaskTextView.contentInset = UIEdgeInsets.zero
        } else {
            noteTaskTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            noteTaskTextView.scrollIndicatorInsets = noteTaskTextView.contentInset
        }
        noteTaskTextView.scrollRangeToVisible(noteTaskTextView.selectedRange)
    }
    
    @objc func changeFolder() {
        
        let stuyryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let changeFolderVC = stuyryboard.instantiateViewController(withIdentifier: "ChangeFoldersTableViewController") as? ChangeFoldersTableViewController else { return }
        changeFolderVC.delegate = self
        changeFolderVC.indexFolder = indexFolder
        changeFolderVC.indexTask = indexTask
        changeFolderVC.foldersTasks = foldersTasks
        present(changeFolderVC, animated: true)
        
        navigationItem.title = "Change Folders"
    }
    
    @objc func editTask(_ sender: UIBarButtonItem) {
        mode?.togle()
        let imageName = mode == .edit ? "square.and.pencil" : "square.text.square"
        let toValue: CGFloat = mode == .edit ? 1 : 0
        
        UIView.animate(withDuration: 1) {
            sender.image = UIImage(systemName: imageName)
        }
        
        noteTaskTextView.animateBorderWidth(toValue: toValue, duration: 0.5)
        titleTaskTextField.animateBorderWidth(toValue: toValue, duration: 0.5)
        
        noteTaskTextView.isEditable = mode == .edit
        titleTaskTextField.isEnabled = mode == .edit
    }
}

extension AddTasksViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        mode == .preview
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        mode == .edit
    }
}

extension AddTasksViewController: AddTasksViewControllerDelegate {
    
    func update(indexFolder: Int, indexTask: Int, foldersTasks: [FolderTasks], isChange: Bool) {
        self.indexFolder = indexFolder
        self.indexTask = indexTask
        self.foldersTasks = foldersTasks
        self.isChange = isChange
    }
}
