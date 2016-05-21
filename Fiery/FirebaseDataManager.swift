//
//  FirebaseDataManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import Firebase

class FirebaseDataManager {
    
    //    MARK: Firebase Nodes
    
    private static let _kUsersNode = "users"
    
    //    MARK: Firebase Node References
    
    static func rootRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    static func usersNode() -> FIRDatabaseReference {
        return rootRef().child(_kUsersNode)
    }
    
    static func myUserRef() -> FIRDatabaseReference? {
        
        if let userId = currentUser()?.uid {
            return usersNode().child(userId)
        }
        
        return nil
    }
    
    //    MARK: Auth
    
    static func currentUser() -> FIRUser? {
        
        return FIRAuth.auth()?.currentUser
    }
    
    static func logout() {
        
        do {
            if let auth = FIRAuth.auth() {
                try auth.signOut()
            }
        } catch _ {
            print("Error logging out")
        }
    }
    
    //    MARK: User
    
    static func fetchMyUserData(response: (userData: FIRDataSnapshot?) -> Void) {
        
        if let myRef = myUserRef() {
            
            myRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                response(userData: snapshot)
                return
            })
        } else {
            response(userData: nil)
        }
    }
    
    //    MARK: Registration
    
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
                setNewUserData(name, email: email, response: response)
            }
        })
    }
    
    private static func setNewUserData(name: String, email: String, response: (success: Bool) -> Void) {
        
        if let myRef = myUserRef() {
            
            var updateData = [String: AnyObject]()
            updateData[User.kName] = name
            
            myRef.updateChildValues(updateData, withCompletionBlock: { (error, database) in
                
                if error != nil {
                    print(error)
                    response(success: false)
                } else {
                    response(success: true)
                }
            })
        } else {
            print("Registration | Could not get myUserRef")
            response(success: false)
        }
    }
}
