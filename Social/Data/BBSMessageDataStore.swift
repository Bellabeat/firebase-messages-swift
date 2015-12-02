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
    func messageDataStoreNewDataAvailable(dataStore: BBSMessageDataStore)
}

private let UnregisterTimerInterval = 2.0

public class BBSMessageDataStore: NSObject {
    
    // MARK: - Properties
    
    weak public var delegate: BBSMessageDataStoreDelegate?
    
    // MARK: - Private members
    
    private let root: Firebase
    private let messages: Firebase
    private var query: FQuery
    private let userId: String
    private var sorter: BBSMessageSorter
    
    private var unregisterTimer: NSTimer?
    
    // MARK: - Init
    
    public init(root: Firebase, room: BBSRoomModel?, sorter: BBSMessageSorter?, userId: String) {
        self.root = root
        self.sorter = sorter != nil ? sorter! : BBSHotMessageSorter()
        self.userId = userId
        
        self.messages = room != nil ? root.childByAppendingPath("messages/\(room!.key)") : root
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
        self.clearTimer()
        self.query.removeAllObservers()
        self.query.keepSynced(false)
        print("BBSMessageDataStore deinit")
    }

    // MARK: - Public methods
    
    public func loadAsync() {
        weak var weakSelf = self
        self.query.keepSynced(true)
        self.query.observeEventType(.Value, withBlock: { snapshot in
            if !snapshot.exists() { return }
            
            var messages = Array<BBSMessageModel>()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FDataSnapshot {
                let model = BBSMessageModel(dataStore: weakSelf!, key: child.key, value: child.value)
                messages.append(model)
            }
            
            if let delegate = weakSelf!.delegate {
                let sortedMessages = weakSelf!.sorter.sortMessages(messages)
                delegate.messageDataStore(weakSelf!, didLoadData: sortedMessages)
            }
        })
        
        // Queue .Value event to be unregistered in the near future, because
        // we don't want to bombard user with new messages, but we do need
        // to listen for several changes on initial registration
        weakSelf!.queueUnregisterEvent()
    }
    
    public func newMessage() -> BBSMessageModel {
        return BBSMessageModel(dataStore: self, senderId: self.userId)
    }
    
    public func createMessage(message: BBSMessageModel) {
        if !message.key.isEmpty {
            print("Attemped to update message in createMessage method")
            return
        }
        
        let scores = BBSMessageModel.scoresForVotes(message.votes, timestamp: message.timestamp.value)
        message.points.value = scores.points
        message.hotRank.value = scores.hotRank
        message.totalActivity.value = 1
        
        let child = self.messages.childByAutoId()
        child.setValue(message.serialize())
        message.key = child.key
    }
    
    public func updateMessage(message: BBSMessageModel, forUser userId: String) {
        var raw = message.serialize()
        let voteValue = message.votes[userId]
        let timestamp = message.timestamp.value
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
            // Calculate message scores for votes
            let scores = BBSMessageModel.scoresForVotes(votes, timestamp: timestamp)
            let totalActivity = votes.count
            
            // Update mutable data
            raw[KeyMessagePoints] = scores.points
            raw[KeyMessageHotRank] = scores.hotRank
            raw[KeyMessageTotalActivity] = totalActivity
            raw[KeyMessageVotes] = votes
            mutableData.value = raw
            
            return FTransactionResult.successWithValue(mutableData)
        }
    }
    
    public func changeSorter(sorter: BBSMessageSorter) -> Bool {
        if self.sorter.title != sorter.title {
            self.clearTimer()
            self.query.removeAllObservers()
            self.query.keepSynced(false)
            
            self.sorter = sorter
            self.query = self.sorter.queryForRef(self.messages)
            return true
        }
        return false
    }
    
    // MARK: - Unregister timer
    
    private func clearTimer() {
        if let timer = self.unregisterTimer {
            timer.invalidate()
            self.unregisterTimer = nil
        }
    }
    
    private func queueUnregisterEvent() {
        self.clearTimer()
        self.unregisterTimer = NSTimer.scheduledTimerWithTimeInterval(UnregisterTimerInterval, target: self, selector: "unregisterEventFired", userInfo: nil, repeats: false)
    }
    
    internal func unregisterEventFired() {
        // Remove the .Value observer
        self.query.removeAllObservers()
        
        // Register a .ChildAdded observer
        weak var weakSelf = self
        self.query.observeEventType(.ChildAdded, withBlock: { snapshot in
            if !snapshot.exists() { return }
            
            if let delegate = weakSelf?.delegate {
                delegate.messageDataStoreNewDataAvailable(weakSelf!)
            }
        })
    }
    
}
