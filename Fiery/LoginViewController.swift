//
//  LoginViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private let _emailField = RegistrationTextField()
    private let _passwordField = RegistrationTextField()
    
    private let _confirmButton = RegistrationButton()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        _emailField.keyboardType = .EmailAddress
        _emailField.autocapitalizationType = .None
        _emailField.autocorrectionType = .No
        _emailField.placeholder = "emaily@mcEmailFace.com"
        view.addSubview(_emailField)
        
        _passwordField.secureTextEntry = true
        _passwordField.placeholder = "Secret Pass"
        view.addSubview(_passwordField)
        
        _confirmButton.setTitle("Login", forState: .Normal)
        _confirmButton.addTarget(self, action: #selector(LoginViewController.confirmButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(_confirmButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let textFieldframe = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 60, 40)
        let viewCenter = view.center
        
        _emailField.frame = textFieldframe
        _emailField.center = CGPointMake(viewCenter.x, viewCenter.y - 50)
        
        _passwordField.frame = textFieldframe
        _passwordField.center = viewCenter
        
        let buttonFrame = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 100, 40)
        _confirmButton.frame = buttonFrame
        _confirmButton.center = CGPointMake(viewCenter.x, viewCenter.y + 50)
    }
    
//    MARK: Action Responders
    
    func confirmButtonTapped() {
        
        if let (email, password) = loginFieldsValid() {
            
            login(email, password: password)
        }
    }
    
//    MARK: Validators
    
    func loginFieldsValid() -> (email: String, password: String)? {
        
        let emailString = _emailField.text
        if !emailValid(emailString) {
            return nil
        }
        
        let passwordString = _passwordField.text
        if !passwordValid(passwordString) {
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
        
        FirebaseDataManager.loginWithCredentials(email, password: password) { (success) in
            
            if success {
                
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}
