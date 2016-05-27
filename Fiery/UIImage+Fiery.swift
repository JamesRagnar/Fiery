//
//  UIImage+Fiery.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-26.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}