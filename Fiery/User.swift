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
    static let kImageUrl = "imageUrl"
    
//    MARK: Data Observers
    
    func startObservingUserData() {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            print("User Data Updated")
            self.dataSnapshot = snapshot
        }
    }
    
    func startObservingUserData(firstLoadCallback: () -> Void) {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            print("User Data Updated")
            self.dataSnapshot = snapshot
            
            firstLoadCallback()
        }
    }
    
//    MARK: Field Accessors
    
    func name() -> String? {
        return firebaseStringForKey(User.kName)
    }
    
    func email() -> String? {
        return firebaseStringForKey(User.kEmail)
    }
}
