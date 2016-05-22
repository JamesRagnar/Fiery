//
//  RootDataManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class RootDataManager {

    static let sharedInstance = RootDataManager()
    
    private var _currentUser: User?
    
    private var _usersManager: UsersManager?
    private var _connectionsManager: ConnectionsManager?
    
//    MARK: Managers
    
    func currentUser() -> User? {
        if _currentUser == nil {
            print("Current user is nil, this is a bad thing")
        }
        return _currentUser
    }
    
    func usersManager() -> UsersManager {
        if _usersManager == nil {
            _usersManager = UsersManager()
        }
        return _usersManager!
    }
    
    func connectionsManager() -> ConnectionsManager {
        if _connectionsManager == nil {
            let myConnectionsRef = FirebaseDataManager.myConnectionsRef()
            assert(myConnectionsRef != nil, "Connection ref accessed before user authenticated")
            _connectionsManager = ConnectionsManager(nodeRef: myConnectionsRef!)
        }
        return _connectionsManager!
    }
    
//    MARK: Auth
    
    func attemptUserLogin(response: (success: Bool) -> Void) {
        
        FirebaseDataManager.fetchMyUserData { (userSnapshot) in
            
            if userSnapshot != nil {
                
                // I am logged in and have a reference to a database node
                self._currentUser = User(snapshot: userSnapshot!)
                self._currentUser?.startObservingUserData()
                
                // Start Monitoring connections
                self.connectionsManager().monitorUserConnections()
                
                response(success: true)
                
            } else {
                response(success: false)
            }
        }
    }
    
    func logout() {
        
        _currentUser = nil
        
        _usersManager = nil
        _connectionsManager = nil
        
        FirebaseDataManager.logout()
    }
}
