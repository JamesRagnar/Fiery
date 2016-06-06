//
//  LoginViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class LoginViewController: RegistrationParentViewController, UITextFieldDelegate {

    private let _emailField = RegistrationTextField()
    private let _passwordField = RegistrationTextField()
    
    private let _confirmButton = RegistrationButton()
    
    override func loadView() {
        super.loadView()
        
        _emailField.returnKeyType = .Next
        _emailField.keyboardType = .EmailAddress
        _emailField.autocapitalizationType = .None
        _emailField.autocorrectionType = .No
        _emailField.placeholder = "Email"
        contentView.addSubview(_emailField)
        
        _passwordField.returnKeyType = .Go
        _passwordField.secureTextEntry = true
        _passwordField.placeholder = "Password"
        contentView.addSubview(_passwordField)
        
        _confirmButton.setTitle("Login", forState: .Normal)
        _confirmButton.addTarget(self, action: #selector(LoginViewController.confirmButtonTapped), forControlEvents: .TouchUpInside)
        contentView.addSubview(_confirmButton)
        
        contentViewUpdated(view.frame)
    }
    
//    MARK: Content View Layout
    
    override func contentViewUpdated(frame: CGRect) {
        super.contentViewUpdated(frame)
        
        let textFieldframe = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 60, 40)
        let buttonFrame = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 100, 40)
        
        let viewCenter = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds))
        
        _emailField.frame = textFieldframe
        _emailField.center = CGPointMake(viewCenter.x, viewCenter.y - 50)
        _emailField.delegate = self
        
        _passwordField.frame = textFieldframe
        _passwordField.center = viewCenter
        _passwordField.delegate = self
        
        _confirmButton.frame = buttonFrame
        _confirmButton.center = CGPointMake(viewCenter.x, viewCenter.y + 60)
    }
    
//    MARK: Action Responders
    
    func confirmButtonTapped() {
        
        if let (email, password) = loginFieldsValid() {
            
            login(email, password: password)
        }
    }
    
//    MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        _emailField.clearErrorState()
        _passwordField.clearErrorState()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
        case _emailField:
            _passwordField.becomeFirstResponder()
        case _passwordField:
            confirmButtonTapped()
        default:
            break
        }
        
        return false
    }
    
//    MARK: Validators
    
    func loginFieldsValid() -> (email: String, password: String)? {
        
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
        
        return (emailString!, passwordString!)
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
    
//    MARK: Login
    
    func login(email: String, password: String) {
        
        startAuthAttempt()
        
        FirebaseDataManager.loginWithCredentials(email, password: password) { (success, error) in
            
            self.stopAuthAttempt()
            
            if success {
                self.dismissViewControllerAnimated(false, completion: nil)
            } else if error != nil {
                self.showDetailModalForError(error!)
            }
        }
    }
}
