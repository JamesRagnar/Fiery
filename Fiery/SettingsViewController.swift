//
//  SettingsViewController.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-29.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import MobileCoreServices

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserUpdateDeletate {

    private var _placeholderImage: UIImage?
    private var _placeholderName: String?
    
    private let _tableView = UITableView()
    
    private let _currentUser = RootDataManager.sharedInstance.currentUser()
    
    private enum TableSections: Int {
        case UserDetails
        case Logout
        case Version
    }
    
    private enum UserSectionRows: Int {
        case Image
        case Name
    }
    
    private let _imageCell = "SettingsImageCell"
    private let _nameCell = "SettingsNameCell"
    private let _logoutCell = "SettingsLogoutCell"
    private let _versionCell = "SettingsVersionCell"
    
    override func loadView() {
        super.loadView()
        
        title = "Settings"
        
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.separatorStyle = .None
        _tableView.registerClass(SettingsImageTableViewCell.self, forCellReuseIdentifier: _imageCell)
        _tableView.registerClass(SettingsTextEntryTableViewCell.self, forCellReuseIdentifier: _nameCell)
        _tableView.registerClass(SettingsLogoutTableViewCell.self, forCellReuseIdentifier: _logoutCell)
        _tableView.registerClass(SettingsVersionTableViewCell.self, forCellReuseIdentifier: _versionCell)
        view.addSubview(_tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _tableView.frame = view.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _currentUser?.updateDelegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        _currentUser?.updateDelegate = nil
    }
    
//    MARK: UserUpdateDeletate
    
    func userDataUpdated() {
        _tableView.reloadData()
    }
    
//    MARK: Action Responders
    
    func showLogoutConfirm() {
        
        let logoutActionSheet = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .ActionSheet)
        
        logoutActionSheet.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (action) in
            self.logout()
        }))
        
        logoutActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
        }))
        
        presentViewController(logoutActionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker() {
        
        let actionSheet = UIAlertController(title: nil, message: "Change your profile image", preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .Camera
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.cameraCaptureMode = .Photo
                mediaUI.cameraDevice = .Front
                self.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            actionSheet.addAction(UIAlertAction(title: "Select from Library", style: .Default, handler: { (alertAction) -> Void in
                
                let mediaUI = UIImagePickerController()
                mediaUI.sourceType = .PhotoLibrary
                mediaUI.allowsEditing = true
                mediaUI.delegate = self
                mediaUI.mediaTypes = [kUTTypeImage as String]
                self.presentViewController(mediaUI, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Delete Profile Image", style: .Destructive, handler: { (alertAction) -> Void in
            
            self.showDeleteConfirmation()
        }))

        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func showDeleteConfirmation() {
        
        let actionSheet = UIAlertController(title: "Delete Profile Image", message: "Are you sure?", preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (alertAction) -> Void in
            
            self.deleteProfileImage()
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
//    MARK: Image
    
    func updateProfileImage(image: UIImage) {
        
        _currentUser?.deleteProfileImage({ (success) in
            
            FirebaseStorageManager.updateUserProfileImage(image) { (data) in
                
                if let imageData = data?.dataFormat() {
                    
                    var updateData = [String: AnyObject]()
                    updateData[User.kProfileImageData] = imageData
                    self._currentUser?.updateChildValues(updateData)
                }
            }
        })
    }
    
    func deleteProfileImage() {
        
        _currentUser?.deleteProfileImage(nil)
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
                                cell.setNeedsLayout()
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
                
            case .Version:
                
                let cell = _tableView.dequeueReusableCellWithIdentifier(_versionCell) as! SettingsVersionTableViewCell
                
                return cell
            }
        }

        fatalError()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableSection = TableSections(rawValue: section) {
            switch tableSection {
            case .UserDetails:
                return 2
            case .Logout:
                return 1
            case .Version:
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
                        showImagePicker()
                        break
                    case .Name:
                        break
                    }
                }
            case .Logout:
                showLogoutConfirm()
                break
            case .Version:
                break
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
            case .Version:
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
            case .Version:
                return 40
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
//    MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == kUTTypeImage as String {
                
                if let croppedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    updateProfileImage(croppedImage)
                }
            }
        }
    }
}
