//
//  FirebaseNode.swift
//  FirebaseSwiftObserver
//
//  Created by James Harquail on 2016-04-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Firebase

class FSOSnapshot: FSOReferenceObserver {
    
    var dataSnapshot: FIRDataSnapshot?
    
    func snapshot() -> FIRDataSnapshot? {
        if ( dataSnapshot == nil ) {
            print("FSOSnapshot - Firebase Reference is nil")
        }
        return dataSnapshot
    }
    
    convenience init(snapshot: FIRDataSnapshot?) {
        self.init(nodeRef: snapshot?.ref)
        dataSnapshot = snapshot
    }

    //    MARK: Snapshot Operations
    
    func snapshotKey() -> String? {
        return snapshot()?.ref.key
    }
    
    func isValid() -> Bool {
        return snapshotKey() != nil
    }
    
    //    MARK: Snapshot Accessors
    
    func firebaseStringForKey(key: String) -> String? {
        return firebaseValueForKey(key) as? String
    }
    
    func firebaseNumberForKey(key: String) -> NSNumber? {
        return firebaseValueForKey(key) as? NSNumber
    }
    
    func firebaseBoolForKey(key: String) -> Bool? {
        return firebaseNumberForKey(key)?.boolValue
    }
    
    func firebaseDictionaryForKey(key: String) -> [String: AnyObject]? {
        return firebaseValueForKey(key) as? [String: AnyObject]
    }
    
    private func firebaseValueForKey(key: String) -> AnyObject? {
        if let dataDict = snapshot()?.value as? NSDictionary {
            return dataDict[key]
        }
        return nil
    }
}
