//
//  Log.swift
//  Social
//
//  Created by Ivan Fabijanović on 30/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import Foundation

internal func print(items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    
    var index = items.startIndex
    let endIndex = items.endIndex
    
    repeat {
        Swift.print(items[index++], separator: separator, terminator: index == endIndex ? terminator : separator)
    } while index < endIndex
    
#endif
}

