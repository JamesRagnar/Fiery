//
//  UserSearchViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-21.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let _userSearchCell = "UserSearchCell"
    
    private let _tableView = UITableView()
    private let _searchController = UISearchController(searchResultsController: nil)
    
    private var _searchQuery: String?
    private var _searchResults = [String: [User]]()
    
    override func loadView() {
        super.loadView()
        
        title = "Search"
        
        _tableView.registerClass(UserSearchResultTableViewCell.self, forCellReuseIdentifier: _userSearchCell)
        _tableView.dataSource = self
        _tableView.delegate = self
        view.addSubview(_tableView)
        
        _searchController.searchBar.autocorrectionType = .No
        _searchController.searchBar.autocapitalizationType = .None
        _searchController.searchBar.placeholder = "Search by Email"
        _searchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        _searchController.searchBar.delegate = self
        _searchController.dimsBackgroundDuringPresentation = false
        _searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        _tableView.tableHeaderView = _searchController.searchBar
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _tableView.frame = view.frame
    }
    
    //    MARK: UISearchControllerDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let queryString = _searchController.searchBar.text {
            if queryString.characters.count != 0 {
                queryUsersWithString(queryString)
                return
            }
        }
        
        _searchQuery = nil
        _tableView.reloadData()
    }
    
    func queryUsersWithString(query: String) {
        
        _searchQuery = query
        FirebaseDataManager.queryUsersByEmailWithString(query) { (users) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self._searchResults[query] = users
                self._tableView.reloadData()
            })
        }
    }
    
    //    MARK: Action Responders
    
    func userImageButtonTapped(sender: UIButton) {
        
        let index = sender.tag
        
        if index == -1 {
            print("ConnectionsTable | Unspecified Button Index")
            return
        }
        
        if _searchQuery != nil {
            if let users = _searchResults[_searchQuery!] {
                
                let user = users[index]
                openUserProfile(user)
            }
        }
    }
    
    //    MARK: Connection
    
    func openUserProfile(user: User) {
        
        let profileVC = UserProfileViewController()
        profileVC.user = user
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func connectWithUser(user: User) {
        
        let connectionManager =  RootDataManager.sharedInstance.connectionsManager()
        
        if connectionManager.connectedWithUser(user) {
            print("ConnectionsTable | Already Connected to user")
            openUserProfile(user)
            return
        }
        
        connectionManager.sendConnectionRequestToUser(user)
    }
    
    //    MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(_userSearchCell) as! UserSearchResultTableViewCell
        
        if _searchQuery != nil {
            if let users = _searchResults[_searchQuery!] {
                
                let user = users[indexPath.row]
                cell.loadWithUser(user)
                
                let connected =  RootDataManager.sharedInstance.connectionsManager().connectedWithUser(user)
                cell.userImageButton.setUserConnected(connected)
                
                // update the button targets
                cell.userImageButton.tag = indexPath.row
                cell.userImageButton.addTarget(self, action: #selector(UserSearchViewController.userImageButtonTapped(_:)), forControlEvents: .TouchUpInside)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if _searchQuery != nil {
            if let users = _searchResults[_searchQuery!] {
                return users.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    //    MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if _searchQuery != nil {
            if let users = _searchResults[_searchQuery!] {
                let user = users[indexPath.row]
                connectWithUser(user)
            }
        }
    }
}
