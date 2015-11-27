//
//  BBSObserverContainer.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal class BBSObserverContainer: NSObject {

    // MARK: - Init
    
    deinit {
        self.dispose()
        print("BBSObserverContainer deinit")
    }
    
    // MARK: - Properties
    
    internal var observers: Array<Disposable> = []
    
    // MARK: - Methods
    
    internal func add(observer: Disposable) {
        self.observers.append(observer)
    }
    
    internal func dispose() {
        for observer in self.observers {
            observer.dispose()
        }
        self.observers = []
    }
    
}
