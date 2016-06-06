//
//  ChatViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices

class ChatViewController: JSQMessagesViewController, ConversationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var connection: Connection!
    
    private var _currentUser: User!
    private var _conversationManager: ConversationManager!
    
    private var _myUserImage = UIImage()
    private var _peerUserImage = UIImage()
    
    private var _messages = [Message]()
    
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _currentUser = RootDataManager.sharedInstance.currentUser()
        assert(_currentUser.userId() != nil)
        senderId = _currentUser.snapshotKey()
        
        assert(connection != nil)
        assert(connection.user != nil)
        
        _conversationManager = connection.conversationManager
        assert(_conversationManager != nil)
        _messages = _conversationManager.messagesByDate()
        
        if let myName = _currentUser.name() {
            self.senderDisplayName = myName
        } else {
            print("Could not get my user name")
            self.senderDisplayName = ""
        }
        
        if let peerName = connection.user?.name() {
            title = peerName
        }
        
        ImageCacheManager.fetchUserImage(_currentUser) { (image) in
            if image != nil {
                self._myUserImage = image!
            }
        }
        
        ImageCacheManager.fetchUserImage(connection.user) { (image) in
            if image != nil {
                self._peerUserImage = image!
            }
        }
        
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _conversationManager.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        _conversationManager.delegate = nil
    }
    
    //    MARK: Action Responders
    
    override func didPressAccessoryButton(sender: UIButton!) {
        showImagePicker()
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        sendTextMessage(text)
    }
    
    //    MARK: Conversation Manager
    
    func sendTextMessage(text: String) {
        _conversationManager.sendTextMessage(text)
        finishSendingMessageAnimated(true)
    }
    
    func sendImageMessage(image: UIImage) {
        _conversationManager.sendImageMessage(image)
        finishSendingMessageAnimated(true)
    }
    
    //    MARK: ConversationManagerDelegate
    
    func messageAdded(manager: ConversationManager, message: Message) {
        print("Chat | Message | " + message.snapshotKey()! + " | Added")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self._messages.append(message)
            self.finishReceivingMessageAnimated(true)
        }
    }
    
    func messageUpdated(manager: ConversationManager, message: Message) {
        print("Chat | Message | " + message.snapshotKey()! + " | Updated")
        if let index = _messages.indexOf(message) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            })
        }
    }
    
    //    MARK: JSQMessagesViewController
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let message = _messages[indexPath.row]
        
        message.markViewed()
        
        if let messageType = message.type() {
            switch messageType {
            case Message.kTextType:
                let messageText = message.messageText() != nil ? message.messageText() : ""
                return JSQMessage(senderId: message.senderId(), senderDisplayName: "", date: message.sendDate(), text: messageText)
            case Message.kImageType:
                
                let mediaData = JSQPhotoMediaItem()
                
                if message.senderId() == _currentUser.snapshotKey() {
                    mediaData.appliesMediaViewMaskAsOutgoing = true
                } else {
                    mediaData.appliesMediaViewMaskAsOutgoing = false
                }
                
                if let image = message.image {
                    mediaData.image = image
                } else {
                    if let url = message.imageUrl() {
                        ImageCacheManager.fetchImageWithUrl(url, response: { (image) in
                            message.image = image
                            dispatch_async(dispatch_get_main_queue(), {
                                self.collectionView.reloadItemsAtIndexPaths([indexPath])
                            })
                        })
                    }
                    
                }
                
                return JSQMessage(senderId: message.senderId(), senderDisplayName: "", date: message.sendDate(), media: mediaData)
                
            default:
                break
            }
        }
        fatalError("Unkown message content type")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = _messages[indexPath.row]
        
        if message.senderId() == _currentUser.snapshotKey() {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.grayColor())
        } else {
            return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.fieryGrayColor())
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = _messages[indexPath.row]
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
        return _messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = _messages[indexPath.row]
        
        var bodyText = ""
        
        if let sendDate = message.sendDate() {
            let timeString = dateFormatter.stringFromDate(sendDate)
            bodyText = "Sent " + timeString
        }
        
        if message.iAmSender() {
            if let viewDate = message.viewDate() {
                let timeString = dateFormatter.stringFromDate(viewDate)
                bodyText = "Seen " + timeString
            }
        }
        
        return NSAttributedString(string: bodyText)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if indexPath.row == _messages.count - 1 {
            return 20
        } else {
            return 0
        }
    }
    
    //    MARK: Image Picker
    
    func showImagePicker() {
        
        let actionSheet = UIAlertController(title: "Send an Image", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .Camera
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.cameraCaptureMode = .Photo
                mediaUI.cameraDevice = .Front
                self.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            actionSheet.addAction(UIAlertAction(title: "Select from Library", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .PhotoLibrary
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.mediaTypes = [kUTTypeImage as String]
                self.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == kUTTypeImage as String {
                
                if let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                    sendImageMessage(croppedImage)
                }
            }
        }
    }
}
