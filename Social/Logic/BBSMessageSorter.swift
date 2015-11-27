//
//  BBSMessageSorter.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public class BBSMessageSorter: NSObject {

    // MARK: - Properties
    
    public var title: String = ""
    public var limit: UInt = 50
    
    // MARK: - Public methods
    
    public func queryForRef(ref: Firebase) -> FQuery {
        return FQuery()
    }
    
    public func sortMessages(messages: Array<BBSMessageModel>) -> Array<BBSMessageModel> {
        return messages
    }
    
}
