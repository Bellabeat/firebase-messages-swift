//
//  BBSUITheme.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal let SystemTintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)

public class BBSUITheme: NSObject {
    
    public var contentFontName: String
    public var contentBackgroundColor: UIColor
    public var contentTextColor: UIColor
    public var contentHighlightColor: UIColor
    public var contentDimmedColor: UIColor
    
    public var navigationBarColor: UIColor
    public var navigationBarTextColor: UIColor
    public var navigationBarTinColor: UIColor
    public var statusBarStyle: UIStatusBarStyle
    
    public var activityIndicatorTintColor: UIColor
    
    public override init() {
        self.contentFontName = "Helvetica Neue"
        self.contentBackgroundColor = UIColor.whiteColor()
        self.contentTextColor = UIColor.blackColor()
        self.contentHighlightColor = SystemTintColor
        self.contentDimmedColor = UIColor.lightGrayColor()
        
        self.navigationBarColor = UIColor.whiteColor()
        self.navigationBarTextColor = UIColor.blackColor()
        self.navigationBarTinColor = SystemTintColor
        self.statusBarStyle = .Default
        
        self.activityIndicatorTintColor = UIColor.blackColor()
        
        super.init()
    }
    
    public func applyToViewController(viewController: UIViewController) {
        viewController.view.backgroundColor = self.contentBackgroundColor
        if let collectionViewController = viewController as? UICollectionViewController {
            collectionViewController.collectionView?.backgroundColor = self.contentBackgroundColor
        }
        
        viewController.navigationController?.navigationBar.barTintColor = self.navigationBarColor
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.navigationBarTextColor]
        viewController.navigationController?.navigationBar.tintColor = self.navigationBarTinColor
    }
    
}
