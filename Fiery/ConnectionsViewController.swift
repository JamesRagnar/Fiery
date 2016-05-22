//
//  ConversationsViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-20.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Haneke

class ConnectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConnectionManagerDelegate {
    
    private let _userConnectionCell = "UserConnectionCell"

    private let _tableView = UITableView()
    private var _connections = [Connection]()

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        if let userName = RootDataManager.sharedInstance.currentUser()?.name() {
            title = userName
        }
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(ConnectionsViewController.logoutButtonTapped))
        navigationItem.setLeftBarButtonItem(logoutButton, animated: false)
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(ConnectionsViewController.addUserTapped))
        navigationItem.setRightBarButtonItem(searchButton, animated: false)
        
        _tableView.registerClass(ConnectionTableViewCell.self, forCellReuseIdentifier: _userConnectionCell)
        _tableView.dataSource = self
        _tableView.delegate = self
        view.addSubview(_tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let connectionManager = RootDataManager.sharedInstance.connectionsManager()
        
        _connections = connectionManager.allConnections()
        _tableView.reloadData()
        
        connectionManager.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let connectionManager = RootDataManager.sharedInstance.connectionsManager()
        connectionManager.delegate = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _tableView.frame = view.frame
    }
    
//    MARK: ConnectionManagerDelegate
    
    func newConnectionAdded(connection: Connection) {
        print("Conversations | New Connection Added")
        dispatch_async(dispatch_get_main_queue()) {
            if !self._connections.contains(connection) {
                self._connections.append(connection)
                if let row = self._connections.indexOf(connection) {
                    let indexPath = NSIndexPath(forRow: row, inSection: 0)
                    self._tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
//    MARK: Action Responders
    
    func logoutButtonTapped() {
        
        let logoutActionSheet = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .ActionSheet)
        
        logoutActionSheet.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (action) in
            
            self.logout()
        }))
        
        logoutActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
            
        }))
        
        presentViewController(logoutActionSheet, animated: true, completion: nil)
    }
    
    func addUserTapped() {
        
        openUserSearchView()
    }
    
//    MARK: Logout
    
    func logout() {
        
        RootDataManager.sharedInstance.logout()
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
//    MARK: Navigation
    
    func openUserSearchView() {
        
        navigationController?.pushViewController(UserSearchViewController(), animated: true)
    }

    func openChatWithConnection(connection: Connection) {
        
        let chatVC = ChatViewController()
        chatVC.connection = connection
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
//    MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(_userConnectionCell) as! ConnectionTableViewCell
        
        let connection = _connections[indexPath.row]
        
        if let user = connection.user {
            
            cell.textLabel?.text = user.name()
            
            cell.imageView?.image = user.image()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _connections.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let connection = _connections[indexPath.row]
        openChatWithConnection(connection)
    }
}
