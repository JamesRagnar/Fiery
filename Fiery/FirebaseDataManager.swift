//
//  FirebaseDataManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import Firebase

class FirebaseDataManager {
    
    static func currentUser() -> FIRUser? {
        
        return FIRAuth.auth()?.currentUser
    }

    static func userAuthorized() -> Bool {
        
        return currentUser() != nil
    }
    
    static func loginWithCredentials(email: String, password: String, response: (success: Bool) -> Void) {

        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                response(success: false)
            } else {
                response(success: true)
            }
        })
    }
    
    static func registerWithCredentials(name: String, email: String, password: String, response: (success: Bool) -> Void) {

        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                response(success: false)
            } else {
                setNewUserData(name, response: response)
            }
        })
    }
    
    private static func setNewUserData(name: String, response: (success: Bool) -> Void) {
        
        
    }
}
