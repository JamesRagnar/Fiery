//
//  RegistrationViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class RegistrationViewControllerTestCases: XCTestCase {
    
    var regVC: RegistrationViewController!
    
    override func setUp() {
        super.setUp()
        regVC = RegistrationViewController()
    }
    
    override func tearDown() {
        regVC = nil
        super.tearDown()
    }
    
    //    MARK: View
    
    func testView() {
        let _ = regVC.view
    }
    
    func testLayout() {
        regVC.viewWillLayoutSubviews()
    }
}
