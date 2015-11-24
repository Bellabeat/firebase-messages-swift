//
//  BBSMessageDataStore.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public protocol BBSMessageDataStoreDelegate: NSObjectProtocol {
    
    func messageDataStore(dataStore: BBSMessageDataStore, didAddMessage message:BBSMessageModel)
    func messageDataStore(dataStore: BBSMessageDataStore, didUpdateMessage message:BBSMessageModel)
    func messageDataStore(dataStore: BBSMessageDataStore, didRemoveMessage message:BBSMessageModel)
    
}

public class BBSMessageDataStore: NSObject {
    
    // MARK: - Properties
    
    weak public var delegate: BBSMessageDataStoreDelegate?
    public let sorter: BBSMessageSorter
    
    // MARK: - Private members
    
    private let root: Firebase
    private let messages: Firebase
    private let query: FQuery
    private let userId: String
    private var data: Dictionary<String, BBSMessageModel>
    
    // MARK: - Init
    
    public init(root: Firebase, room: BBSRoomModel, sorter: BBSMessageSorter, userId: String) {
        self.root = root
        self.sorter = sorter
        self.userId = userId
        
        let path = "messages/\(room.key)"
        self.messages = root.childByAppendingPath(path)
        self.query = sorter.queryForRef(self.messages)
        
        self.data = Dictionary<String, BBSMessageModel>()
        super.init()
        
        weak var weakSelf = self
        
        // Add
        self.query.observeEventType(.ChildAdded, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }
            
            let model = BBSMessageModel(dataStore: weakSelf!, key: snapshot.key, value: snapshot.value)
            weakSelf?.data[model.key] = model
            
            if let delegate = weakSelf?.delegate {
                delegate.messageDataStore(weakSelf!, didAddMessage: model)
            }
        })
        
        // Update
        self.query.observeEventType(.ChildChanged, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }
            
            if let model = weakSelf?.data[snapshot.key] {
                model.updateWithObject(snapshot.value)
                
                if let delegate = weakSelf?.delegate {
                    delegate.messageDataStore(weakSelf!, didUpdateMessage: model)
                }
            }
        })
        
        // Remove
        self.query.observeEventType(.ChildRemoved, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }
            
            if let model = weakSelf?.data[snapshot.key] {
                weakSelf?.data[snapshot.key] = nil
                
                if let delegate = weakSelf?.delegate {
                    delegate.messageDataStore(weakSelf!, didRemoveMessage: model)
                }
            }
        })
    }
    
    deinit {
        self.query.removeAllObservers()
        print("BBSMessageDataStore deinit")
    }

    // MARK: - Public methods
    
    public func newMessage() -> BBSMessageModel {
        return BBSMessageModel(dataStore: self, senderId: self.userId)
    }
    
    public func saveMessage(message: BBSMessageModel) {
        self.messages.updateChildValues(message.serialize())
    }
    
}
