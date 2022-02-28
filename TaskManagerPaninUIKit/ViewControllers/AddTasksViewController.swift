//
//  AddTasksViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import UIKit

class AddTasksViewController: UIViewController {
    
    var task: TaskList?
    var titleFolder: String?
    
    var titleFolderLabel = UILabel()
    var titleTaskTextField = UITextField()
    var noteTaskTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTexView), name:  UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTexView), name:  UIResponder.keyboardWillHideNotification, object: nil)
        
        createUI()
        
        titleFolderLabel.text = titleFolder ?? ""
        
        titleTaskTextField.text = task?.title ?? ""
        noteTaskTextView.text = task?.note ?? ""
        
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
    
    @objc func shareTask() {
        print("ShareTask")
    }
}
