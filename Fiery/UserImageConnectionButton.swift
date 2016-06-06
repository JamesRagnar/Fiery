//
//  UserImageConnectionButton.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-28.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserImageConnectionButton: UIButton {

    private let _connectionImage = UIImageView()
    
    init() {
        super.init(frame: CGRectZero)
        
        imageView?.layer.masksToBounds = true
        
        _connectionImage.image = UIImage(named: "check")
        _connectionImage.sizeToFit()
        _connectionImage.alpha = 0
        addSubview(_connectionImage)
    }
    
    func setUserConnected(connected: Bool) {
        
        _connectionImage.alpha = connected ? 1 : 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frameWidth = bounds.width
        let frameHeight = bounds.height
        
        imageView?.layer.cornerRadius = frameWidth / 2.0
        
        let connectionFrame = _connectionImage.bounds
        
        let halfWidth = connectionFrame.size.width / 2.0
        
        _connectionImage.center = CGPointMake(frameWidth - halfWidth, frameHeight - halfWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
