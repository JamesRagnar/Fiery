//
//  ChatViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    private let _currentUser = RootDataManager.sharedInstance.currentUser()
    
    private var _connection: Connection?
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(_currentUser != nil)
        assert(_connection != nil)
        assert(_connection?.user != nil)
    }
    
//    MARK: Action Responders
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
}
