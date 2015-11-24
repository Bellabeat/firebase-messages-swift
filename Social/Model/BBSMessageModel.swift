//
//  BBSMessageModel.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public let UpvoteValue = "u"
public let NeutralValue = "n"
public let DownvoteValue = "d"

internal let KeyMessageMessage = "message"
internal let KeyMessageSender = "sender"
internal let KeyMessagePoints = "points"
internal let KeyMessageTotalActivity = "totalActivity"
internal let KeyMessageTimestamp = "timestamp"
internal let KeyMessageVotes = "votes"

public class BBSMessageModel: BBSModelBase {
    
    // MARK: - Properties
    
    public var message: String = ""
    public var sender: String = ""
    public var points: Int = 0
    public var totalActivity: Int = 0
    public var timestamp: Double = 0.0
    public var votes: Dictionary<String, String> = [:]
    
    // MARK: - Private members
    
    private weak var dataStore: BBSMessageDataStore?
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore, senderId: String) {
        self.dataStore = dataStore
        super.init()
        
        self.sender = senderId
        self.points = 1
        self.totalActivity = 1
        self.votes[sender] = UpvoteValue
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
        if let message = object.objectForKey(KeyMessageMessage) as? String {
            self.message = message
        }
        if let sender = object.objectForKey(KeyMessageSender) as? String {
            self.sender = sender
        }
        if let points = object.objectForKey(KeyMessagePoints) as? Int {
            self.points = points
        }
        if let totalActivity = object.objectForKey(KeyMessageTotalActivity) as? Int {
            self.totalActivity = totalActivity
        }
        if let timestamp = object.objectForKey(KeyMessageTimestamp) as? Double {
            self.timestamp = timestamp
        }
        if let votes = object.objectForKey(KeyMessageVotes) as? Dictionary<String, String> {
            self.votes = votes
        }
    }
    
    public override func serialize() -> [NSObject: AnyObject] {
        return [
            self.key: [
                KeyMessageMessage: self.message,
                KeyMessageSender: self.sender,
                KeyMessagePoints: self.points,
                KeyMessageTotalActivity: self.totalActivity,
                KeyMessageTimestamp: self.timestamp,
                KeyMessageVotes: self.votes
            ]
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
        if self.didUpvoteForUser(userId) {
            // Upvoted, reverse
            self.points--
            self.totalActivity--;
            self.votes[userId] = NeutralValue
        } else if self.didDownvoteForUser(userId) {
            // Downvoted, reverse
            self.points++
            self.totalActivity--
            self.votes[userId] = NeutralValue
        } else {
            // Neutral position, upvote
            self.points++
            self.totalActivity++
            self.votes[userId] = UpvoteValue
        }
        
        self.dataStore?.saveMessage(self)
    }
    
    public func downvoteForUser(userId: String) {
        if self.didDownvoteForUser(userId) {
            // Downvoted, reverse
            self.points++
            self.totalActivity--;
            self.votes[userId] = NeutralValue
        } else if self.didUpvoteForUser(userId) {
            // Upvoted, reverse
            self.points--
            self.totalActivity--
            self.votes[userId] = NeutralValue
        } else {
            // Neutral position, downvote
            self.points--
            self.totalActivity++
            self.votes[userId] = DownvoteValue
        }
        
        self.dataStore?.saveMessage(self)
    }
    
}
