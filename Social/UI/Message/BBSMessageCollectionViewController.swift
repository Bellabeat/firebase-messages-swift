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
    private let room: BBSRoomModel?
    private let userId: String
    
    private var data: Array<BBSMessageModel>
    
    private var observerContainer = BBSObserverContainer()
    
    // MARK: - Init
    
    public init(dataStore: BBSMessageDataStore, room: BBSRoomModel?, userId: String) {
        self.dataStore = dataStore
        self.room = room
        self.userId = userId
        self.data = Array<BBSMessageModel>()
        
        super.init(nibName: "BBSMessageCollectionViewController", bundle: NSBundle.mainBundle())
        self.dataStore.delegate = self
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
        let width = collectionView.frame.size.width - 70.0
        let font = self.theme != nil ? UIFont(name: theme!.contentFontName, size: 18.0)! : UIFont.systemFontOfSize(18.0)
        let model = self.data[indexPath.row]
        
        let height = self.heightForText(model.message.value, font: font, width: width) + 53.0
        return CGSizeMake(collectionView.frame.size.width, max(height, 110.0))
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let room = self.room {
            if room.note.value.isEmpty {
                return CGSizeZero
            }
            
            let width = collectionView.frame.size.width - 20.0
            let font = self.theme != nil ? UIFont(name: theme!.contentFontName, size: 18.0)! : UIFont.systemFontOfSize(18.0)
    
            let height = self.heightForText(room.note.value, font: font, width: width) + 30.0
            return CGSizeMake(collectionView.frame.size.width, height)
        }
        return CGSizeZero
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
    
    public override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let room = self.room {
                let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewIdentifierInfo, forIndexPath: indexPath) as! BBSInfoCollectionReusableView
                
                if let theme = self.theme {
                    view.applyTheme(theme)
                }
                
                view.room = room
                
                return view
            }
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
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
