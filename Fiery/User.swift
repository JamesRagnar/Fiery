//
//  User.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Haneke

class User: FSOSnapshot {
    
    //    MARK: Field Keys
    
    static let kName = "name"
    static let kEmail = "email"
    static let kImageUrl = "imageUrl"
    
    private var _image = UIImage() // find a filler user image
    
    //    MARK: Data Observers
    
    func startObservingUserData(firstLoadCallback: () -> Void) {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            if snapshot.value is NSNull {
                
                print("User | Snapshot Null")
                
            } else {
                
                self.dataSnapshot = snapshot
                
                if let userId = self.userId() {
                    
                    print("User | \(userId) | Updated")

                }
                
                self.fetchUserImage()
                firstLoadCallback()
            }
        }
    }
    
    func fetchUserImage() {
        if let imageUrl = imageUrl() {
            let imageCache = Shared.imageCache
            imageCache.fetch(URL: imageUrl).onSuccess({ (image) in
                self._image = image
            }).onFailure({ (error) in
                print(error)
            })
        }
    }
    
    //    MARK: Field Accessors
    
    func userId() -> String? {
        return snapshotKey()
    }
    
    func name() -> String? {
        return firebaseStringForKey(User.kName)
    }
    
    func image() -> UIImage {
        return _image
    }
    
    func email() -> String? {
        return firebaseStringForKey(User.kEmail)
    }
    
    func imageUrlString() -> String? {
        return firebaseStringForKey(User.kImageUrl)
    }
    
    func imageUrl() -> NSURL? {
        if let urlString = imageUrlString() {
            return NSURL(string: urlString)
        }
        return nil
    }
}
