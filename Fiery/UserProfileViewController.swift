//
//  UserProfileViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-27.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user: User?
    
    private let _tableView = UITableView()
    
    private enum TableRows: Int {
        case Image = 0
        case Name
        case Email
        case Connection
    }
    
    private let _imageCell = "UserImageTableCell"
    private let _nameCell = "UserNameTableCell"
    private let _emailCell = "UserEmailTableCell"
    private let _connectionCell = "UserConnectionCell"
    
    override func loadView() {
        super.loadView()
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .None
        _tableView.registerClass(UserProfileImageTableViewCell.self, forCellReuseIdentifier: _imageCell)
        _tableView.registerClass(UserProfileNameTableViewCell.self, forCellReuseIdentifier: _nameCell)
        _tableView.registerClass(UserProfileEmailTableViewCell.self, forCellReuseIdentifier: _emailCell)
        _tableView.registerClass(UserProfileConnectionTableViewCell.self, forCellReuseIdentifier: _connectionCell)
        
        view.addSubview(_tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _tableView.frame = view.bounds
    }
    
//    MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let tableRow = TableRows(rawValue: indexPath.row) {
            
            switch tableRow {
            case .Image:
                
                let cell = _tableView.dequeueReusableCellWithIdentifier(_imageCell) as! UserProfileImageTableViewCell
                cell.loadWithUser(user)
                return cell
                
            case .Name:
                
                let cell = _tableView.dequeueReusableCellWithIdentifier(_nameCell) as! UserProfileNameTableViewCell
                cell.loadWithUser(user)
                return cell
                
            case .Email:
                
                let cell = _tableView.dequeueReusableCellWithIdentifier(_emailCell) as! UserProfileEmailTableViewCell
                cell.loadWithUser(user)
                return cell
                
            case .Connection:
                
                let cell = _tableView.dequeueReusableCellWithIdentifier(_connectionCell) as! UserProfileConnectionTableViewCell
                return cell
            }
        }
        
        fatalError("Unknown Profile Cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
//    MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let tableRow = TableRows(rawValue: indexPath.row) {
            
            switch tableRow {
            case .Image:
                return 200
            case .Name:
                return 40
            case .Email:
                return 40
            case .Connection:
                return 100
            }
        }
        
        fatalError("Unknown Profile Cell")
    }
    
}
