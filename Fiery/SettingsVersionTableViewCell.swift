//
//  SettingsVersionTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-06-02.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class SettingsVersionTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        textLabel?.textColor = UIColor.fieryGrayColor()
        textLabel?.textAlignment = .Center
        
        let infoDict = NSBundle.mainBundle().infoDictionary
        if let version = infoDict?["CFBundleShortVersionString"] as? String, let build = infoDict?["CFBundleVersion"] as? String {
            textLabel?.text = "v" + version + " (" + build + ")"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = contentView.bounds
    }
}
