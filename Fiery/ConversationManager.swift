//
//  ConversationManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Firebase

class ConversationManager: FSOReferenceObserver {
    
    private var _messages = [String: Message]()
    
    var delegate: ConversationManagerDelegate?
    
    func fetchAndMonitorMessages(complete: () -> Void) {
        
        print("ConversationManager | Started Observeration")
        
        startObserveringEvent(.ChildAdded) { (snapshot) in
            self.handleNewMessage(snapshot)
        }
        
        startObserveringEvent(.ChildChanged) { (snapshot) in
            self.handleUpdatedMessage(snapshot)
        }
        
        getOneTimeValue { (snapshot) in
            complete()
        }
    }
    
    private func handleNewMessage(snapshot: FIRDataSnapshot) {
        
        let messageId = snapshot.ref.key
        
        print("ConversationManager | New Message | " + messageId)
        
        let newMessage = Message(snapshot: snapshot)
        _messages[messageId] = newMessage
        delegate?.messageAdded(self, message: newMessage)
    }
    
    private func handleUpdatedMessage(snapshot: FIRDataSnapshot) {
        
        let messageId = snapshot.ref.key
        
        if let existingMessage = _messages[messageId] {
            
            print("ConversationManager | Updated Message | " + messageId)
            
            existingMessage.dataSnapshot = snapshot
            delegate?.messageUpdated(self, message: existingMessage)
            
        } else {
            print("ConversationManager | Error | Could Not Find Existing Message | " + messageId)
        }
    }
    
    //    MARK: Accessors
    
    func messagesByDate() -> [Message] {
        
        let messagesArray = Array(_messages.values)
        
        return messagesArray.sort({ (message1, message2) -> Bool in
            if let message1SendDate = message1.sendDateMilliseconds(), let message2SendDate = message2.sendDateMilliseconds() {
                return message1SendDate.doubleValue < message2SendDate.doubleValue
            }
            return false
        })
    }
    
    func conversationDetailContext() -> String? {
        
        if let lastMessage = messagesByDate().last {
            
            if let contentType = lastMessage.type() {
                
                var messageString: String?
                
                switch contentType {
                case Message.kTextType:
                    messageString = lastMessage.messageText()
                case Message.kImageType:
                    messageString = "Sent an Image"
                default:
                    break
                }
                
                if messageString != nil {
                    if lastMessage.iAmSender() {
                        messageString = "You: " + messageString!
                    }
                }
                
                return messageString
            }
        }
        
        return nil
    }
    
    //    MARK: Messaging
    
    func sendTextMessage(text: String) {
        
        if let myUserId = RootDataManager.sharedInstance.currentUser()?.snapshotKey() {
            
            var messageData = [String: AnyObject]()
            messageData[Message.kSenderId] = myUserId
            messageData[Message.kType] = Message.kTextType
            messageData[Message.kBody] = text
            messageData[Message.kSendDate] = FIRServerValue.timestamp()
            
            addChildByAutoID(messageData)
        }
    }
    
    func sendImageMessage(image: UIImage) {
        
        if let myUserId = RootDataManager.sharedInstance.currentUser()?.snapshotKey() {
            
            FirebaseStorageManager.uploadChatImage(image) { (data) in
                
                if let imageData = data?.dataFormat() {
                    
                    var messageData = [String: AnyObject]()
                    messageData[Message.kSenderId] = myUserId
                    messageData[Message.kType] = Message.kImageType
                    messageData[Message.kBody] = imageData
                    messageData[Message.kSendDate] = FIRServerValue.timestamp()
                    
                    self.addChildByAutoID(messageData)
                }
            }
        }
    }
}

protocol ConversationManagerDelegate {
    
    func messageAdded(manager: ConversationManager, message: Message)
    func messageUpdated(manager: ConversationManager, message: Message)
}
