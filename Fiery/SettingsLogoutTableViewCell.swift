//
//  SettingsLogoutTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-29.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class SettingsLogoutTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        textLabel?.textColor = UIColor.redColor()
        textLabel?.textAlignment = .Center
        textLabel?.text = "Logout"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = contentView.bounds
    }
}
