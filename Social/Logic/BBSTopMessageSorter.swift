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
    
    public override func indexForMessage(message: BBSMessageModel, inArray array: Array<BBSMessageModel>) -> Int? {
        var tempData = array
        tempData.append(message)
        
        let data = tempData.sort { $0.points > $1.points }
        return data.indexOf(message)
    }
    
}
