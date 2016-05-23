//
//  AuthenticationViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class AuthenticationViewControllerTestCases: XCTestCase {
    
    var authVC: AuthenticationViewController!
    
    override func setUp() {
        super.setUp()
        authVC = AuthenticationViewController()
    }
    
    override func tearDown() {
        authVC = nil
        super.tearDown()
    }
    
    //    MARK: View
    
    func testView() {
        let _ = authVC.view
    }
    
    func testLayout() {
        authVC.viewWillLayoutSubviews()
    }
    
//    MARK: Action Responders
    
    func testLoginButtonAction() {
        authVC.loginButtonTapped()
    }
    
    func testRegistrationButtonTapped() {
        authVC.registrationButtonTapped()
    }
}
