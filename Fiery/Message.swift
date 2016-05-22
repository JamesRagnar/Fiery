//
//  Message.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class Message: FSOSnapshot {
    
    //    MARK: Field Keys
    
    static let kSenderId = "senderId"
    static let kType = "type"
    static let kBody = "body"
    static let kSendDate = "sendDate"
    static let kViewDate = "viewDate"
    
    static let kTextType = "text"
    static let kImageType = "image"
    static let kVideoType = "video"
    
    //    MARK: Field Accessors
    
    func senderId() -> String? {
        return firebaseStringForKey(Message.kSenderId)
    }
    
    func type() -> String? {
        if let messageType = firebaseStringForKey(Message.kType) {
            if validMessageTypes().contains(messageType) {
                return messageType
            }
        }
        return nil
    }
    
    func validMessageTypes() -> [String] {
        return [Message.kTextType, Message.kImageType, Message.kVideoType]
    }
    
    func body() -> String? {
        if let messageType = type() {
            switch messageType {
            case Message.kTextType:
                return firebaseStringForKey(Message.kBody)
            case Message.kImageType:
                break
            case Message.kVideoType:
                break
            default:
                break
            }
        }
        return nil
    }
    
    func sendDate() -> NSDate? {
        if let millisecondsSinceEpoch = sendDateMilliseconds() {
            let secondsSinceEpoch = millisecondsSinceEpoch.doubleValue / 100
            return NSDate(timeIntervalSince1970: secondsSinceEpoch)
        }
        return nil
    }
    
    func sendDateMilliseconds() -> NSNumber? {
        return firebaseNumberForKey(Message.kSendDate)
    }
}
