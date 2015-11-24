//
//  BBSRoomCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let CellIdentifierRoom = "roomCell"

public class BBSRoomCollectionViewCell: BBSBaseCollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    // MARK: - Properties
    
    public var room: BBSRoomModel? {
        didSet {
            self.dispose()
            if let room = self.room {
                self.observers.append(room.name.bindTo(self.roomTitleLabel.rx_text))
            }
        }
    }
    
}
