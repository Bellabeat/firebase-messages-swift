//
//  BBSRoomCollectionViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSRoomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BBSRoomDataStoreDelegate {
    
    // MARK: - Private members
    
    private let dataStore: BBSRoomDataStore
    private let userId: String
    
    private var data: Array<BBSRoomModel>
    
    // MARK: - Init
    
    public init(dataStore: BBSRoomDataStore, userId: String) {
        self.dataStore = dataStore
        self.userId = userId
        self.data = Array<BBSRoomModel>()
        
        super.init(nibName: "BBSRoomCollectionViewController", bundle: NSBundle.mainBundle())
        self.dataStore.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder not supported")
    }
    
    deinit {
        self.dataStore.delegate = nil
        print("BBSRoomCollectionViewController deinit")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "BBSRoomCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: CellIdentifierRoom)
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if #available(iOS 8, *) {
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    public override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        self.collectionViewLayout.invalidateLayout()
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

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifierRoom, forIndexPath: indexPath) as! BBSRoomCollectionViewCell
        cell.room = self.data[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let room = self.data[indexPath.row]
        let messageDataStore = self.dataStore.messageDataStoreForRoom(room, userId: self.userId)
        
        let vc = BBSMessageCollectionViewController(dataStore: messageDataStore, userId: self.userId)
        vc.title = room.name.value
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - BBSRoomDataStoreDelegate
    
    public func roomDataStore(dataStore: BBSRoomDataStore, didAddRoom room: BBSRoomModel) {
        self.data.append(room)
        let newIndex = self.data.count - 1
        self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forItem: newIndex, inSection: 0)])
    }
    
    public func roomDataStore(dataStore: BBSRoomDataStore, didUpdateRoom room: BBSRoomModel) {}
    public func roomDataStore(dataStore: BBSRoomDataStore, didRemoveRoom room: BBSRoomModel) {}
    
}
