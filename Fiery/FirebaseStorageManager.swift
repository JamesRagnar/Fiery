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
    private static let _kMessageImagesRef = "messageImages"
    
    //    MARK: Storage References
    
    static func rootStorageRef() -> FIRStorageReference {
        let storageRef = FIRStorage.storage()
        return storageRef.referenceForURL(_kStorageAddress)
    }
    
    static func userImagesRef() -> FIRStorageReference {
        return rootStorageRef().child(_kUserImagesRef)
    }
    
    static func messageImagesRef() -> FIRStorageReference {
        return rootStorageRef().child(_kMessageImagesRef)
    }
    
    //    MARK: Upload
    
    static func updateUserProfileImage(image: UIImage, response: (imageUrl: String?) -> Void) {
        
        uploadImageToRef(image, ref: userImagesRef(), response: response)
    }
    
    static func uploadChatImage(image: UIImage, response: (imageUrl: String?) -> Void) {
        
        uploadImageToRef(image, ref: messageImagesRef(), response: response)
    }
    
    private static func uploadImageToRef(image: UIImage, ref: FIRStorageReference, response: (imageUrl: String?) -> Void) {
        
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            
            let randomFileName = NSUUID().UUIDString + ".jpg"
            
            let fileRef = ref.child(randomFileName)
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = fileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                if error != nil {
                    print(error)
                    response(imageUrl: nil)
                } else {
                    
                    if let downloadUrl = storageMetaData?.downloadURL() {
                        print(downloadUrl)
                        response(imageUrl: downloadUrl.description)
                    } else {
                        response(imageUrl: nil)
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
            response(imageUrl: nil)
        }
    }
}
