//
//  RegistrationParentViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class RegistrationParentViewController: UIViewController {
    
    let contentView = UIView()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(contentView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegistrationParentViewController.keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func contentViewUpdated(frame: CGRect) {
        
        contentView.frame = frame
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for subview in contentView.subviews {
            if subview.isFirstResponder() {
                subview.resignFirstResponder()
            }
        }
    }
    
    //    MARK : Keyboard
    
    func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            if let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                
                let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                
                let contentViewHeight = CGRectGetMinY(endFrame)
                
                UIView.animateWithDuration(duration, delay: NSTimeInterval(0),options: animationCurve, animations: {
                    
                    let viewFrame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), contentViewHeight - 64)
                    self.contentViewUpdated(viewFrame)
                    
                    }, completion: nil)
            }
        }
    }
}
