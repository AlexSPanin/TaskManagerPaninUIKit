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
            Приложение для создания текстовых заметок.
            Основные функции
            1) Создание текстовых заметок из папки или с основного экрана.
            2) Редактирование заметок и папок.
            3) Группировка по папкам.
            4) Изменение порядка представления папок и заметок.
            5) Смена папки для заметки.
            6) Удаление папок и заметок.
            7) Режим preview и редактирования у заметок.
            8) Изменение текстовых атрибутов в заметке.
            9) Фоновое сохранение заметок в UserDefaults
            10) Инициализация при установке Тестовой заметкой
            
            Панин А.С.
            
            panin1970@gmail.com
            +7(903) 136-80-04
            """
            let task = TaskList()
            task.title = "Основные функции"
            task.note = AttributedString(nsAttributedString: NSAttributedString(string: note))
            
            let folder = FolderTasks()
            folder.isActive = true
            folder.date = Date()
            folder.title = "Приложение Заметки. Панин А.С."
            folder.tasks = [task]
                
            UserDefaults.standard.set(true, forKey: "Check")
            UserDefaults.standard.removeObject(forKey: "Tasks")
            
            var foldersTasks = [FolderTasks]()
            foldersTasks.append(folder)
            
            StorageManager.shared.save(at: foldersTasks)
        }
    }
}
