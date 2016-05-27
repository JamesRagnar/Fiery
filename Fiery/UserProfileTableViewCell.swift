//
//  UserProfileTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
