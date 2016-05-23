//
//  ConnectionTableViewCellTestCases.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import XCTest
@testable import Fiery
class ConnectionTableViewCellTestCases: XCTestCase {
    
    var connCell: ConnectionTableViewCell!
    
    override func setUp() {
        super.setUp()
        connCell = ConnectionTableViewCell(style: .Default, reuseIdentifier: "")
    }
    
    override func tearDown() {
        connCell = nil
        super.tearDown()
    }
    
    //    MARK: View
    
    func testView() {
        let _ = connCell.contentView
    }
    
    func testLayout() {
        connCell.layoutSubviews()
    }
}
