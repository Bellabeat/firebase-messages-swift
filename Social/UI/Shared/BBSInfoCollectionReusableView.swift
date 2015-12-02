//
//  BBSInfoCollectionReusableView.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let ViewIdentifierInfo = "infoView"

internal class BBSInfoCollectionReusableView: BBSBaseCollectionReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Properties
    
    internal var global: BBSGlobalModel? {
        didSet {
            self.observerContainer.dispose()
            if let global = self.global {
                self.observerContainer.add(global.note.bindTo(self.textLabel.rx_text))
            }
        }
    }
    
    internal var room: BBSRoomModel? {
        didSet {
            self.observerContainer.dispose()
            if let room = self.room {
                self.observerContainer.add(room.note.bindTo(self.textLabel.rx_text))
            }
        }
    }
    
    // MARK: - Methods
    
    internal override func applyTheme(theme: BBSUITheme) {
        self.textLabel.font = UIFont(name: theme.contentFontName, size: 18.0)
        self.textLabel.textColor = theme.contentTextColor
    }
    
}
