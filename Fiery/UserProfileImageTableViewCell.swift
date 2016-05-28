//
//  UserProfileImageTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserProfileImageTableViewCell: UserProfileTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView?.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageDiameter = CGRectGetHeight(contentView.bounds) - 20
        
        imageView?.frame = CGRectMake(0, 0, imageDiameter, imageDiameter)
        imageView?.layer.cornerRadius = imageDiameter / 2.0
        imageView?.center = contentView.center
    }
    
    override func loadWithUser(user: User?) {
        super.loadWithUser(user)
        
        ImageCacheManager.fetchUserImage(user) { (image) in
            self.imageView?.image = image
        }
    }
}
