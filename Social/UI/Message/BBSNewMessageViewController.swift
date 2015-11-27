//
//  BBSNewMessageViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSNewMessageViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var inputTextView: UITextView!
    
    // MARK: - Properties
    
    public var theme: BBSUITheme?
    public private(set) var message: BBSMessageModel?
    
    // MARK: - Private members
    
    private let dataStore: BBSMessageDataStore
    
    private var observerContainer = BBSObserverContainer()
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore) {
        self.dataStore = dataStore
        super.init(nibName: "BBSNewMessageViewController", bundle: NSBundle.mainBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    deinit {
        print("BBSNewMessageViewController deinit")
    }
    
    // MARK: - View lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Message"
        if let theme = self.theme {
            theme.applyToViewController(self)
            self.inputTextView.font = UIFont(name: theme.contentFontName, size: 15.0)
            self.inputTextView.textColor = theme.contentTextColor
            self.inputTextView.tintColor = theme.contentHighlightColor
        }
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: nil, action: nil)
        weak var weakSelf = self
        
        // Enabled
        self.observerContainer.add(self.inputTextView.rx_text.map { $0.characters.count > 9 }.bindTo(saveButton.rx_enabled))
        // Tap
        self.observerContainer.add(saveButton.rx_tap.bindNext {
            let message = weakSelf!.dataStore.newMessage()
            message.message.value = weakSelf!.inputTextView.text
            message.timestamp.value = NSDate().timeIntervalSince1970
            weakSelf!.dataStore.createMessage(message)
            weakSelf!.message = message
            
            weakSelf!.navigationController!.popViewControllerAnimated(true)
        })
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.inputTextView.becomeFirstResponder()
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.theme != nil ? self.theme!.statusBarStyle : .Default
    }

}
