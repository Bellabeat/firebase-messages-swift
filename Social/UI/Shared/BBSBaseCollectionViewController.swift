//
//  BBSBaseCollectionViewController.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

import UIKit

public class BBSBaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties
    
    public var theme: BBSUITheme?
    
    internal var didLoad = false
    internal let sizingLabel: UILabel
    internal var refreshControl: UIRefreshControl
    
    internal var observerContainer = BBSObserverContainer()
    
    // MARK: - Init
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.sizingLabel = UILabel()
        self.refreshControl = UIRefreshControl()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.sizingLabel.numberOfLines = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.theme?.applyToViewController(self)
        self.collectionView!.registerNib(UINib(nibName: "BBSLoadingCollectionReusableView", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ViewIdentifierLoading)
        
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        self.collectionView!.addSubview(self.refreshControl)
        self.collectionView!.alwaysBounceVertical = true
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
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
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.theme != nil ? self.theme!.statusBarStyle : .Default
    }

    // MARK: UICollectionViewDataSource
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.didLoad ? CGSizeZero : CGSizeMake(collectionView.frame.size.width, 77.0)
    }
    
    public override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewIdentifierLoading, forIndexPath: indexPath) as! BBSLoadingCollectionReusableView
            if let theme = self.theme {
                view.applyTheme(theme)
            }
            return view
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: - Methods
    
    internal func showLoader() {
        if self.didLoad {
            self.didLoad = false
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    internal func hideLoader() {
        if !self.didLoad {
            self.didLoad = true
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    internal func onRefresh() {
        self.refreshControl.endRefreshing()
    }
    
    internal func heightForText(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        self.sizingLabel.preferredMaxLayoutWidth = width
        self.sizingLabel.font = font
        self.sizingLabel.text = text
        
        let size = self.sizingLabel.intrinsicContentSize()
        return size.height
    }

}
