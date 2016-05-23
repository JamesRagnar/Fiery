//
//  Connection.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class Connection: FSOSnapshot {
    
    //    MARK: Field Keys
    
    static let kState = "state"
    static let kConversationId = "conversationId"
    
    static let kOutgoingState = "outgoing"
    static let kIncomingState = "incoming"
    static let kAcceptedSated = "accepted"
    
    //    MARK:
    
    var user: User?
    var conversationManager: ConversationManager?

    //    MARK: Data Observers
    
    func startObservingConnectionData(complete: () -> Void) {
        
        fetchUserWithId { 
            self.setupConversationmanager(complete)
        }
    }
    
    func fetchUserWithId(complete: () -> Void) {
        
        if let userId = peerId() {
            
            let userRef = FirebaseDataManager.usersRef().child(userId)
            
            user = User(nodeRef: userRef)
            user?.startObservingUserData(complete)
        }
    }
    
    func setupConversationmanager(complete: () -> Void) {
        
        if let roomId = conversationId() {
            
            let messagesRef = FirebaseDataManager.messagesRef().child(roomId)
        
            conversationManager = ConversationManager(nodeRef: messagesRef)
            conversationManager?.fetchAndMonitorMessages(complete)
        }
    }
    
    //    MARK: Field Accessors
    
    func peerId() -> String? {
        return snapshotKey()
    }
    
    func conversationId() -> String? {
        return firebaseStringForKey(Connection.kConversationId)
    }
    
    func state() -> String? {
        return firebaseStringForKey(Connection.kState)
    }
}
