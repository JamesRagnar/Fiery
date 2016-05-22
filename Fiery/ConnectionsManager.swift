//
//  ConnectionsManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Firebase

class ConnectionsManager: FSOReferenceObserver {

    private var _connections = [String: Connection]()
    
    var delegate: ConnectionManagerDelegate?
    
    func monitorUserConnections() {
        
        print("ConnectionsManager | Started Observeration")
                
        startObserveringEvent(.ChildAdded) { (snapshot) in
            
            if snapshot.value is NSNull {
                print("ConnectionsManager | Got null snapshot")
            } else {
                print("ConnectionsManager | Got new Connection")
                self.handleNewConnection(snapshot)
            }
        }
    }
    
    private func handleNewConnection(snapshot: FIRDataSnapshot) {
        
        let newConnection = Connection(snapshot: snapshot)
        
        if let connectionId = newConnection.snapshotKey(), connectionState = newConnection.state() {
            
            print("Connection | " + connectionId + " | " + connectionState)
            
            _connections[connectionId] = newConnection
            
            newConnection.startObservingConnectionData({ () in
                self.delegate?.newConnectionAdded(newConnection)
            })
        }
    }
    
//    MARK:
    
    func allConnections() -> [Connection] {
        
        let connections = Array(_connections.values)
        return connections
    }
    
//    MARK: Connection Management
    
    func sendConnectionRequestToUser(user: User) {
        
        let currentUser = RootDataManager.sharedInstance.currentUser()
        
        if let peerId = user.snapshotKey(), let myId = currentUser?.snapshotKey() {
            
            if peerId == myId {
                print("Can not connect with myself")
                return
            }
            
            // Create a chat room
            let messagesRef = FirebaseDataManager.messagesRef().childByAutoId()
            let messagesRefId = messagesRef.key
            
            // Add the connection to my list
            var myConnectionData = [String: AnyObject]()
            myConnectionData[Connection.kState] = Connection.kOutgoingState
            myConnectionData[Connection.kConversationId] = messagesRefId
            
            var myUpdateData = [String: AnyObject]()
            myUpdateData[peerId] = myConnectionData
            
            updateChildValues(myUpdateData)
            
            // Add the invitation to the other user's list
            var peerConnectionData = [String: AnyObject]()
            peerConnectionData[Connection.kState] = Connection.kIncomingState
            peerConnectionData[Connection.kConversationId] = messagesRefId
            
            let peerConnectionsRef = FirebaseDataManager.connectionsRef().child(peerId)
            let peerConnectionsObserver = FSOReferenceObserver(nodeRef: peerConnectionsRef)
            
            var peerUpdateData = [String: AnyObject]()
            peerUpdateData[myId] = peerConnectionData
            
            peerConnectionsObserver.updateChildValues(peerUpdateData)
        }
    }
}

protocol ConnectionManagerDelegate {
    func newConnectionAdded(connection: Connection)
}
