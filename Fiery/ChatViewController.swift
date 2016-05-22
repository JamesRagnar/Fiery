//
//  ChatViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController, ConversationManagerDelegate {

    private let _currentUser = RootDataManager.sharedInstance.currentUser()!
    
    var connection: Connection!
    
    private var _myUserImage = UIImage()
    private var _peerUserImage = UIImage()
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(_currentUser.snapshotKey() != nil)
        
        assert(connection != nil)
        assert(connection?.user?.snapshotKey() != nil)
        assert(connection?.conversationManager != nil)
        
        if let myName = _currentUser.name() {
            self.senderDisplayName = myName
        } else {
            print("Could not get my user name")
            self.senderDisplayName = ""
        }
        
        if let myId = _currentUser.snapshotKey() {
            self.senderId = myId
        } else {
            fatalError("Could not get my userId")
        }
        
        connection?.conversationManager?.delegate = self
    }
    
//    MARK: Action Responders
    
    override func didPressAccessoryButton(sender: UIButton!) {}
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        connection.conversationManager?.sendMessage(text)
    }
    
//    MARK: ConversationManagerDelegate
    
    func newMessageAdded(message: Message) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.finishReceivingMessageAnimated(true)
        }
    }
    
//    MARK: JSQMessagesViewController
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let messages = connection.conversationManager!.messagesByDate()
        let message = messages[indexPath.row]
        
        return JSQMessage(senderId: message.senderId(), senderDisplayName: "", date: message.sendDate(), text: message.body())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let messages = connection.conversationManager!.messagesByDate()
        let message = messages[indexPath.row]
        
        if message.senderId() == _currentUser.snapshotKey() {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.grayColor())
        } else {
            return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.greenColor())
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = connection.conversationManager!.messagesByDate()[indexPath.row]
        if message.senderId() == _currentUser.snapshotKey() {
            return JSQMessagesAvatarImageFactory.avatarImageWithImage(_myUserImage, diameter: 40)
        } else {
            return JSQMessagesAvatarImageFactory.avatarImageWithImage(_peerUserImage, diameter: 40)
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return connection.conversationManager!.messagesByDate().count
    }
}
