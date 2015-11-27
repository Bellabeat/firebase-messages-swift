//
//  BBSUIDarkTheme.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSUIDarkTheme: BBSUITheme {

    public override init() {
        super.init()
        
        self.contentFontName = "Arial"
        self.contentBackgroundColor = UIColor.darkGrayColor()
        self.contentTextColor = UIColor.whiteColor()
        self.contentHighlightColor = UIColor.redColor()
        
        self.navigationBarColor = UIColor.blackColor()
        self.navigationBarTextColor = UIColor.whiteColor()
        self.navigationBarTinColor = UIColor.redColor()
        self.statusBarStyle = .LightContent
        
        self.activityIndicatorTintColor = UIColor.whiteColor()
    }
    
}
