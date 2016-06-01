//
//  FirebaseStorageManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import Firebase

class FirebaseStorageManager {
    
    
    
    typealias ImageDataResponseBlock = (data: ImageData?) -> Void
    
    private static let _kStorageAddress = "gs://fiery-development.appspot.com"
    
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
    
    static func updateUserProfileImage(image: UIImage, response: ImageDataResponseBlock) {
        
        print("FirebaseStorageManager | Starting User Profile Image Upload")
        
        uploadImageToRef(image, ref: userImagesRef(), response: response)
    }
    
    static func uploadChatImage(image: UIImage, response: ImageDataResponseBlock) {
        
        print("FirebaseStorageManager | Starting Chat Message Image Upload")

        uploadImageToRef(image, ref: messageImagesRef(), response: response)
    }
    
    private static func uploadImageToRef(image: UIImage, ref: FIRStorageReference, response: ImageDataResponseBlock) {
        
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            
            let randomFileName = NSUUID().UUIDString + ".jpeg"
            
            let fileRef = ref.child(randomFileName)
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = fileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
                if error != nil {
                    print("FirebaseStorageManager | Error | Uploading File")
                    print(error)
                    response(data: nil)
                } else {
                    
                    if let downloadUrl = storageMetaData?.downloadURL() {
                        print("FirebaseStorageManager | Completed Upload | " + downloadUrl.description)
                        
                        let imageData = ImageData(url: downloadUrl.description, ref: fileRef.fullPath)
                        response(data: imageData)
                        
                    } else {
                        print("FirebaseStorageManager | Error | No Download URL")
                        response(data: nil)
                    }
                }
            })
            
            uploadTask.observeStatus(.Progress) { snapshot in
                if let progress = snapshot.progress {
                    print("FirebaseStorageManager | Upload Progress | \(progress.completedUnitCount) / \(progress.totalUnitCount)")
                }
            }
            
        } else {
            print("FirebaseStorageManager | Error | Could Not Compress Image")
            response(data: nil)
        }
    }
    
//    MARK: Image Data Structure
    
    
}
