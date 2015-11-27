//
//  BBSNavigationController.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal class BBSNavigationController: UINavigationController {

    // MARK: - Init
    
    internal override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Overrides
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }

}
