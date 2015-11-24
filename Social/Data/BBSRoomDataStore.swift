//
//  BBSRoomDataStore.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public protocol BBSRoomDataStoreDelegate: NSObjectProtocol {
    
    func roomDataStore(dataStore: BBSRoomDataStore, didAddRoom room:BBSRoomModel)
    func roomDataStore(dataStore: BBSRoomDataStore, didUpdateRoom room:BBSRoomModel)
    func roomDataStore(dataStore: BBSRoomDataStore, didRemoveRoom room:BBSRoomModel)
    
}

public class BBSRoomDataStore: NSObject {
    
    // MARK: - Properties
    
    weak public var delegate: BBSRoomDataStoreDelegate?
    
    // MARK: - Private members
    
    private var root: Firebase!
    private var query: FQuery!
    private var data: Dictionary<String, BBSRoomModel>!
    
    // MARK: - Init
    
    public init(root: Firebase) {
        self.root = root
        
        let rooms = root.childByAppendingPath("rooms")
        self.query = rooms.queryOrderedByChild("name")
        
        self.data = Dictionary<String, BBSRoomModel>()
        super.init()
        
        weak var weakSelf = self

        // Add
        self.query.observeEventType(.ChildAdded, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }
            
            let model = BBSRoomModel(key: snapshot.key, value: snapshot.value)
            weakSelf?.data[model.key] = model
            
            if let delegate = weakSelf?.delegate {
                delegate.roomDataStore(weakSelf!, didAddRoom: model)
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
                    delegate.roomDataStore(weakSelf!, didUpdateRoom: model)
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
                    delegate.roomDataStore(weakSelf!, didRemoveRoom: model)
                }
            }
        })
    }
    
    deinit {
        self.query.removeAllObservers()
        print("BBSRoomDataStore deinit")
    }
    
    // MARK: - Public methods
    
    public func messageDataStoreForRoom(room: BBSRoomModel, userId: String) -> BBSMessageDataStore {
        let sorter = BBSTopMessageSorter()
        return self.messageDataStoreForRoom(room, sorter: sorter, userId: userId)
    }
    
    public func messageDataStoreForRoom(room: BBSRoomModel, sorter: BBSMessageSorter, userId: String) -> BBSMessageDataStore {
        return BBSMessageDataStore(root: self.root, room: room, sorter: sorter, userId: userId)
    }
    
}
