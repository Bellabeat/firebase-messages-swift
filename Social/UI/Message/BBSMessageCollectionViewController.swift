//
//  BBSMessageCollectionViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSMessageCollectionViewController: BBSBaseCollectionViewController, BBSMessageDataStoreDelegate {
    
    // MARK: - Private members
    
    private let dataStore: BBSMessageDataStore
    private let userId: String
    
    private var data: Array<BBSMessageModel>
    private let sizingLabel: UILabel
    
    private var observerContainer = BBSObserverContainer()
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore, userId: String) {
        self.dataStore = dataStore
        self.userId = userId
        self.data = Array<BBSMessageModel>()
        self.sizingLabel = UILabel()
        
        super.init(nibName: "BBSMessageCollectionViewController", bundle: NSBundle.mainBundle())
        self.dataStore.delegate = self
        
        self.sizingLabel.numberOfLines = 0
        self.sizingLabel.font = UIFont.systemFontOfSize(18.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    deinit {
        self.dataStore.delegate = nil
        print("BBSMessageCollectionViewController deinit")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "BBSMessageCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: CellIdentifierMessage)
        
        let newMessageButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: nil, action: nil)
        weak var weakSelf = self
        self.observerContainer.add(newMessageButton.rx_tap.bindNext {
            let vc = BBSNewMessageViewController(dataStore: weakSelf!.dataStore)
            vc.theme = weakSelf!.theme
            weakSelf!.navigationController!.pushViewController(vc, animated: true)
        })
        self.navigationItem.rightBarButtonItem = newMessageButton
    }

    // MARK: UICollectionViewDataSource

    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.sizingLabel.preferredMaxLayoutWidth = collectionView.frame.size.width - 70.0
        if let theme = self.theme {
            self.sizingLabel.font = UIFont(name: theme.contentFontName, size: 18.0)
        }
        let model = self.data[indexPath.row]
        self.sizingLabel.text = model.message.value
        
        let size = self.sizingLabel.intrinsicContentSize()
        let height = size.height + 53.0
        
        return CGSizeMake(collectionView.frame.size.width, max(height, 110.0))
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifierMessage, forIndexPath: indexPath) as! BBSMessageCollectionViewCell
        
        if let theme = self.theme {
            cell.applyTheme(theme)
        }
        
        cell.userId = self.userId
        cell.message = self.data[indexPath.row]
        
        return cell
    }

    // MARK: - BBSMessageDataStoreDelegate
    
    public func messageDataStore(dataStore: BBSMessageDataStore, didAddMessage message: BBSMessageModel) {
        self.hideLoader()
        if let index = self.dataStore.sorter.indexForMessage(message, inArray: self.data) {
            self.data.insert(message, atIndex: index)
            self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        }
    }
    
    public func messageDataStore(dataStore: BBSMessageDataStore, didUpdateMessage message: BBSMessageModel) {}
    
    public func messageDataStore(dataStore: BBSMessageDataStore, didRemoveMessage message: BBSMessageModel) {
        if let index = self.data.indexOf(message) {
            self.data.removeAtIndex(index)
            self.collectionView!.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
        }
    }
    
    public func messageDataStoreHasNoData(dataStore: BBSMessageDataStore) {
        self.hideLoader()
    }
    
}
