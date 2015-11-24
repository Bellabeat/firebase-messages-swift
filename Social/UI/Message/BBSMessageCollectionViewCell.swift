//
//  BBSMessageCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let CellIdentifierMessage = "messageCell"

public class BBSMessageCollectionViewCell: BBSBaseCollectionViewCell {

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
                weak var weakSelf = self
                self.observers.append(message.message.bindTo(self.messageTextLabel.rx_text))
                self.observers.append(message.timestamp.map { "\($0)" }.bindTo(self.messageTimestampLabel.rx_text))
                self.observers.append(message.points.map { "\($0)" }.bindTo(self.messagePointsLabel.rx_text))
                self.observers.append(message.points.bindNext { _ in
                    weakSelf!.updateAppearance()
                })
                self.observers.append(self.upvoteButton.rx_controlEvents(.TouchUpInside).bindNext {
                    weakSelf!.message!.upvoteForUser(weakSelf!.userId)
                })
                self.observers.append(self.downvoteButton.rx_controlEvents(.TouchUpInside).bindNext {
                    weakSelf!.message!.downvoteForUser(weakSelf!.userId)
                })
            }
        }
    }
    
    public var userId: String = ""
    
    // MARK: - Private methods
    
    private func updateAppearance() {
        if let message = self.message {
            if message.didUpvoteForUser(self.userId) {
                self.upvoteButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
                self.downvoteButton.setTitleColor(UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
            } else if message.didDownvoteForUser(self.userId) {
                self.downvoteButton.setTitleColor(UIColor.redColor(), forState: .Normal)
                self.upvoteButton.setTitleColor(UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
            } else {
                self.upvoteButton.setTitleColor(UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
                self.downvoteButton.setTitleColor(UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: .Normal)
            }
        }
    }

}
