//
//  SettingsTextEntryTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-29.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class SettingsTextEntryTableViewCell: UITableViewCell {
    
    let textField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.font = UIFont.systemFontOfSize(25)
        textField.textAlignment = .Center
        contentView.addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRectMake(20, 0, CGRectGetWidth(contentView.bounds) - 40, CGRectGetHeight(contentView.frame))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
