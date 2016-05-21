//
//  ConversationsViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        if let userName = RootDataManager.sharedInstance.currentUser()?.name() {
            title = userName
        }
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(ConversationsViewController.logoutButtonTapped))
        navigationItem.setLeftBarButtonItem(logoutButton, animated: false)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ConversationsViewController.openUserSearchView))
        navigationItem.setRightBarButtonItem(addButton, animated: false)
    }
    
//    MARK: Action Responders
    
    func logoutButtonTapped() {
        
        let logoutActionSheet = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .ActionSheet)
        
        logoutActionSheet.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (action) in
            
            self.logout()
        }))
        
        logoutActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
            
        }))
        
        presentViewController(logoutActionSheet, animated: true, completion: nil)
    }
    
    func addConversationTapped() {
        
        openUserSearchView()
    }
    
//    MARK: Logout
    
    func logout() {
        
        RootDataManager.sharedInstance.logout()
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
//    MARK: Conversations
    
    func openUserSearchView() {
        
        
    }
}
