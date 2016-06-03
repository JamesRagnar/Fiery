//
//  SettingsEmailTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-06-03.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class SettingsEmailTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        textLabel?.textColor = UIColor.fieryGrayColor()
        textLabel?.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = contentView.bounds
    }
}
