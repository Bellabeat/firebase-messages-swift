//
//  BBSBaseCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSBaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    
    deinit {
        self.dispose()
        print("BBSBaseCollectionViewCell deinit")
    }
    
    // MARK: - Properties
    
    internal var observers: Array<Disposable> = []
    
    // MARK: - Methods
    
    internal func dispose() {
        for observer in self.observers {
            observer.dispose()
        }
        self.observers = []
    }
    
}
