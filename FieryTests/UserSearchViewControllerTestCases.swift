//
//  UserSearchViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class UserSearchViewControllerTestCases: XCTestCase {
    
    var searchVC: UserSearchViewController!
    
    override func setUp() {
        super.setUp()
        searchVC = UserSearchViewController()
    }
    
    override func tearDown() {
        searchVC = nil
        super.tearDown()
    }
    
    //    MARK: View
    
    func testView() {
        let _ = searchVC.view
    }
    
    func testLayout() {
        searchVC.viewWillLayoutSubviews()
    }
}
