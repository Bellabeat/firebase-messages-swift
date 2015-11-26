//
//  BBSMessageHeaderCollectionReusableView.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let ViewIdentifierMessageHeader = "messageHeaderView"

internal class BBSMessageHeaderCollectionReusableView: BBSBaseCollectionReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sorterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Properties
    
    internal var room: BBSRoomModel? {
        didSet {
            if let room = self.room {
                self.observerContainer.dispose()
                self.observerContainer.add(room.note.bindTo(textLabel.rx_text))
            }
        }
    }
    
}
