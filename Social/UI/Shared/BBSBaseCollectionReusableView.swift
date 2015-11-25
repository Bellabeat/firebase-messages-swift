//
//  BBSBaseCollectionReusableView.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal class BBSBaseCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Init
    
    deinit {
        print("BBSBaseCollectionReusableView deinit")
    }
    
    // MARK: - Properties
    
    internal var observerContainer = BBSObserverContainer()
    
    // MARK: - Methods
    
    internal func applyTheme(theme: BBSUITheme) {}
    
}
