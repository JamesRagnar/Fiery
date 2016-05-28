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
    private static let _kMessagesRef = "messages"
    
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
    
    static func messagesRef() -> FIRDatabaseReference {
        return rootRef().child(_kMessagesRef)
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
    
    //    MARK: Registration
    
    static func loginWithCredentials(email: String, password: String, response: (success: Bool, error: NSError?) -> Void) {
        
        if let auth = FIRAuth.auth() {
            auth.signInWithEmail(email, password: password, completion: { (user, error) in
                response(success: error == nil, error: error)
            })
        } else {
            print("FirebaseDataManager | Auth is nil")
            response(success: false, error: nil)
        }
    }
    
    static func registerWithCredentials(name: String, image: UIImage?, email: String, password: String, response: (success: Bool, error: NSError?) -> Void) {
        
        if let auth = FIRAuth.auth() {
            
            auth.createUserWithEmail(email, password: password, completion: { (user, error) in
                if error != nil {
                    response(success: false, error: error)
                } else {
                    setNewUserData(name, image: image, email: email, response: response)
                }
            })
        } else {
            print("FirebaseDataManager | Auth is nil")
            response(success: false, error: nil)
        }
    }
    
    private static func setNewUserData(name: String, image: UIImage?, email: String, response: (success: Bool, error: NSError?) -> Void) {
        
        if let myRef = myUserRef() {
            
            var updateData = [String: AnyObject]()
            updateData[User.kName] = name
            updateData[User.kEmail] = email
            
            myRef.updateChildValues(updateData, withCompletionBlock: { (error, database) in
                response(success: error == nil, error: error)
            })
            
            // Optional. Upload and save the user image
            updateUserImage(image)
            
        } else {
            print("Registration | Could not get myUserRef")
            response(success: false, error: nil)
        }
    }
    
    private static func updateUserImage(image: UIImage?) {
        
        if let uploadImage = image, let myRef = myUserRef() {
            
            FirebaseStorageManager.updateUserProfileImage(uploadImage, response: { (imageUrl) in
                
                // Update my user object with image ref
                let imageRef = myRef.child(User.kImageUrl)
                imageRef.setValue(imageUrl)
            })
        }
    }
    
    //    MARK: Query
    
    static func queryUsersByEmailWithString(queryString: String, results: (users: [User]) -> Void) {
        
        let lowercaseString = queryString.lowercaseString
        
        print("FirebaseDataManager | Searching Users | " + queryString)
        
        let usersRef = FirebaseDataManager.usersRef()
        
        let query: FIRDatabaseQuery = usersRef.queryOrderedByChild("email").queryEqualToValue(lowercaseString)
        
        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            print("FirebaseDataManager | Search Results | \(snapshot.childrenCount)")
            
            var returnUsers = [User]()
            
            if let myId = RootDataManager.sharedInstance.currentUser()?.userId() {
                
                for child in snapshot.children {
                    
                    if let childSnapshot = child as? FIRDataSnapshot {
                        
                        let user = User(snapshot: childSnapshot)
                        
                        if let userId = user.userId() {
                            
                            if userId != myId {
                                returnUsers.append(user)
                            }
                        }
                    }
                }
            }
            results(users: returnUsers)
        })
    }
}
