//
//  UserSearchResultTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-28.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserSearchResultTableViewCell: UITableViewCell {

    let userImageButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImageButton.layer.cornerRadius = 45
        userImageButton.layer.masksToBounds = true
        contentView.addSubview(userImageButton)
        
        textLabel?.font = UIFont.systemFontOfSize(20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageButton.frame = CGRectMake(0, 0, 90, 90)
        userImageButton.center = CGPointMake(20 + 45, CGRectGetMidY(contentView.bounds))
        
        let leftX = CGRectGetMaxX(userImageButton.frame) + 20
        textLabel?.frame = CGRectMake(leftX, 0, CGRectGetWidth(contentView.bounds) - leftX - 20, CGRectGetHeight(contentView.bounds))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageButton.setImage(nil, forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadWithUser(user: User) {
        
        textLabel?.text = user.name()
        
        ImageCacheManager.fetchImageWithUrl(user.imageUrl()) { (image) in
            self.userImageButton.setImage(image, forState: .Normal)
        }
    }
}
