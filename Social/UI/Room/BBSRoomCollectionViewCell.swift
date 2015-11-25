//
//  BBSRoomCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let CellIdentifierRoom = "roomCell"

internal class BBSRoomCollectionViewCell: BBSBaseCollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    // MARK: - Properties
    
    internal var room: BBSRoomModel? {
        didSet {
            self.observerContainer.dispose()
            if let room = self.room {
                self.observerContainer.add(room.name.bindTo(self.roomTitleLabel.rx_text))
            }
        }
    }
    
    // MARK: - Methods
    
    override func applyTheme(theme: BBSUITheme) {
        self.roomTitleLabel.font = UIFont(name: theme.contentFontName, size: 34.0)
        self.roomTitleLabel.textColor = theme.contentTextColor
    }
    
}
