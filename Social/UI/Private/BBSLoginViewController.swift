//
//  BBSLoginViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

class BBSLoginViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func loginTapped(sender: AnyObject) {
        if let text = self.usernameTextField.text {
            if !text.isEmpty {
                let rooms = BBSFactory.createRoomsControllerWithUrl("https://bellabeat-feedback.firebaseio.com/", forUser: text)
                
                self.navigationController?.pushViewController(rooms, animated: true)
            }
        }
    }

}
