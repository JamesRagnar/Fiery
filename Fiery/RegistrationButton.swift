//
//  RegistrationButton.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class RegistrationButton: UIButton {

    init() {
        super.init(frame: CGRectZero)
        
        setBackgroundImage(UIImage.imageWithColor(UIColor.fieryGrayColor()), forState: .Normal)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
