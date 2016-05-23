//
//  ConnectionsViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class ConnectionViewControllerTestCases: XCTestCase {
    
    var connVC: ConnectionsViewController!
    
    override func setUp() {
        super.setUp()
        connVC = ConnectionsViewController()
    }
    
    override func tearDown() {
        connVC = nil
        super.tearDown()
    }
    
    //    MARK: View
    
    func testView() {
        let _ = connVC.view
    }
    
    func testLayout() {
        connVC.viewWillLayoutSubviews()
    }
}
