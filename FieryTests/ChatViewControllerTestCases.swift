//
//  ChatViewControllerTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class ChatViewControllerTestCases: XCTestCase {
    
    var chatVC: ChatViewController!
    
    override func setUp() {
        super.setUp()
        chatVC = ChatViewController()
    }
    
    override func tearDown() {
        chatVC = nil
        super.tearDown()
    }
    
    //    MARK: View
    
//    func testView() {
//        let _ = chatVC.view
//    }
    
//    func testLayout() {
//        chatVC.viewWillLayoutSubviews()
//    }
}
