//
//  ActivatedView.swift
//  Sparen
//
//  Created by Kerby Jean on 8/20/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import Cartography


class ActivatedView: UIView, ListAdapterDataSource {
    
    var viewController: UIViewController?
    var nextPayoutUsers = [User]()
    var insights = [Insight]()
    var circle: Circle!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: viewController, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        constrain(collectionView, self) { (collectionView, self) in
            collectionView.width == self.width - 20
            collectionView.height == self.height - 20
            collectionView.centerX == self.centerX
        }
        
        collectionView.layer.addShadow()
        collectionView.layer.roundCorners(radius: 5)
    }
    
    func initView() {
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        self.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivatedView {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return insights as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
           return CircleInsightSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
