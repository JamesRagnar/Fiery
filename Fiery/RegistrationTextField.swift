//
//  RegistrationTextField.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-23.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class RegistrationTextField: UITextField {

    private var _barView = UIView()
    
    init() {
        super.init(frame: CGRectZero)
        
        _barView.backgroundColor = UIColor.fieryGrayColor(0.5)
        addSubview(_barView)
    }
    
    func showErrorState() {
        self._barView.backgroundColor = UIColor.fieryRedColor(0.75)
    }
    
    func clearErrorState() {
        self._barView.backgroundColor = UIColor.fieryGrayColor(0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _barView.frame = CGRectMake(0, CGRectGetHeight(frame) - 3, CGRectGetWidth(frame), 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
