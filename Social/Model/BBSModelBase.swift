//
//  BBSModelBase.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSModelBase: NSObject {
    
    public var key: String = ""
    
    public func updateWithObject(object: AnyObject) {}
    public func serialize() -> AnyObject { return [:] }
    
}
