//
//  BBSLoginViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

internal class BBSLoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hintLabel: BBSLabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    internal var theme: BBSUITheme?
    
    // MARK: - Private members
    
    private var observerContainer = BBSObserverContainer()
    
    // MARK: - Init
    
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.observerContainer.dispose()
        print("BBSLoginViewController deinit")
    }

    // MARK: - View lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        if let theme = self.theme {
            theme.applyToViewController(self)
            self.subtitleLabel.textColor = theme.contentTextColor
            self.titleLabel.textColor = theme.contentTextColor
            self.hintLabel.textColor = theme.contentTextColor
            self.loginButton.tintColor = theme.contentHighlightColor
        }
        
        weak var weakSelf = self
        self.observerContainer.add(self.loginButton.rx_controlEvents(.TouchUpInside).bindNext {
            if let text = weakSelf?.usernameTextField.text {
                if !text.isEmpty {
                    let roomsViewController = BBSFactory.createRoomsControllerWithUrl("https://bellabeat-feedback.firebaseio.com/", forUser: text, withTheme: self.theme)
                    self.navigationController?.pushViewController(roomsViewController, animated: true)
                }
            }
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.theme?.statusBarStyle ?? .Default
    }
    
    internal override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

}
