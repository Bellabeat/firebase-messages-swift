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
    
    // MARK: - Private members
    
    private let dataStore: BBSMessageDataStore
    private var message: BBSMessageModel
    
    private var observerContainer = BBSObserverContainer()
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore) {
        self.dataStore = dataStore
        self.message = dataStore.newMessage()
        
        super.init(nibName: "BBSNewMessageViewController", bundle: NSBundle.mainBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder not supported")
    }
    
    deinit {
        print("BBSNewMessageViewController deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Message"
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: nil, action: nil)
        weak var weakSelf = self
        
        // Enabled
        self.observerContainer.add(self.inputTextView.rx_text.map { !$0.isEmpty }.bindTo(saveButton.rx_enabled))
        // Tap
        self.observerContainer.add(saveButton.rx_tap.bindNext {
            let message = weakSelf!.message
            message.message.value = weakSelf!.inputTextView.text
            message.timestamp.value = NSDate().timeIntervalSince1970
            weakSelf!.dataStore.saveMessage(message)
            
            weakSelf!.navigationController!.popViewControllerAnimated(true)
        })
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.inputTextView.becomeFirstResponder()
    }

}
