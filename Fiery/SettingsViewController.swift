//
//  SettingsViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-29.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func loadView() {
        super.loadView()
        
        
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
    
    //    MARK: Logout
    
    func logout() {
        
        RootDataManager.sharedInstance.logout()
        
        dismissViewControllerAnimated(false, completion: nil)
    }
}
