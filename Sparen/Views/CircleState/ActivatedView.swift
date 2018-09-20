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
    
        initView()
        fetchPayoutUsers()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(collectionView, self) { (collectionView, self) in
            collectionView.width == self.width 
            collectionView.height == self.height
            collectionView.centerX == self.centerX
        }
        
        collectionView.cornerRadius = 10
        collectionView.shadowRadius = 5.0
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.shadowOpacity = 0.2
        
        
        //collectionView.frame = self.frame
    }
    
    func initView() {
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        self.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    func fetchPayoutUsers() {
        DataService.call.fetchPayoutUsers { (success, user, error) in
            if !success {
                print("error:", error!.localizedDescription)
            } else {
                self.nextPayoutUsers.append(user!)
                self.adapter.reloadData(completion: nil)
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivatedView {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = insights as [ListDiffable]
        data += nextPayoutUsers as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Insight {
           return CircleInsightSection()
        } else {
            return NextPayoutSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
