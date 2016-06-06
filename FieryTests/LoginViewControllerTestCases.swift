//
//  LoginViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery

class LoginViewControllerTestCases: XCTestCase {

    var loginVC: LoginViewController!
    
    override func setUp() {
        super.setUp()
        loginVC = LoginViewController()
    }
    
    override func tearDown() {
        loginVC = nil
        super.tearDown()
    }
    
//    MARK: View
    
    func testView() {
        let _ = loginVC.view
    }
    
    func testLayout() {
        loginVC.viewWillLayoutSubviews()
    }
    
//    MARK: Email
    
    func testNilEmail() {
        let emailValid = loginVC.emailValid(nil)
        XCTAssert(emailValid == false)
    }
    
    func testValidEmail() {
        let testString = "email@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testDotInAddressEmail() {
        let testString = "firstname.lastname@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testDotInSubdomainEmail() {
        let testString = "email@subdomain.domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testPlusSignEmail() {
        let testString = "firstname+lastname@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testNumericEmail() {
        let testString = "1234567890@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testDashInDomainEmail() {
        let testString = "email@domain-one.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testUnderscoreEmail() {
        let testString = "_______@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testNameTLDEmail() {
        let testString = "email@domain.name"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testDotInTLDEmail() {
        let testString = "email@domain.co.jp"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testDashEmail() {
        let testString = "firstname-lastname@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == true)
    }
    
    func testPlainTextEmail() {
        let testString = "plainaddress"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testGarbageEmail() {
        let testString = "#@%^%#$@#$@#.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testMissingUsernameEmail() {
        let testString = "@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testEncodedHTMLEmail() {
        let testString = "Joe Smith <email@domain.com>"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testMissingAtEmail() {
        let testString = "email.domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testDoubleAtEmail() {
        let testString = "email@domain@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testUnicodeEmail() {
        let testString = "あいうえお@domain.com"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testTrailingTextEmail() {
        let testString = "email@domain.com (Joe Smith)"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testMissingTLDEmail() {
        let testString = "email@domain"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    func testInvalidIPEmail() {
        let testString = "email@111.222.333.44444"
        let emailValid = loginVC.emailValid(testString)
        XCTAssert(emailValid == false)
    }
    
    // Password
    
    func testNilPassword() {
        let passwordValid = loginVC.passwordValid(nil)
        XCTAssert(passwordValid == false)
    }
    
    func testEmptyPassword() {
        let testString = ""
        let passwordValid = loginVC.passwordValid(testString)
        XCTAssert(passwordValid == false)
    }
    
    func testShortPassword() {
        let testString = "123"
        let passwordValid = loginVC.passwordValid(testString)
        XCTAssert(passwordValid == false)
    }
    
    func testValidPassword() {
        let testString = "1234567"
        let passwordValid = loginVC.passwordValid(testString)
        XCTAssert(passwordValid == true)
    }
}
