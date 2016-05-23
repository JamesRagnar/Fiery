//
//  UIColor+Fiery.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func fieryGrayColor() -> UIColor {
        return fieryGrayColor(1)
    }
    
    class func fieryGrayColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 150.0 / 255.0, green: 140.0 / 255.0, blue: 140.0 / 255.0, alpha: alpha)
    }
    
    class func fieryRedColor() -> UIColor {
        return fieryRedColor(1)
    }
    
    class func fieryRedColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 153.0 / 255.0, green: 61.0 / 255.0, blue: 61.0 / 255.0, alpha: alpha)
    }
}
