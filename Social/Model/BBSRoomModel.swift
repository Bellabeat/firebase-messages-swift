//
//  BBSRoomModel.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

class BBSRoomModel: BBSModelBase {

    // MARK: - Properties
    
    var name: String = ""
    var type: String = ""
    
    // MARK: - Init
    
    init(key: String, value: Dictionary<String, String>) {
        super.init()
        self.key = key
        self.updateWithDictionary(value)
    }
    
    // MARK: - Overrides
    
    override func updateWithDictionary(dictionary: Dictionary<String, String>) {
        if let name = dictionary["name"] {
            self.name = name
        }
        if let type = dictionary["type"] {
            self.type = type
        }
    }
    
    override func serialize() -> Dictionary<String, String> {
        return [
            "name": self.name,
            "type": self.type
        ]
    }
    
}
