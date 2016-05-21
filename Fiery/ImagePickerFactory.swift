//
//  ImagePickerFactory.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerFactory: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var _imageReponse: ((image: UIImage?) -> Void)?
    
    func presentImagePicker(presentingVC: UIViewController, response: (image: UIImage?) -> Void) {
        
        let actionSheet = UIAlertController(title: nil, message: "Change your profile image", preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .Camera
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.cameraCaptureMode = .Photo
                mediaUI.cameraDevice = .Front
                presentingVC.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            actionSheet.addAction(UIAlertAction(title: "Select from Library", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .PhotoLibrary
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.mediaTypes = [kUTTypeImage as String]
                presentingVC.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        presentingVC.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
//    MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == kUTTypeImage as String {
                
                if let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    _imageReponse?(image: croppedImage)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        _imageReponse?(image: nil)
    }
}
