//
//  User.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Firebase

class User: FSOSnapshot {
    
    //    MARK: Field Keys
    
    static let kName = "name"
    static let kEmail = "email"
    
    static let kProfileImageData = "profileImage"
    
    var updateDelegate: UserUpdateDeletate?
    
    //    MARK: Data Observers
    
    func fetchDataOneTime(response: (success: Bool) -> Void) {
        
        getOneTimeValue { (snapshot) in
            
            let downloadSuccess = self.handleUserData(snapshot)
            
            response(success: downloadSuccess)
        }
    }
    
    func startObservingUserData() {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            self.handleUserData(snapshot)
        }
    }
    
    private func handleUserData(snapshot: FIRDataSnapshot?) -> Bool {
        
        updateDelegate?.userDataUpdated()

        if snapshot == nil {
        
            print("User | Snapshot Null")
            return false
            
        } else if snapshot!.value is NSNull {
            
            print("User | Snapshot Null")
            return false

        } else {
            
            self.dataSnapshot = snapshot
            
            if let userId = self.userId() {
                print("User | \(userId) | Updated")
            } else {
                print("User | Invalid Id")
                return false
            }
            
            return true
        }
    }
    
    //    MARK: Field Accessors
    
    func userId() -> String? {
        return snapshotKey()
    }
    
    func name() -> String? {
        return firebaseStringForKey(User.kName)
    }
    
    func email() -> String? {
        return firebaseStringForKey(User.kEmail)
    }
    
    func profileImageData() -> ImageData? {
        if let imageDict = firebaseDictionaryForKey(User.kProfileImageData) {
            return ImageData(data: imageDict)
        }
        return nil
    }
    
    func imageUrlString() -> String? {
        if let imageData = profileImageData() {
            return imageData.url
        }
        return nil
    }
    
    func imageUrl() -> NSURL? {
        if let urlString = imageUrlString() {
            return NSURL(string: urlString)
        }
        return nil
    }
    
//    MARK: 
    
    func deleteProfileImage() {
        
        let imageData = profileImageData()
        
        if let imageRef = firebaseReference()?.child(User.kProfileImageData) {
            imageRef.removeValueWithCompletionBlock({ (error, ref) in
                if error == nil {
                    print("User | Deleted Image")
                    FirebaseStorageManager.deleteImage(imageData)
                } else {
                    print("User | Error Deleting Image")
                }
            })
        } else {
            print("User | Error Fetching Image Ref")
        }
    }
}

protocol UserUpdateDeletate {
    func userDataUpdated()
}
