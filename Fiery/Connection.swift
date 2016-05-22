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
    
    static let kOutgoingState = "outgoing"
    static let kIncomingState = "incoming"
    static let kAcceptedSated = "accepted"
    
    //    MARK:
    
    var user: User?
    
    //    MARK: Data Observers
    
    func startObservingConnectionData() {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            print("Connection Data Updated")
            self.dataSnapshot = snapshot
        }
    }
    
    func fetchUserWithId(response: (user: User?) -> Void) {
        
        if let userId = peerId() {
            
            let userRef = FirebaseDataManager.usersRef().child(userId)
            
            user = User(nodeRef: userRef)
            user?.startObservingUserData()
        }
    }
    
    //    MARK: Field Accessors
    
    func peerId() -> String? {
        return snapshotKey()
    }
    
    func state() -> String? {
        return firebaseStringForKey(Connection.kState)
    }
}
