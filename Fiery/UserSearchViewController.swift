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
    let searchController = UISearchController(searchResultsController: nil)

    private var _searchQuery: String?
    private var _searchResults = [String: [User]]()
    
    override func loadView() {
        super.loadView()
        
        _tableView.registerClass(ConnectionTableViewCell.self, forCellReuseIdentifier: _userSearchCell)
        _tableView.dataSource = self
        _tableView.delegate = self
        view.addSubview(_tableView)

        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        _tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _tableView.frame = view.frame
    }
    
//    MARK: UISearchControllerDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let queryString = searchController.searchBar.text {
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
    
//    MARK: Connection
    
    func connectWithUser(user: User) {
        
        let connectionManager =  RootDataManager.sharedInstance.connectionsManager()
        
        connectionManager.sendConnectionRequestToUser(user)
    }
    
//    MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(_userSearchCell) as! ConnectionTableViewCell
        
        if _searchQuery != nil {
            if let users = _searchResults[_searchQuery!] {
                
                let user = users[indexPath.row]
                cell.textLabel?.text = user.name()
                
                cell.userImageButton.setImage(user.image(), forState: .Normal)
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

        if let users = _searchResults[_searchQuery!] {
            
            let user = users[indexPath.row]
            
            let profileVC = UserProfileViewController()
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: true)
        }

//        if _searchQuery != nil {
//            if let users = _searchResults[_searchQuery!] {
//                let user = users[indexPath.row]
//                connectWithUser(user)
//            }
//        }
    }
}
