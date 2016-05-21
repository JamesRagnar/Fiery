//
//  User.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class User: FSOSnapshot {

//    MARK: Field Keys
    
    static let kName = "name"
    static let kEmail = "email"
    
//    MARK: Data Observers
    
    func startObservingUserData() {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            print("User Data Updated")
            self.dataSnapshot = snapshot
        }
    }
    
//    MARK: Field Getters
    
    func name() -> String? {
        return firebaseStringForKey(User.kName)
    }
    
    func email() -> String? {
        return firebaseStringForKey(User.kEmail)
    }
}
