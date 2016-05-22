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
            
            if snapshot.value is NSNull {
                print("ConversationManager | Got null snapshot")
            } else {
                print("ConversationManager | Got new Message")
                self.handleNewMessage(snapshot)
            }
        }
        
        getOneTimeValue { (snapshot) in
            complete()
        }
    }
    
    private func handleNewMessage(snapshot: FIRDataSnapshot) {
        
        let newMessage = Message(snapshot: snapshot)
        
        if let messageId = newMessage.snapshotKey() {
            _messages[messageId] = newMessage
            
            delegate?.newMessageAdded(newMessage)
        }
    }
    
    func messagesByDate() -> [Message] {
        
        let messagesArray = Array(_messages.values)
        
        return messagesArray.sort({ (message1, message2) -> Bool in
            if let message1SendDate = message1.sendDateMilliseconds(), let message2SendDate = message2.sendDateMilliseconds() {
                return message1SendDate.doubleValue < message2SendDate.doubleValue
            }
            return false
        })
    }
    
    func sendMessage(body: String) {
        
        if let myUserId = RootDataManager.sharedInstance.currentUser()?.snapshotKey() {
            
            var messageData = [String: AnyObject]()
            messageData[Message.kSenderId] = myUserId
            messageData[Message.kType] = Message.kTextType
            messageData[Message.kBody] = body
            messageData[Message.kSendDate] = FIRServerValue.timestamp()
            
            addChildByAutoID(messageData)
        }
    }
}

protocol ConversationManagerDelegate {
    
    func newMessageAdded(message: Message)
}
