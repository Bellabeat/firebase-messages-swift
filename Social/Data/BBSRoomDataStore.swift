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
    func roomDataStore(dataStore: BBSRoomDataStore, didLoadData data:Array<BBSRoomModel>)
}

public class BBSRoomDataStore: NSObject {
    
    // MARK: - Properties
    
    weak public var delegate: BBSRoomDataStoreDelegate?
    
    // MARK: - Private members
    
    private var root: Firebase!
    private var query: FQuery!
    
    // MARK: - Init
    
    public init(root: Firebase) {
        self.root = root
        
        let rooms = root.childByAppendingPath("rooms")
        self.query = rooms.queryOrderedByChild("name")
        
        super.init()
    }
    
    deinit {
        self.query.removeAllObservers()
        self.query.keepSynced(false)
        print("BBSRoomDataStore deinit")
    }
    
    // MARK: - Public methods
    
    public func loadAsync() {
        weak var weakSelf = self
        self.query.keepSynced(true)
        self.query.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var rooms = Array<BBSRoomModel>()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FDataSnapshot {
                let model = BBSRoomModel(key: child.key, value: child.value)
                rooms.append(model)
            }
            
            if let delegate = weakSelf?.delegate {
                delegate.roomDataStore(weakSelf!, didLoadData: rooms)
            }
        })
    }
    
    public func messageDataStoreForRoom(room: BBSRoomModel, userId: String) -> BBSMessageDataStore {
        let sorter = BBSTopMessageSorter()
        return self.messageDataStoreForRoom(room, sorter: sorter, userId: userId)
    }
    
    public func messageDataStoreForRoom(room: BBSRoomModel, sorter: BBSMessageSorter, userId: String) -> BBSMessageDataStore {
        return BBSMessageDataStore(root: self.root, room: room, sorter: sorter, userId: userId)
    }
    
}
