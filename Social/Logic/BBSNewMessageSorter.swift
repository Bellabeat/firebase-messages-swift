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
    
    public override func indexForMessage(message: BBSMessageModel, inArray array: Array<BBSMessageModel>) -> Int? {
        var tempData = array
        tempData.append(message)
        
        let data = tempData.sort { $0.timestamp > $1.timestamp }
        return data.indexOf(message)
    }
    
}
