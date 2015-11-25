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
    
    // MARK; - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageSorterDidChange:", name: BBSNotificationMessageSorterDidChange, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Private methods
    
    internal func messageSorterDidChange(notification: NSNotification) {
        if let sorter = notification.userInfo?[BBSKeyNewMessageSorter] {
            if sorter is BBSTopMessageSorter {
                self.sorterSegmentedControl.selectedSegmentIndex = 0
            } else if sorter is BBSNewMessageSorter {
                self.sorterSegmentedControl.selectedSegmentIndex = 1
            }
        }
    }
    
}
