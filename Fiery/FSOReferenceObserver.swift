//
//  FirebaseNodeObserver.swift
//  FirebaseSwiftObserver
//
//  Created by James Harquail on 2016-04-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import Firebase

class FSOReferenceObserver: NSObject {
    
    private var _firebaseReference: FIRDatabaseReference?
    
    func firebaseReference() -> FIRDatabaseReference? {
        if _firebaseReference == nil {
            print("FSOReferenceObserver - Firebase Reference is nil")
        }
        return _firebaseReference
    }

    private var _eventHandles = [FIRDataEventType: UInt]()
    
    init(nodeRef: FIRDatabaseReference) {
        _firebaseReference = nodeRef
    }
    
    init(snapshot: FIRDataSnapshot) {
        _firebaseReference = snapshot.ref
    }
    
    //    MARK: READ
    
    func startObserveringEvent(event: FIRDataEventType, response: ((snapshot: FIRDataSnapshot) -> Void)?) {
        
        if _eventHandles.keys.contains(event) {
            print("FSOReferenceObserver - Already observing event type \(event)")
            return
        }
        
        _eventHandles[event] = firebaseReference()?.observeEventType(event, withBlock: { (snapshot) in
            response?(snapshot: snapshot)
        })
    }
    
    func getOneTimeValue(response: (snapshot: FIRDataSnapshot?) -> Void) {
        
        firebaseReference()?.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            response(snapshot: snapshot)
        })
    }
    
    //    MARK: WRITE
    
    func addChildByAutoID(data: [String: AnyObject]?) -> FSOReferenceObserver? {
        
        if let newChild = firebaseReference()?.childByAutoId() {
            
            let newNodeObserver = FSOReferenceObserver(nodeRef: newChild)
            if ( data != nil ) {
                newNodeObserver.updateChildValues(data!)
            }
            return newNodeObserver
        }
        
        return nil
    }
    
    func updateChildValues(data: [String: AnyObject]) {

        firebaseReference()?.updateChildValues(data)
    }
    
//    MARK:
    
    func stopObservingEvents() {
        for eventHandle in _eventHandles.values {
            print("Stopping Observer For Event - \(eventHandle)")
            firebaseReference()?.removeObserverWithHandle(eventHandle)
        }
    }

    deinit {
        stopObservingEvents()
    }
}
