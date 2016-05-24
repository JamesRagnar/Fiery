//
//  RegistrationViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private let _loginButton = RegistrationButton()
    private let _registerButton = RegistrationButton()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        _loginButton.setTitle("Login", forState: .Normal)
        _loginButton.addTarget(self, action: #selector(AuthenticationViewController.loginButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(_loginButton)
        
        _registerButton.setTitle("Register", forState: .Normal)
        _registerButton.addTarget(self, action: #selector(AuthenticationViewController.registrationButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(_registerButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let twoThirdsHeight = CGRectGetHeight(view.frame) * ( 2.0 / 3.0 )
        let viewCenter = view.center
        let buttonFrame = CGRectMake(0, 0, 200, 40)
        
        _loginButton.frame = buttonFrame
        _loginButton.center = CGPointMake(viewCenter.x, twoThirdsHeight - 25)
        
        _registerButton.frame = buttonFrame
        _registerButton.center = CGPointMake(viewCenter.x, twoThirdsHeight + 25)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //    MARK: Action Responders
    
    func loginButtonTapped() {
        
        pushViewController(LoginViewController())
    }
    
    func registrationButtonTapped() {
        
        pushViewController(RegistrationViewController())
    }
    
//    MARK: Naviation
    
    func pushViewController(viewVC: UIViewController) {
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.navigationController?.pushViewController(viewVC, animated: true)
        }
    }
}
