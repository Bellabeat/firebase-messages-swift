//
//  BBSNewMessageSorter.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public class BBSNewMessageSorter: BBSMessageSorter {
    
    // MARK: - Init
    
    public override init() {
        super.init()
        self.title = "New"
    }
    
    // MARK: - Overrides
    
    public override func queryForRef(ref: Firebase) -> FQuery {
        return ref.queryOrderedByPriority().queryLimitedToLast(self.limit)
    }
    
    public override func sortMessages(messages: Array<BBSMessageModel>) -> Array<BBSMessageModel> {
        return messages.sort { $0.timestamp.value > $1.timestamp.value }
    }
    
}
