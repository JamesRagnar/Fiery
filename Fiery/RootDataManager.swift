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
    
//    MARK: Managers
    
    func usersManager() -> UsersManager {
        if _usersManager == nil {
            _usersManager = UsersManager()
        }
        return _usersManager!
    }
    
//    MARK: Auth
    
    func attemptUserLogin(response: (success: Bool) -> Void) {
        
        FirebaseDataManager.fetchMyUserData { (userSnapshot) in
            
            if userSnapshot != nil {
                
                // I am logged in and have a reference to a database node
                self._currentUser = User(snapshot: userSnapshot!)
                self._currentUser?.startObservingUserData()
                response(success: true)
                
            } else {
                response(success: false)
            }
        }
    }
    
    func logout() {
        
        _currentUser = nil
        
        _usersManager = nil
        
        FirebaseDataManager.logout()
    }
}
