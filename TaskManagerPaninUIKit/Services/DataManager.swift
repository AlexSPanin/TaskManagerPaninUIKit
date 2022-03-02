//
//  DataManager.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 24.02.2022.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData() {
        
        if !UserDefaults.standard.bool(forKey: "Check") {
            let note = """
            https://www.apple.com/ru/
            Overview
            UITextView supports the display of text using custom style information and also supports text editing. You typically use a text view to display multiple lines of text, such as when displaying the body of a large text document.
            This class supports multiple text styles through use of the attributedText property. (Styled text is not supported in versions of iOS earlier than iOS 6.) Setting a value for this property causes the text view to use the style information provided in the attributed string. You can still use the font, textColor, and textAlignment properties to set style attributes, but those properties apply to all of the text in the text view. It’s recommended that you use a text view—and not a UIWebView object—to display both plain and rich text in your app.
            Managing the Keyboard
            When the user taps in an editable text view, that text view becomes the first responder and automatically asks the system to display the associated keyboard. Because the appearance of the keyboard has the potential to obscure portions of your user interface, it is up to you to make sure that does not happen by repositioning any views that might be obscured. Some system views, like table views, help you by scrolling the first responder into view automatically. If the first responder is at the bottom of the scrolling region, however, you may still need to resize or reposition the scroll view itself to ensure the first responder is visible.
            It is your application’s responsibility to dismiss the keyboard at the time of your choosing. You might dismiss the keyboard in response to a specific user action, such as the user tapping a particular button in your user interface. To dismiss the keyboard, send the resignFirstResponder() message to the text view that is currently the first responder. Doing so causes the text view object to end the current editing session (with the delegate object’s consent) and hide the keyboard.
            The appearance of the keyboard itself can be customized using the properties provided by the UITextInputTraits protocol. Text view objects implement this protocol and support the properties it defines. You can use these properties to specify the type of keyboard (ASCII, Numbers, URL, Email, and others) to display. You can also configure the basic text entry behavior of the keyboard, such as whether it supports automatic capitalization and correction of the text.
            """
            let task = TaskList()
            task.title = "UITextView"
            task.note = AttributedString(nsAttributedString: NSAttributedString(string: note))
            
            let folder = FolderTasks()
            folder.isActive = true
            folder.date = Date()
            folder.title = "UIKit - Construct UI for your iOS."
            folder.tasks = [task]
                
            UserDefaults.standard.set(true, forKey: "Check")
            UserDefaults.standard.removeObject(forKey: "Tasks")
            
            var foldersTasks = [FolderTasks]()
            foldersTasks.append(folder)
            
            StorageManager.shared.save(at: foldersTasks)
        }
    }
}
