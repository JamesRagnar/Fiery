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
    
    private var _snapshot: FIRDataSnapshot?
    
    func snapshot() -> FIRDataSnapshot? {
        if ( _snapshot == nil ) {
            print("FSOSnapshot - Firebase Reference is nil")
        }
        return _snapshot
    }
    
    override init(snapshot: FIRDataSnapshot) {
        super.init(snapshot: snapshot)
        _snapshot = snapshot
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
    
    func firebaseDictionaryForKey(key: String) -> NSDictionary? {
        return firebaseValueForKey(key) as? NSDictionary
    }
    
    private func firebaseValueForKey(key: String) -> AnyObject? {
        if let dataDict = snapshot()?.value as? NSDictionary {
            return dataDict[key]
        }
        return nil
    }
}
