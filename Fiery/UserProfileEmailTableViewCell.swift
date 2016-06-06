//
//  UserProfileEmailTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserProfileEmailTableViewCell: UserProfileTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textColor = UIColor.fieryGrayColor()
        textLabel?.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRectMake(20, 0, CGRectGetWidth(contentView.bounds) - 40, CGRectGetHeight(contentView.bounds))
    }
    
    override func loadWithUser(user: User?) {
        super.loadWithUser(user)
        
        textLabel?.text = user?.email()
    }
}
