//
//  BBSGlobalDataStore.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit
import Firebase

public protocol BBSGlobalDataStoreDelegate: NSObjectProtocol {
    func globalDataStoreDidUpdate(dataStore: BBSGlobalDataStore)
}

public class BBSGlobalDataStore: NSObject {
    
    // MARK: - Properties
    
    weak public var delegate: BBSGlobalDataStoreDelegate?
    public private(set) var global: BBSGlobalModel
    
    // MARK: - Private members
    
    private var root: Firebase!
    
    // MARK: - Init
    
    public init(root: Firebase) {
        self.root = root.childByAppendingPath("global")
        self.global = BBSGlobalModel()
        super.init()
        
        weak var weakSelf = self
        
        // Value
        self.root.observeEventType(.Value, withBlock: { snapshot in
            if !snapshot.exists() { return }
            
            weakSelf?.global.updateWithObject(snapshot.value)
            
            if let delegate = weakSelf?.delegate {
                delegate.globalDataStoreDidUpdate(weakSelf!)
            }
        })
    }
    
    deinit {
        self.root.removeAllObservers()
        print("BBSGlobalDataStore deinit")
    }
    
}
