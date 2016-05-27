//
//  RegistrationViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegistrationViewController: RegistrationParentViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let _addPhotoButton = UIButton()
    private let _nameField = RegistrationTextField()
    private let _emailField = RegistrationTextField()
    private let _passwordField = RegistrationTextField()
    private let _confirmButton = RegistrationButton()
    
    private var _selectedImage: UIImage?
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        _addPhotoButton.backgroundColor = UIColor.fieryGrayColor()
        _addPhotoButton.layer.masksToBounds = true
        _addPhotoButton.setTitle("Add Photo", forState: .Normal)
        _addPhotoButton.addTarget(self, action: #selector(RegistrationViewController.addPhotoButtonTapped), forControlEvents: .TouchUpInside)
        contentView.addSubview(_addPhotoButton)
        
        _nameField.autocorrectionType = .No
        _nameField.placeholder = "Name"
        _nameField.delegate = self
        contentView.addSubview(_nameField)
        
        _emailField.keyboardType = .EmailAddress
        _emailField.autocapitalizationType = .None
        _emailField.autocorrectionType = .No
        _emailField.placeholder = "Email"
        _emailField.delegate = self
        contentView.addSubview(_emailField)
        
        _passwordField.secureTextEntry = true
        _passwordField.placeholder = "Password"
        _passwordField.delegate = self
        contentView.addSubview(_passwordField)
        
        _confirmButton.setTitle("Register", forState: .Normal)
        _confirmButton.addTarget(self, action: #selector(RegistrationViewController.confirmButtonTapped), forControlEvents: .TouchUpInside)
        contentView.addSubview(_confirmButton)
        
        contentViewUpdated(view.frame)
    }
    
    override func contentViewUpdated(frame: CGRect) {
        super.contentViewUpdated(frame)
        
        let textFieldframe = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 60, 40)
        let buttonFrame = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 100, 40)
        let viewCenter = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds))
        
        _nameField.frame = textFieldframe
        _emailField.frame = textFieldframe
        _passwordField.frame = textFieldframe
        _confirmButton.frame = buttonFrame

        let contentHeight: CGFloat = 40 + 40 + 40 + 40 + 50 + 200

        
        
        if CGRectGetHeight(frame) < contentHeight {
            
            _nameField.center = CGPointMake(viewCenter.x, viewCenter.y - 75)
            _emailField.center = CGPointMake(viewCenter.x, viewCenter.y - 25)
            _passwordField.center = CGPointMake(viewCenter.x, viewCenter.y + 25)
            _confirmButton.center = CGPointMake(viewCenter.x, viewCenter.y + 75)
            
            _addPhotoButton.userInteractionEnabled = false
            _addPhotoButton.alpha = 0.25
            _addPhotoButton.center = viewCenter
            
        } else {
            
            _nameField.center = CGPointMake(viewCenter.x, viewCenter.y - 25)
            _emailField.center = CGPointMake(viewCenter.x, viewCenter.y + 25)
            _passwordField.center = CGPointMake(viewCenter.x, viewCenter.y + 75)
            _confirmButton.center = CGPointMake(viewCenter.x, viewCenter.y + 125)
            
            // Center the image view in the remaining space
            let remainingHeight = (CGRectGetMinY(_nameField.frame) - 20) / 2.0
            
            _addPhotoButton.userInteractionEnabled = true
            _addPhotoButton.alpha = 1
            _addPhotoButton.frame = CGRectMake(0, 0, 160, 160)
            _addPhotoButton.layer.cornerRadius = 80
            _addPhotoButton.center = CGPointMake(viewCenter.x, remainingHeight + 20)
        }
    }
    
    //    MARK: Action Responders
    
    func addPhotoButtonTapped() {
        
        showImagePicker()
    }
    
    func confirmButtonTapped() {
        
        if let (name, email, password) = registrationFieldsValid() {
            register(name, email: email, password: password)
        }
    }
    
    //    MARK: Login
    
    func register(name: String, email: String, password: String) {
        
        FirebaseDataManager.registerWithCredentials(name, image: _selectedImage, email:email, password: password) { (success, error) in
            if success {
                self.dismissViewControllerAnimated(false, completion: nil)
            } else if error != nil {
                print(error)
            }
        }
    }
    
    //    MARK: Validators
    
    func registrationFieldsValid() -> (name: String, email: String, password: String)? {
        
        let nameString = _nameField.text
        if !nameValid(nameString) {
            _nameField.showErrorState()
            return nil
        }
        
        let emailString = _emailField.text
        if !emailValid(emailString) {
            _emailField.showErrorState()
            return nil
        }
        
        let passwordString = _passwordField.text
        if !passwordValid(passwordString) {
            _passwordField.showErrorState()
            return nil
        }
        
        return (nameString!, emailString!, passwordString!)
    }
    
    func nameValid(name: String?) -> Bool {
        
        if let testString = name {
            return testString.characters.count > 0
        }
        return false
    }
    
    func emailValid(email: String?) -> Bool {
        
        if let testString = email {
            return testString.isValidFieryEmail()
        }
        return false
    }
    
    func passwordValid(password: String?) -> Bool {
        
        if let testString = password {
            return testString.isValidFieryPassword()
        }
        return false
    }
    
    //    MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        _nameField.clearErrorState()
        _emailField.clearErrorState()
        _passwordField.clearErrorState()
    }
    
    //    MARK: ImagePicker
    
    func showImagePicker() {
        
        let actionSheet = UIAlertController(title: nil, message: "Change your profile image", preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .Camera
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.cameraCaptureMode = .Photo
                mediaUI.cameraDevice = .Front
                self.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            actionSheet.addAction(UIAlertAction(title: "Select from Library", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .PhotoLibrary
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.mediaTypes = [kUTTypeImage as String]
                self.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == kUTTypeImage as String {
                
                if let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    _selectedImage = croppedImage
                }
                
                _addPhotoButton.setImage(_selectedImage, forState: .Normal)
            }
        }
    }
}
