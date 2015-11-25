//
//  BBSFactory.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public class BBSFactory: NSObject {

    // MARK: - Stack creation
    
    public class func createSocialStackWithUrl(url: String, forUser userId: String) -> UINavigationController {
        return self.createSocialStackWithUrl(url, forUser: userId, withTheme: nil)
    }
    
    public class func createSocialStackWithUrl(url: String, forUser userId: String, withTheme theme: BBSUITheme?) -> UINavigationController {
        let roomsViewController = self.createRoomsControllerWithUrl(url, forUser: userId, withTheme: theme)
        return BBSNavigationController(rootViewController: roomsViewController)
    }
    
    // MARK: - Rooms controller creation
    
    public class func createRoomsControllerWithUrl(url: String, forUser userId: String) -> BBSRoomCollectionViewController {
        return self.createRoomsControllerWithUrl(url, forUser: userId, withTheme: nil)
    }
    
    public class func createRoomsControllerWithUrl(url: String, forUser userId: String, withTheme theme: BBSUITheme?) -> BBSRoomCollectionViewController {
        let rootRef = Firebase(url: url)
        let dataStore = BBSRoomDataStore(root: rootRef)
        let globalDataStore = BBSGlobalDataStore(root: rootRef)
        
        let roomsViewController = BBSRoomCollectionViewController(dataStore: dataStore, globalDataStore: globalDataStore, userId: userId)
        roomsViewController.theme = theme
        roomsViewController.title = "Rooms"
        
        return roomsViewController
    }
    
    // MARK: - Messages controller creation
    
    public class func createMessagesControllerWithUrl(url: String, forUser userId: String) -> BBSMessageCollectionViewController {
        return self.createMessagesControllerWithUrl(url, forUser: userId, withTheme: nil, andSorter: nil)
    }
    
    public class func createMessagesControllerWithUrl(url: String, forUser userId: String, withTheme theme: BBSUITheme?) -> BBSMessageCollectionViewController {
        return self.createMessagesControllerWithUrl(url, forUser: userId, withTheme: theme, andSorter: nil)
    }
    
    public class func createMessagesControllerWithUrl(url: String, forUser userId: String, withTheme theme: BBSUITheme?, andSorter sorter: BBSMessageSorter?) -> BBSMessageCollectionViewController {
        let rootRef = Firebase(url: url)
        let dataStore = BBSMessageDataStore(root: rootRef, room: nil, sorter: sorter, userId: userId)
        
        let messagesViewController = BBSMessageCollectionViewController(dataStore: dataStore, room: nil, userId: userId)
        messagesViewController.theme = theme
        messagesViewController.title = "Messages"
        
        return messagesViewController
    }
}
