//
//  BBSMessageCollectionViewCell.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let CellIdentifierMessage = "messageCell"

internal class BBSMessageCollectionViewCell: BBSBaseCollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimestampLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var messagePointsLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var clockImageView: UIImageView!
    
    // MARK: - Properties
    
    internal var message: BBSMessageModel? {
        didSet {
            self.observerContainer.dispose()
            if let message = self.message {
                weak var weakSelf = self
                self.observerContainer.add(message.message.bindTo(self.messageTextLabel.rx_text))
                self.observerContainer.add(message.timestamp.map {
                    let seconds = $0 - NSDate().timeIntervalSince1970
                    return BBSMessageCollectionViewCell.timeFormatter.stringForTimeInterval(seconds)
                }.bindTo(self.messageTimestampLabel.rx_text))
                self.observerContainer.add(message.points.map { "\($0)" }.bindTo(self.messagePointsLabel.rx_text))
                self.observerContainer.add(message.points.bindNext { _ in
                    weakSelf!.updateAppearance()
                })
                self.observerContainer.add(self.upvoteButton.rx_controlEvents(.TouchUpInside).bindNext {
                    weakSelf!.message!.upvoteForUser(weakSelf!.userId)
                })
                self.observerContainer.add(self.downvoteButton.rx_controlEvents(.TouchUpInside).bindNext {
                    weakSelf!.message!.downvoteForUser(weakSelf!.userId)
                })
            }
        }
    }
    
    internal var userId: String = ""
    
    // MARK: - Private members
    
    private static let timeFormatter = TTTTimeIntervalFormatter()
    
    private static let neutralColor = UIColor(white: 225.0/255.0, alpha: 1.0)
    private static let clockImage = UIImage(named: "Clock")?.imageWithRenderingMode(.AlwaysTemplate)
    private static let upvoteImage = UIImage(named: "Upvote")?.imageWithRenderingMode(.AlwaysTemplate)
    private static let downvoteImage = UIImage(named: "Downvote")?.imageWithRenderingMode(.AlwaysTemplate)
    
    private var cellTextColor = UIColor.blackColor()
    private var cellTintColor = SystemTintColor
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateAppearance()
    }
    
    // MARK: - Methods
    
    internal override func applyTheme(theme: BBSUITheme) {
        self.messageTextLabel.font = UIFont(name: theme.contentFontName, size: 18.0)
        self.messageTimestampLabel.font = UIFont(name: theme.contentFontName, size: 16.0)
        self.messagePointsLabel.font = UIFont(name: theme.contentFontName, size: 30.0)
        
        self.cellTextColor = theme.contentTextColor
        self.cellTintColor = theme.contentTintColor
    }
    
    // MARK: - Private methods
    
    private func updateAppearance() {
        self.messageTextLabel.textColor = self.cellTextColor
        self.clockImageView.image = BBSMessageCollectionViewCell.clockImage
        self.clockImageView.tintColor = self.cellTintColor
        self.messageTimestampLabel.textColor = self.cellTintColor
        self.messagePointsLabel.textColor = self.cellTintColor
        
        self.upvoteButton.tintColor = BBSMessageCollectionViewCell.neutralColor
        self.downvoteButton.tintColor = BBSMessageCollectionViewCell.neutralColor
        self.upvoteButton.setImage(BBSMessageCollectionViewCell.upvoteImage, forState: .Normal)
        self.downvoteButton.setImage(BBSMessageCollectionViewCell.downvoteImage, forState: .Normal)
        
        if let message = self.message {
            self.upvoteButton.tintColor = message.didUpvoteForUser(self.userId) ? self.cellTintColor : BBSMessageCollectionViewCell.neutralColor
            self.downvoteButton.tintColor = message.didDownvoteForUser(self.userId) ? self.cellTintColor : BBSMessageCollectionViewCell.neutralColor
        }
    }
    
}
