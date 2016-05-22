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
    
    //    MARK: Data Observers
    
    func startObservingUserData() {
        
        startObserveringEvent(.Value) { (snapshot) in
            
            print("Connection Data Updated")
            self.dataSnapshot = snapshot
        }
    }
    
    //    MARK: Field Accessors
    
    func state() -> String? {
        return firebaseStringForKey(Connection.kState)
    }
}
