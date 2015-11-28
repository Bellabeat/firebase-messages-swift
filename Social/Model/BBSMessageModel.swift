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
internal let KeyMessageHotRank = "hotRank"
internal let KeyMessageTotalActivity = "totalActivity"
internal let KeyMessageTimestamp = "timestamp"
internal let KeyMessageVotes = "votes"

private let RedditHotTimestampConstant = 1134028003.0
private let RedditHotDividerConstant = 45000.0

public class BBSMessageModel: BBSModelBase {
    
    // MARK: - Properties
    
    public var message = Variable<String>("")
    public var sender = Variable<String>("")
    public var points = Variable<Int>(0)
    public var hotRank = Variable<Double>(0)
    public var totalActivity = Variable<Int>(0)
    public var timestamp = Variable<Double>(0)
    public var votes: Dictionary<String, String> = [:]
    
    // MARK: - Private members
    
    private weak var dataStore: BBSMessageDataStore?
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore, senderId: String) {
        self.dataStore = dataStore
        self.sender.value = senderId
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
        self.timestamp.value = object.objectForKey(KeyMessageTimestamp) as? Double ?? 0
        self.votes = object.objectForKey(KeyMessageVotes) as? Dictionary<String, String> ?? Dictionary<String, String>()
        self.points.value = object.objectForKey(KeyMessagePoints) as? Int ?? 0
        self.hotRank.value = object.objectForKey(KeyMessageHotRank) as? Double ?? 0
        self.totalActivity.value = object.objectForKey(KeyMessageTotalActivity) as? Int ?? 0
    }
    
    public override func serialize() -> [NSObject: AnyObject] {
        return [
            KeyMessageMessage: self.message.value,
            KeyMessageSender: self.sender.value,
            KeyMessagePoints: self.points.value,
            KeyMessageHotRank: self.hotRank.value,
            KeyMessageTotalActivity: self.totalActivity.value,
            KeyMessageTimestamp: self.timestamp.value,
            KeyMessageVotes: self.votes
        ]
    }
    
    // MARK: - Methods
    
    internal class func scoresForVotes(votes: Dictionary<String, String>, timestamp: Double) -> (points: Int, hotRank: Double) {
        var upvotes = 0
        var downvotes = 0
        for (_, value) in votes {
            if value == UpvoteValue {
                upvotes++
            } else {
                downvotes++
            }
        }
        
        let points = upvotes - downvotes
        let hotRank = self.hotRankForUpvotes(upvotes, downvotes: downvotes, timestamp: timestamp)
        
        return (points: points, hotRank: hotRank)
    }
    
    private class func hotRankForUpvotes(upvotes: Int, downvotes: Int, timestamp: Double) -> Double {
        let score = upvotes - downvotes
        let order = log10(Double(max(abs(score), 1)))
        let sign = score > 0 ? 1.0 : score < 0 ? -1.0 : 0
        let seconds = timestamp - RedditHotTimestampConstant
        
        return (sign * order + seconds / RedditHotDividerConstant)
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
