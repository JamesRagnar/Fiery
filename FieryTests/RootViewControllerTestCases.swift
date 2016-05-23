//
//  RootViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class RootViewControllerTestCases: XCTestCase {
    
    var rootVC: RootViewController!
    
    override func setUp() {
        super.setUp()
        rootVC = RootViewController()
    }
    
    override func tearDown() {
        rootVC = nil
        super.tearDown()
    }
    
    //    MARK: View
    
    func testView() {
        let _ = rootVC.view
    }
    
    func testLayout() {
        rootVC.viewWillLayoutSubviews()
    }
}
