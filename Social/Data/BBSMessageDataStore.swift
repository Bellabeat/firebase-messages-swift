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
        print("BBSMessageDataStore deinit")
    }

    // MARK: - Public methods
    
    public func loadAsync() {
        weak var weakSelf = self
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
    
    public func saveMessage(message: BBSMessageModel) {
        let raw = message.serialize()
        
        if message.key.isEmpty {
            // New
            let child = self.messages.childByAutoId()
            child.setValue(raw)
            message.key = child.key
        } else {
            // Update
            self.messages.updateChildValues([message.key: raw])
        }
    }
    
    public func changeSorter(sorter: BBSMessageSorter) -> Bool {
        if self.sorter.title != sorter.title {
            self.query.removeAllObservers()
            
            self.sorter = sorter
            self.query = self.sorter.queryForRef(self.messages)
            return true
        }
        return false
    }
    
    // MARK: - Internal methods
    
    internal func upvoteMessage(message: BBSMessageModel, forUser userId: String) {
        var raw = message.serialize()
        let ref = self.messages.childByAppendingPath(message.key)
        ref.runTransactionBlock({ mutableData -> FTransactionResult! in
            var points = mutableData.value.objectForKey(KeyMessagePoints) as! Int
            var totalActivity = mutableData.value.objectForKey(KeyMessageTotalActivity) as! Int
            var votes = mutableData.value.objectForKey(KeyMessageVotes) as? Dictionary<String, String> ?? Dictionary<String, String>()
            
            if let voteForUser = votes[userId] {
                if voteForUser == UpvoteValue {
                    // Upvoted, reverse
                    points--
                    totalActivity--
                    votes[userId] = nil
                } else {
                    // Downvoted, reverse
                    points++
                    totalActivity--
                    votes[userId] = nil
                }
            } else {
                // User never voted on this message, upvote
                points++
                totalActivity++
                votes[userId] = UpvoteValue
            }
            
            raw[KeyMessagePoints] = points
            raw[KeyMessageTotalActivity] = totalActivity
            raw[KeyMessageVotes] = votes
            mutableData.value = raw
            
            return FTransactionResult.successWithValue(mutableData)
        })
    }
    
    internal func downvoteMessage(message: BBSMessageModel, forUser userId: String) {
        var raw = message.serialize()
        let ref = self.messages.childByAppendingPath(message.key)
        ref.runTransactionBlock({ mutableData -> FTransactionResult! in
            var points = mutableData.value.objectForKey(KeyMessagePoints) as! Int
            var totalActivity = mutableData.value.objectForKey(KeyMessageTotalActivity) as! Int
            var votes = mutableData.value.objectForKey(KeyMessageVotes) as? Dictionary<String, String> ?? Dictionary<String, String>()
            
            if let voteForUser = votes[userId] {
                if voteForUser == DownvoteValue {
                    // Downvoted, reverse
                    points++
                    totalActivity--
                    votes[userId] = nil
                } else {
                    // Upvoted, reverse
                    points--
                    totalActivity--
                    votes[userId] = nil
                }
            } else {
                // User never voted on this message, downvote
                points--
                totalActivity++
                votes[userId] = DownvoteValue
            }
            
            raw[KeyMessagePoints] = points
            raw[KeyMessageTotalActivity] = totalActivity
            raw[KeyMessageVotes] = votes
            mutableData.value = raw
            
            return FTransactionResult.successWithValue(mutableData)
        })
    }
    
}
