//
//  ViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkUserStatus()
    }
    
    private func checkUserStatus() {
        
        if FirebaseDataManager.userAuthorized() {
            openConversationView()
        } else {
            openRegistrationView()
        }
    }
    
    private func openRegistrationView() {
        
        let regVC = AuthenticationViewController()
        openNavigationController(regVC)
    }
    
    private func openConversationView() {
        
        let conVC = ConversationsViewController()
        openNavigationController(conVC)
    }
    
    private func openNavigationController(rootVC: UIViewController) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let navVC = UINavigationController(rootViewController: rootVC)
            self.presentViewController(navVC, animated: false, completion: nil)
        }
    }
}

