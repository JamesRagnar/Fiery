//
//  ConnectionTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class ConnectionTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView?.layer.cornerRadius = 30
        imageView?.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRectMake(0, 0, 60, 60)
        imageView?.center = CGPointMake(10 + 30, CGRectGetMidY(contentView.bounds))
        
        let leftX = CGRectGetMaxX(imageView!.frame) + 10
        textLabel?.frame = CGRectMake(leftX, 0, CGRectGetWidth(contentView.bounds) - leftX - 10, CGRectGetHeight(contentView.bounds))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
