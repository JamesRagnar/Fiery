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
    
    private var _connectionsManager: ConnectionsManager?
    
    //    MARK: Managers
    
    func currentUser() -> User? {
        assert(_currentUser != nil, "CurrentUser has not been set")
        return _currentUser
    }
    
    func connectionsManager() -> ConnectionsManager {
        if _connectionsManager == nil {
            let myConnectionsRef = FirebaseDataManager.myConnectionsRef()
            _connectionsManager = ConnectionsManager(nodeRef: myConnectionsRef)
        }
        return _connectionsManager!
    }
    
    //    MARK: Auth
    
    func attemptUserLogin(response: (success: Bool) -> Void) {
        
        if let myRef = FirebaseDataManager.myUserRef() {
            
            _currentUser = User(nodeRef: myRef)
            _currentUser?.startObservingUserData({
                
                self.connectionsManager().monitorUserConnections()
                response(success: true)
                
            })
        } else {
            response(success: false)
        }   
    }
    
    func logout() {
        
        _currentUser = nil
        _connectionsManager = nil
        FirebaseDataManager.logout()
    }
}
