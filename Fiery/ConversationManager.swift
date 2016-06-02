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
        
        getOneTimeValue { (snapshot) in
            if !(snapshot?.value is NSNull) {
                self.handleBulkMessages(snapshot!)
            }
            self.startObserveringChanges()
            complete()
        }
    }
    
    private func startObserveringChanges() {
        
        startObserveringEvent(.ChildChanged) { (snapshot) in
            
            if snapshot.value is NSNull {
                print("ConversationManager | Got null snapshot")
            } else {
                self.handleNewMessage(snapshot)
            }
        }
    }
    
    private func handleBulkMessages(snapshot:FIRDataSnapshot) {
        
        print("ConversationManager | Got \(snapshot.childrenCount) Messages")

        for child in snapshot.children {
            if let snap = child as? FIRDataSnapshot {
                handleNewMessage(snap)
            }
        }
    }
    
    private func handleNewMessage(snapshot: FIRDataSnapshot) {
        
        let newMessage = Message(snapshot: snapshot)
        
        if let messageId = newMessage.snapshotKey() {
            _messages[messageId] = newMessage
            delegate?.messageUpdated(self, message: newMessage)
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
                    
                    if let messageSenderId = lastMessage.senderId(),
                        let myId = RootDataManager.sharedInstance.currentUser()?.userId() {
                        
                        if messageSenderId == myId {
                            
                            messageString = "You: " + messageString!
                        }
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
    
    func messageUpdated(manager: ConversationManager, message: Message)
}
