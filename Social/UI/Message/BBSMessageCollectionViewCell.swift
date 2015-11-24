//
//  BBSMessageCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let CellIdentifierMessage = "messageCell"

public class BBSMessageCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimestampLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var messagePointsLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    
    // MARK: - Properties
    
    public var message: BBSMessageModel? {
        didSet {
            self.dispose()
            if let message = self.message {
                self.observers.append(Variable(message.message).bindTo(self.messageTextLabel.rx_text))
                self.observers.append(Variable(message.timestamp).map { "\($0)" }.bindTo(self.messageTimestampLabel.rx_text))
                self.observers.append(Variable(message.points).map { "\($0)" }.bindTo(self.messagePointsLabel.rx_text))
            }
        }
    }
    
    public var userId: String = ""
    
    // MARK: - Private members
    
    private var observers: Array<Disposable> = []
    
    private func dispose() {
        for observer in self.observers {
            observer.dispose()
        }
        self.observers = []
    }
    
    // MARK: - Init
    
    deinit {
        self.dispose()
        print("BBSMessageCollectionViewCell deinit")
    }

}
