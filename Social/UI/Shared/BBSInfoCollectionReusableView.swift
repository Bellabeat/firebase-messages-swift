//
//  BBSInfoCollectionReusableView.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let ViewIdentifierInfo = "infoView"

internal class BBSInfoCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Methods
    
    internal func applyTheme(theme: BBSUITheme) {
        self.textLabel.font = UIFont(name: theme.contentFontName, size: 20.0)
        self.textLabel.textColor = theme.contentTextColor
    }
    
}
