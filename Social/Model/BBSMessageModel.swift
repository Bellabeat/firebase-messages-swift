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
    
    // MARK: - Internal methods
    
    internal class func pointsForVotes(votes: Dictionary<String, String>) -> Int {
        var points = 0
        for (_, value) in votes {
            points += value == UpvoteValue ? 1 : -1
        }
        return points
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
            // Already upvoted, reverse upvote
            self.votes[userId] = nil
            self.points.value--
            self.totalActivity.value--
        } else {
            let pointsDiff = self.didDownvoteForUser(userId) ? 2 : 1
            self.votes[userId] = UpvoteValue
            self.points.value += pointsDiff
            self.totalActivity.value++
        }
        
        self.dataStore?.updateMessage(self, forUser: userId)
    }
    
    public func downvoteForUser(userId: String) {
        if self.didDownvoteForUser(userId) {
            // Already downvoted, reverse downvote
            self.votes[userId] = nil
            self.points.value++
            self.totalActivity.value--
        } else {
            let pointsDiff = self.didUpvoteForUser(userId) ? 2 : 1
            self.votes[userId] = DownvoteValue
            self.points.value -= pointsDiff
            self.totalActivity.value++
        }
        
        self.dataStore?.updateMessage(self, forUser: userId)
    }
    
}
