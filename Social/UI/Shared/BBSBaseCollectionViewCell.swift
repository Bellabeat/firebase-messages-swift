//
//  BBSBaseCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal class BBSBaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    
    deinit {
        print("BBSBaseCollectionViewCell deinit")
    }
    
    // MARK: - Properties
    
    internal var observerContainer = BBSObserverContainer()
    
    // MARK: - Methods
    
    internal func applyTheme(theme: BBSUITheme) {}
    
}
