//
//  RootDataManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Firebase

class RootDataManager {
    
    static let sharedInstance = RootDataManager()
    
    init() {
        
    }

    func userLoggedIn(response: (userRegistered: Bool) -> Void) {
        
        response(userRegistered: FIRAuth.auth()?.currentUser != nil)
    }
    
    func logInAnonymousUser() {
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in

        }
    }
}
