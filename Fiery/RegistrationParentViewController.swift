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
    private let _cancelButton = UIButton()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(contentView)
        
        _cancelButton.setTitle("Cancel", forState: .Normal)
        _cancelButton.setTitleColor(UIColor.fieryGrayColor(), forState: .Normal)
        _cancelButton.addTarget(self, action: #selector(RegistrationParentViewController.cancelButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(_cancelButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _cancelButton.sizeToFit()
        _cancelButton.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetHeight(view.bounds) - 30)
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
    
//    MAR: Action Responders
    
    func cancelButtonTapped() {
        
        navigationController?.popViewControllerAnimated(true)
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
                    
                    let viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), contentViewHeight)
                    self.contentViewUpdated(viewFrame)
                    
                    }, completion: nil)
            }
        }
    }
}
