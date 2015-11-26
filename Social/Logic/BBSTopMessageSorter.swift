//
//  BBSTopMessageSorter.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public class BBSTopMessageSorter: BBSMessageSorter {
    
    // MARK: - Init
    
    public override init() {
        super.init()
        self.title = "Top"
    }
    
    // MARK: - Overrides
    
    public override func queryForRef(ref: Firebase) -> FQuery {
        return ref.queryOrderedByChild(KeyMessagePoints).queryLimitedToLast(self.limit)
    }
    
    public override func sortMessages(messages: Array<BBSMessageModel>) -> Array<BBSMessageModel> {
        return messages.sort {
            if $0.points.value == $1.points.value {
                // Sort by timestamp if points value is equal
                return $0.timestamp.value > $1.timestamp.value
            }
            // Sort by points value
            return $0.points.value > $1.points.value
        }
    }
    
}
