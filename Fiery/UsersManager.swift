//
//  UsersManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Firebase

class UsersManager: NSObject {
    
    private var _knownUsers = [String: User]()
    
    static func queryUsersByEmailWithString(queryString: String, results: (users: [User]) -> Void) {
        
        let lowercaseString = queryString.lowercaseString
        
        print(lowercaseString)
        
        let usersRef = FirebaseDataManager.usersRef()
        
        let query: FIRDatabaseQuery = usersRef.queryOrderedByChild("email").queryEqualToValue(lowercaseString)
        
        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            print("Found Results \(snapshot.childrenCount)")
            
            var returnUsers = [User]()
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? FIRDataSnapshot {
                    
                    let user = User(snapshot: childSnapshot)
                    
                    if let _ = user.name() {
                        
                        returnUsers.append(user)
                    }
                }
            }
            
            results(users: returnUsers)
        })
    }
}
