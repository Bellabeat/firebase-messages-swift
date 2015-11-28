//
//  BBSHotMessageSorter.swift
//  Social
//
//  Created by Ivan Fabijanović on 28/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public class BBSHotMessageSorter: BBSMessageSorter {

    // MARK: - Init

    public override init() {
        super.init()
        self.title = "Hot"
    }
    
    // MARK: - Overrides
    
    public override func queryForRef(ref: Firebase) -> FQuery {
        return ref.queryOrderedByChild(KeyMessageHotRank).queryLimitedToLast(self.limit)
    }
    
    public override func sortMessages(messages: Array<BBSMessageModel>) -> Array<BBSMessageModel> {
        return messages.sort { $0.hotRank.value > $1.hotRank.value }
    }
    
}
