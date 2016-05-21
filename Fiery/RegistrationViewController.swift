//
//  RegistrationViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    private let _nameField = UITextField()
    private let _emailField = UITextField()
    private let _passwordField = UITextField()
    
    private let _confirmButton = UIButton()

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        _nameField.backgroundColor = UIColor.grayColor()
        _nameField.autocorrectionType = .No
        _nameField.placeholder = "Name"
        view.addSubview(_nameField)
        
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
        _confirmButton.setTitle("Register", forState: .Normal)
        _confirmButton.addTarget(self, action: #selector(RegistrationViewController.confirmButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(_confirmButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let textFieldframe = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 60, 40)
        let viewCenter = view.center
        
        _nameField.frame = textFieldframe
        _nameField.center = CGPointMake(viewCenter.x, viewCenter.y - 50)
        
        _emailField.frame = textFieldframe
        _emailField.center = viewCenter
        
        _passwordField.frame = textFieldframe
        _passwordField.center = CGPointMake(viewCenter.x, viewCenter.y + 50)
        
        let buttonFrame = CGRectMake(0, 0, CGRectGetWidth(view.frame) - 100, 40)
        _confirmButton.frame = buttonFrame
        _confirmButton.center = CGPointMake(viewCenter.x, viewCenter.y + 100)
    }
    
    //    MARK: Action Responders
    
    func confirmButtonTapped() {
        
        if let name = _nameField.text, let email = _emailField.text, let password = _passwordField.text {
            
            if name.characters.count > 0 && email.characters.count > 0 && password.characters.count > 0 {
                
                login(name, email: email, password: password)
            }
        }
    }
    
    //    MARK: Login
    
    func login(name: String, email: String, password: String) {
        
        FirebaseDataManager.registerWithCredentials(name, email:email, password: password) { (success) in
            
            if success {
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
