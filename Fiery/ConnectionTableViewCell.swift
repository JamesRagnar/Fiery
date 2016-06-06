//
//  ConnectionTableViewCell.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-22.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit

class ConnectionTableViewCell: UITableViewCell, ConversationManagerDelegate {
    
    let userImageButton = UserImageConnectionButton()
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    
    private var _conversationManager: ConversationManager?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImageButton.setUserConnected(true)
        contentView.addSubview(userImageButton)
        
        titleLabel.font = UIFont.systemFontOfSize(20)
        contentView.addSubview(titleLabel)
        
        detailLabel.font = UIFont.systemFontOfSize(17)
        contentView.addSubview(detailLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageButton.frame = CGRectMake(0, 0, 90, 90)
        userImageButton.center = CGPointMake(20 + 45, CGRectGetMidY(contentView.bounds))
        
        let leftX = CGRectGetMaxX(userImageButton.frame) + 20
        let labelWidth = CGRectGetWidth(contentView.bounds) - leftX - 20
        let quarterHeight = CGRectGetHeight(contentView.bounds) / 4.0
        
        titleLabel.frame = CGRectMake(leftX, quarterHeight, labelWidth, quarterHeight)
        detailLabel.frame = CGRectMake(leftX, quarterHeight * 2.0, labelWidth, quarterHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        userImageButton.setImage(nil, forState: .Normal)
        
        // Reset the image button links
        userImageButton.removeTarget(nil, action: nil, forControlEvents: .TouchUpInside)
        userImageButton.tag = -1
        
        detailLabel.text = nil
        
        _conversationManager?.delegate = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(connection: Connection) {
        
        if let user = connection.user {
            loadUserData(user)
        }
        
        if let conversationManager = connection.conversationManager {
            loadConversationData(conversationManager)
        }
    }
    
    private func loadUserData(user: User) {
        
        titleLabel.text = user.name()
        
        ImageCacheManager.fetchUserImage(user) { (image) in
            self.userImageButton.setImage(image, forState: .Normal)
        }
    }
    
    private func loadConversationData(conversationManager: ConversationManager) {
        
        _conversationManager = conversationManager
        _conversationManager?.delegate = self
        
        detailLabel.text = conversationManager.conversationDetailContext()
    }
    
//    MARK: ConversationManagerDelegate 
    
    func messageAdded(manager: ConversationManager, message: Message) {
        loadConversationData(manager)
    }
    
    func messageUpdated(manager: ConversationManager, message: Message) {
        // Don't care about an update message
    }
}
