//
//  BBSRoomCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSRoomCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var roomTitleLabel: UILabel!
    
    // MARK: - Properties
    
    public static let cellIdentifier = "roomCell"
    
    public var room: BBSRoomModel? {
        didSet {
            if let titleObserver = self.titleObserver {
                titleObserver.dispose()
                self.titleObserver = nil
            }
            
            if let room = self.room {
                self.titleObserver = Variable(room.name).bindTo(self.roomTitleLabel.rx_text)
            }
        }
    }
    
    // MARK: - Private members
    
    var titleObserver: Disposable?
    
    // MARK: - Init
    
    deinit {
        print("BBSRoomCollectionViewCell deinit")
    }
    
}
