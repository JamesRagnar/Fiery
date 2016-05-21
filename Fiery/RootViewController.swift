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
    
    func checkUserStatus() {
        
        if FirebaseDataManager.userAuthorized() {
            openConversationView()
        } else {
            openRegistrationView()
        }
    }
    
    func openRegistrationView() {
        
        let regVC = AuthenticationViewController()
        openNavigationController(regVC)
    }
    
    func openConversationView() {
        
        let conVC = ConversationsViewController()
        openNavigationController(conVC)
    }
    
    func openNavigationController(rootVC: UIViewController) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let navVC = UINavigationController(rootViewController: rootVC)
//            navVC.setNavigationBarHidden(true, animated: false)
            self.presentViewController(navVC, animated: false, completion: nil)
        }
    }
}

