//
//  UserProfileNameTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserProfileNameTableViewCell: UserProfileTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textAlignment = .Center
        textLabel?.font = UIFont.systemFontOfSize(25)
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
        
        textLabel?.text = user?.name()
    }
}
