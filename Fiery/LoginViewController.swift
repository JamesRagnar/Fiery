//
//  LoginViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private let _emailField = UITextField()
    private let _passwordField = UITextField()
    
    private let _confirmButton = UIButton()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        _emailField.backgroundColor = UIColor.grayColor()
        _emailField.keyboardType = .EmailAddress
        _emailField.autocapitalizationType = .None
        _emailField.autocorrectionType = .No
        _emailField.placeholder = "emaily@mcEmailFace.com"
        view.addSubview(_emailField)
        
        _passwordField.backgroundColor = UIColor.grayColor()
        _passwordField.secureTextEntry = true
        _passwordField.placeholder = "Secret Pass"
        view.addSubview(_passwordField)
        
        _confirmButton.backgroundColor = UIColor.grayColor()
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
        
        if let email = _emailField.text, let password = _passwordField.text {
            
            if email.characters.count > 0 && password.characters.count > 0 {
                
                login(email, password: password)
            }
        }
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
