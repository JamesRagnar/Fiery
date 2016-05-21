//
//  FirebaseStorageManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import Firebase

class FirebaseStorageManager {
    
    private static let _kStorageAddress = "gs://fiery-405fb.appspot.com"
    
    private static let _kUserImagesRef = "userImages"
    
    //    MARK: Storage References
    
    static func rootStorageRef() -> FIRStorageReference {
        let storageRef = FIRStorage.storage()
        return storageRef.referenceForURL(_kStorageAddress)
    }
    
    static func userImagesRef() -> FIRStorageReference {
        return rootStorageRef().child(_kUserImagesRef)
    }
    
    //    MARK: Upload
    
    static func updateUserProfileImage(image: UIImage, reponse: (imageUrl: String) -> Void) {
        
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            
            let userImageRef = userImagesRef()
            
            let randomFileName = NSUUID().UUIDString + ".jpg"
            
            let fileRef = userImageRef.child(randomFileName)
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = fileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                if error != nil {
                    print(error)
                } else {
                    
                    if let downloadUrl = storageMetaData?.downloadURL() {
                        print(downloadUrl)
                    }
                }
            })
            
            uploadTask.observeStatus(.Progress) { snapshot in
                if let progress = snapshot.progress {
                    let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                    print(percentComplete)
                }
            }
            
        } else {
            print("Could not generate image data")
        }
    }
}
