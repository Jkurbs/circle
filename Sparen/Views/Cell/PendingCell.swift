//
//  PendingCell.swift
//  Sparen
//
//  Created by Kerby Jean on 11/6/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import Cartography

class PendingCell: UICollectionViewCell, ListAdapterDataSource {
    
    var viewController: UIViewController?
    
    var members = [Int]()
    
    var circle: Circle! {
        didSet {
            fetchMembersCount(circle)
        }
    }
    
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
            collectionView.width == self.width
            collectionView.height == self.height
            collectionView.centerX == self.centerX
        }
    }
    
    func initView() {
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        self.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    func fetchMembersCount(_ circle: Circle) {
        
        if circle.id != "" {
            DataService.call.RefCircles.child(circle.id!).child("members").observeSingleEvent(of: .value) { (snapshot) in
                self.members.removeAll()
                guard let value = snapshot.value, let count = value as? Int else {
                    return
                }
                
                self.members.append(count)
                self.adapter.performUpdates(animated: false)
            }
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PendingCell {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let data = members as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SetupSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
