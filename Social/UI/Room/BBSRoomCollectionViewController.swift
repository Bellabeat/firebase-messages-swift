//
//  BBSRoomCollectionViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSRoomCollectionViewController: BBSBaseCollectionViewController, BBSRoomDataStoreDelegate, BBSGlobalDataStoreDelegate {
    
    // MARK: - Private members
    
    private let dataStore: BBSRoomDataStore
    private let globalDataStore: BBSGlobalDataStore
    private let userId: String
    
    private var data: Array<BBSRoomModel>
    
    // MARK: - Init
    
    public init(dataStore: BBSRoomDataStore, globalDataStore: BBSGlobalDataStore, userId: String) {
        self.dataStore = dataStore
        self.globalDataStore = globalDataStore
        self.userId = userId
        self.data = Array<BBSRoomModel>()
        
        super.init(nibName: "BBSRoomCollectionViewController", bundle: NSBundle.mainBundle())
        self.dataStore.delegate = self
        self.globalDataStore.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    deinit {
        self.dataStore.delegate = nil
        self.globalDataStore.delegate = nil
        print("BBSRoomCollectionViewController deinit")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "BBSRoomCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: CellIdentifierRoom)
        self.collectionView!.registerNib(UINib(nibName: "BBSInfoCollectionReusableView", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewIdentifierInfo)
        
        self.dataStore.loadAsync()
    }
    
    // MARK: - Overrides
    
    override func onRefresh() {
        self.dataStore.loadAsync()
        super.onRefresh()
    }
    
    // MARK: UICollectionViewDataSource

    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, 100.0)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if !self.globalDataStore.global.note.value.isEmpty {
            let width = collectionView.frame.size.width - 20.0
            let font = self.theme != nil ? UIFont(name: theme!.contentFontName, size: 18.0)! : UIFont.systemFontOfSize(18.0)
            
            let height = self.heightForText(globalDataStore.global.note.value, font: font, width: width) + 20.0
            return CGSizeMake(collectionView.frame.size.width, height)
        }
        return CGSizeZero
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifierRoom, forIndexPath: indexPath) as! BBSRoomCollectionViewCell
        
        if let theme = self.theme {
            cell.applyTheme(theme)
        }
        
        cell.room = self.data[indexPath.row]
        
        return cell
    }
    
    public override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewIdentifierInfo, forIndexPath: indexPath) as! BBSInfoCollectionReusableView
            
            if let theme = self.theme {
                view.applyTheme(theme)
            }
            
            view.global = self.globalDataStore.global
            
            return view
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }

    // MARK: UICollectionViewDelegate

    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let room = self.data[indexPath.row]
        let messageDataStore = self.dataStore.messageDataStoreForRoom(room, userId: self.userId)
        
        let vc = BBSMessageCollectionViewController(dataStore: messageDataStore, room: room, userId: self.userId)
        vc.title = room.name.value
        vc.theme = self.theme
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - BBSRoomDataStoreDelegate
    
    public func roomDataStore(dataStore: BBSRoomDataStore, didLoadData data: Array<BBSRoomModel>) {
        self.hideLoader()
        self.data = data
        self.collectionView?.reloadData()
    }
    
    // MARK: - BBSGlobalDataStoreDelegate
    
    public func globalDataStoreDidUpdate(dataStore: BBSGlobalDataStore) {
        self.collectionViewLayout.invalidateLayout()
    }
    
}
