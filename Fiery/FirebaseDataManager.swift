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
    
    private static let _kUsersRef = "users"
    private static let _kConnectionsRef = "connections"
    
    //    MARK: Firebase Node References
    
    static func rootRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    static func usersRef() -> FIRDatabaseReference {
        return rootRef().child(_kUsersRef)
    }
    
    static func connectionsRef() -> FIRDatabaseReference {
        return rootRef().child(_kConnectionsRef)
    }
    
    static func myUserRef() -> FIRDatabaseReference? {
        
        if let userId = currentUser()?.uid {
            return usersRef().child(userId)
        }
        return nil
    }
    
    static func myConnectionsRef() -> FIRDatabaseReference? {
        
        if let userId = currentUser()?.uid {
            return connectionsRef().child(userId)
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
                
                // Check if the snapshot has no data
                if snapshot.value is NSNull {
                    response(userData: nil)
                    return
                }
                
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
    
    static func registerWithCredentials(name: String, image: UIImage?, email: String, password: String, response: (success: Bool) -> Void) {
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                response(success: false)
            } else {
                setNewUserData(name, image: image, email: email, response: response)
            }
        })
    }
    
    private static func setNewUserData(name: String, image: UIImage?, email: String, response: (success: Bool) -> Void) {
        
        if let myRef = myUserRef() {
            
            var updateData = [String: AnyObject]()
            updateData[User.kName] = name
            updateData[User.kEmail] = email
            
            myRef.updateChildValues(updateData, withCompletionBlock: { (error, database) in
                
                if error != nil {
                    print(error)
                    response(success: false)
                } else {
                    response(success: true)
                }
            })
            
            if image != nil {
                
                FirebaseStorageManager.updateUserProfileImage(image!, response: { (imageUrl) in
                    
                    // Update my user object with image ref
                    let imageRef = myRef.child(User.kImageUrl)
                    imageRef.setValue(imageUrl)
                })
            }
            
        } else {
            print("Registration | Could not get myUserRef")
            response(success: false)
        }
    }
}
