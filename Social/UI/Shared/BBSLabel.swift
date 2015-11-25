//
//  BBSLabel.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal class BBSLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.numberOfLines == 0 {
            if self.preferredMaxLayoutWidth != self.frame.size.width {
                self.preferredMaxLayoutWidth = self.frame.size.width
                self.setNeedsUpdateConstraints()
            }
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        
        if self.numberOfLines == 0 {
            size.height += 1
        }
        
        return size
    }

}
