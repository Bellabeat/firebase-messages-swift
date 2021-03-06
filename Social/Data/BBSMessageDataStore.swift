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
    func messageDataStore(dataStore: BBSMessageDataStore, didLoadData data:Array<BBSMessageModel>)
}

public class BBSMessageDataStore: NSObject {
    
    // MARK: - Properties
    
    weak public var delegate: BBSMessageDataStoreDelegate?
    
    // MARK: - Private members
    
    private let root: Firebase
    private let messages: Firebase
    private var query: FQuery
    private let userId: String
    private var sorter: BBSMessageSorter
    
    // MARK: - Init
    
    public init(root: Firebase, room: BBSRoomModel?, sorter: BBSMessageSorter?, userId: String) {
        self.root = root
        self.sorter = sorter != nil ? sorter! : BBSTopMessageSorter()
        self.userId = userId
        
        let path = room != nil ? "messages/\(room!.key)" : "messages"
        self.messages = root.childByAppendingPath(path)
        self.query = self.sorter.queryForRef(self.messages)
        
        super.init()
    }
    
    public convenience init(root: Firebase, userId: String) {
        self.init(root: root, room: nil, sorter: nil, userId: userId)
    }
    
    public convenience init(root: Firebase, sorter: BBSMessageSorter, userId: String) {
        self.init(root: root, room: nil, sorter: sorter, userId: userId)
    }
    
    deinit {
        self.query.removeAllObservers()
        self.query.keepSynced(false)
        print("BBSMessageDataStore deinit")
    }

    // MARK: - Public methods
    
    public func loadAsync() {
        weak var weakSelf = self
        self.query.keepSynced(true)
        self.query.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var messages = Array<BBSMessageModel>()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FDataSnapshot {
                let model = BBSMessageModel(dataStore: weakSelf!, key: child.key, value: child.value)
                messages.append(model)
            }
            
            if let delegate = weakSelf?.delegate {
                let sortedMessages = weakSelf!.sorter.sortMessages(messages)
                delegate.messageDataStore(weakSelf!, didLoadData: sortedMessages)
            }
        })
    }
    
    public func newMessage() -> BBSMessageModel {
        return BBSMessageModel(dataStore: self, senderId: self.userId)
    }
    
    public func createMessage(message: BBSMessageModel) {
        let raw = message.serialize()
        if message.key.isEmpty {
            let child = self.messages.childByAutoId()
            child.setValue(raw)
            message.key = child.key
        } else {
            print("Attemped to update message in createMessage method")
        }
    }
    
    public func updateMessage(message: BBSMessageModel, forUser userId: String) {
        var raw = message.serialize()
        let voteValue = message.votes[userId]
        let ref = self.messages.childByAppendingPath(message.key)
        ref.runTransactionBlock { mutableData -> FTransactionResult! in
            if mutableData.value is NSNull {
                // Stale data, return success to continue transaction, we will get another callback
                return FTransactionResult.successWithValue(mutableData)
            }
            
            // Get up to date votes dictionary
            var votes = mutableData.value.objectForKey(KeyMessageVotes) as? Dictionary<String, String> ?? Dictionary<String, String>()
            // Update it with local value for user
            votes[userId] = voteValue
            // Calculate points and total activity
            let points = BBSMessageModel.pointsForVotes(votes)
            let totalActivity = votes.count
            
            // Update mutable data
            raw[KeyMessagePoints] = points
            raw[KeyMessageTotalActivity] = totalActivity
            raw[KeyMessageVotes] = votes
            mutableData.value = raw
            
            return FTransactionResult.successWithValue(mutableData)
        }
    }
    
    public func changeSorter(sorter: BBSMessageSorter) -> Bool {
        if self.sorter.title != sorter.title {
            self.query.removeAllObservers()
            self.query.keepSynced(false)
            
            self.sorter = sorter
            self.query = self.sorter.queryForRef(self.messages)
            return true
        }
        return false
    }
    
}
