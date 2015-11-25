//
//  BBSMessageModel.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public let UpvoteValue = "u"
public let DownvoteValue = "d"

internal let KeyMessageMessage = "message"
internal let KeyMessageSender = "sender"
internal let KeyMessagePoints = "points"
internal let KeyMessageTotalActivity = "totalActivity"
internal let KeyMessageTimestamp = "timestamp"
internal let KeyMessageVotes = "votes"

public class BBSMessageModel: BBSModelBase {
    
    // MARK: - Properties
    
    public var message = Variable<String>("")
    public var sender = Variable<String>("")
    public var points = Variable<Int>(0)
    public var totalActivity = Variable<Int>(0)
    public var timestamp = Variable<Double>(0)
    public var votes: Dictionary<String, String> = [:]
    
    // MARK: - Private members
    
    private weak var dataStore: BBSMessageDataStore?
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore, senderId: String) {
        self.dataStore = dataStore
        self.sender.value = senderId
        self.points.value = 1
        self.totalActivity.value = 1
        super.init()
        
        self.votes[senderId] = UpvoteValue
    }
    
    public init(dataStore: BBSMessageDataStore, key: String, value: AnyObject) {
        self.dataStore = dataStore
        super.init()
        
        self.key = key
        self.updateWithObject(value)
    }
    
    deinit {
        print("BBSMessageModel deinit")
    }
    
    // MARK: - Overrides
    
    public override func updateWithObject(object: AnyObject) {
        self.message.value = object.objectForKey(KeyMessageMessage) as? String ?? ""
        self.sender.value = object.objectForKey(KeyMessageSender) as? String ?? ""
        self.timestamp.value = object.objectForKey(KeyMessageTimestamp) as? Double ?? 0.0
        self.votes = object.objectForKey(KeyMessageVotes) as? Dictionary<String, String> ?? Dictionary<String, String>()
        self.points.value = object.objectForKey(KeyMessagePoints) as? Int ?? 0
        self.totalActivity.value = object.objectForKey(KeyMessageTotalActivity) as? Int ?? 0
    }
    
    public override func serialize() -> [NSObject: AnyObject] {
        return [
            KeyMessageMessage: self.message.value,
            KeyMessageSender: self.sender.value,
            KeyMessagePoints: self.points.value,
            KeyMessageTotalActivity: self.totalActivity.value,
            KeyMessageTimestamp: self.timestamp.value,
            KeyMessageVotes: self.votes
        ]
    }
    
    // MARK: - Public methods
    
    public func didUpvoteForUser(userId: String) -> Bool {
        if let vote = self.votes[userId] {
            return vote == UpvoteValue
        }
        return false
    }
    
    public func didDownvoteForUser(userId: String) -> Bool {
        if let vote = self.votes[userId] {
            return vote == DownvoteValue
        }
        return false
    }
    
    public func upvoteForUser(userId: String) {
        self.dataStore?.upvoteMessage(self, forUser: userId)
    }
    
    public func downvoteForUser(userId: String) {
        self.dataStore?.downvoteMessage(self, forUser: userId)
    }
    
}
