//
//  AddTasksViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

class AddTasksViewController: UIViewController {
    
    var delegate: TasksTableViewControllerDelegate!
    var mode: Mode!
    var indexFolder: Int!
    var indexTask: Int!
    var foldersTasks: [FolderTasks]!
    
    var isChange: Bool = false
    
    var titleFolderLabel = UILabel()
    var titleTaskTextField = UITextField()
    var noteTaskTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTexView), name:  UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTexView), name:  UIResponder.keyboardWillHideNotification, object: nil)
        
        createUI()
        titleTaskTextField.delegate = self
        noteTaskTextView.delegate = self
        
        titleFolderLabel.text = foldersTasks[indexFolder].title
        titleTaskTextField.text = foldersTasks[indexFolder].tasks[indexTask].title
        noteTaskTextView.text = foldersTasks[indexFolder].tasks[indexTask].note
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let task = foldersTasks[indexFolder].tasks[indexTask]
        
        guard let title = titleTaskTextField.text else { return }
        guard let note = noteTaskTextView.text else { return }
        
        if title.isEmpty && note.isEmpty {
            foldersTasks[indexFolder].tasks.remove(at: indexTask)
        } else {
            task.title = title
            task.note = note
            StorageManager.shared.save(at: foldersTasks)
            isChange.toggle()
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
        print("Change Folder")
    }
    
    @objc func editTask(_ sender: UIButton) {
        mode?.togle()
        let imageName = mode == .edit ? "square.and.pencil" : "square.text.square"
        let toValue: CGFloat = mode == .edit ? 1 : 0
    
        UIView.animate(withDuration: 1) {
            sender.setImage(UIImage(systemName: imageName), for: .normal)
        }

        noteTaskTextView.animateBorderWidth(toValue: toValue, duration: 0.5)
        titleTaskTextField.animateBorderWidth(toValue: toValue, duration: 0.5)
        
        noteTaskTextView.isEditable = mode == .edit
        
           
        
        
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

extension AddTasksViewController: UITextFieldDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        mode == .edit
    }
}

