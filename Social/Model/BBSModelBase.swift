//
//  BBSModelBase.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

class BBSModelBase: NSObject {
    
    var key: String = ""
    
    func updateWithDictionary(dictionary: Dictionary<String, String>) {}
    func serialize() -> Dictionary<String, String> { return [:] }
    
}
