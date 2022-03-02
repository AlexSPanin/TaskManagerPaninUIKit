//
//  ExtentionMainFoldersTableViewController.swift
//  TaskManagerPaninUIKit
//
//  Created by Александр Панин on 02.03.2022.
//

import UIKit

// MARK: - Create Bar Buttons

extension MainFoldersTableViewController {
    
func setupNavigationBar() {
        guard let navigation = navigationController else { return }
        
        let addFolderButton = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .done,
            target: self,
            action: #selector(addFolder))
        
        let addTaskButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .done,
            target: self,
            action: #selector(addTask))
        
        title = "Folders"
        navigation.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        navigation.navigationBar.standardAppearance = navBarAppearance
        navigation.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = addTaskButton
        navigationItem.leftBarButtonItem = addFolderButton
        navigation.navigationBar.tintColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    }
}
