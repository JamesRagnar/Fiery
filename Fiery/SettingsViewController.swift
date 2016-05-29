//
//  SettingsViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-29.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var _placeholderImage: UIImage?
    private var _placeholderName: String?
    
    private let _tableView = UITableView()
    
    private let _currentUser = RootDataManager.sharedInstance.currentUser()
    
    private enum TableSections: Int {
        case UserDetails
        case Logout
    }
    
    private enum UserSectionRows: Int {
        case Image
        case Name
    }
    
    private let _imageCell = "SettingsImageCell"
    private let _nameCell = "SettingsNameCell"
    private let _logoutCell = "SettingsLogoutCell"
    
    override func loadView() {
        super.loadView()
        
        _tableView.dataSource = self
        _tableView.delegate = self
        
        _tableView.registerClass(SettingsImageTableViewCell.self, forCellReuseIdentifier: _imageCell)
        _tableView.registerClass(SettingsTextEntryTableViewCell.self, forCellReuseIdentifier: _nameCell)
        _tableView.registerClass(SettingsLogoutTableViewCell.self, forCellReuseIdentifier: _logoutCell)
        view.addSubview(_tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _tableView.frame = view.bounds
    }
    
//    MARK: Action Responders
    
    func showLogoutConfirm() {
        
        let logoutActionSheet = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .ActionSheet)
        
        logoutActionSheet.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (action) in
            self.logout()
        }))
        
        logoutActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
        }))
        
        presentViewController(logoutActionSheet, animated: true, completion: nil)
    }
    
    //    MARK: Logout
    
    func logout() {
        
        RootDataManager.sharedInstance.logout()
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
//    MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let tableSection = TableSections(rawValue: indexPath.section) {
            switch tableSection {
            case .UserDetails:
                
                if let tableRow = UserSectionRows(rawValue: indexPath.row) {
                    switch tableRow {
                    case .Image:
                        
                        let cell = _tableView.dequeueReusableCellWithIdentifier(_imageCell) as! SettingsImageTableViewCell
                        
                        if let image = _placeholderImage {
                            // User has selected a new local image
                            
                            cell.imageView?.image = image
                            
                        } else {
                            
                            ImageCacheManager.fetchUserImage(_currentUser, response: { (image) in
                                cell.imageView?.image = image
                            })
                        }
                                                
                        return cell
                        
                    case .Name:
                        
                        let cell = _tableView.dequeueReusableCellWithIdentifier(_nameCell) as! SettingsTextEntryTableViewCell
                        
                        if let name = _placeholderName {
                            cell.textField.text = name
                        } else {
                            cell.textField.text = _currentUser?.name()
                        }
                        
                        return cell
                        
                    }
                }
                
            case .Logout:
                
                let cell = _tableView.dequeueReusableCellWithIdentifier(_logoutCell) as! SettingsLogoutTableViewCell
                
                return cell
            }
        }

        fatalError()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableSection = TableSections(rawValue: section) {
            switch tableSection {
            case .UserDetails:
                return 2
            case .Logout:
                return 1
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let tableSection = TableSections(rawValue: indexPath.section) {
            switch tableSection {
            case .UserDetails:
                if let tableRow = UserSectionRows(rawValue: indexPath.row) {
                    switch tableRow {
                    case .Image:
                        break
                    case .Name:
                        break
                    }
                }
            case .Logout:
                showLogoutConfirm()
            }
        }
    }
    
//    MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let tableSection = TableSections(rawValue: indexPath.section) {
            switch tableSection {
            case .UserDetails:
                if let tableRow = UserSectionRows(rawValue: indexPath.row) {
                    switch tableRow {
                    case .Image:
                        return 200
                    case .Name:
                        return 40
                    }
                }
            case .Logout:
                return 40
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let tableSection = TableSections(rawValue: section) {
            switch tableSection {
            case .UserDetails:
                break
            case .Logout:
                return 40
            }
        }
        
        return 0
    }
}
