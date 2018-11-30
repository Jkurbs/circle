//
//  ReadyView.swift
//  Sparen
//
//  Created by Kerby Jean on 8/14/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import Cartography
import FirebaseFirestore



class ReadyView: UIView, ListAdapterDataSource {
    
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

        initView()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(collectionView, self) { (collectionView, self) in
            collectionView.width == self.width  - 10
            collectionView.height == self.height
            collectionView.centerX == self.centerX
        }
        
        collectionView.cornerRadius = 10
//        collectionView.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: -2, height: 2), radius: 5, scale: true)

    }
    
    func initView() {
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        self.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    func fetchMembersCount(_ circle: Circle) {
        DataService.call.RefCircles.child(circle.id!).child("members").observeSingleEvent(of: .value) { (snapshot) in
            self.members.removeAll()
            guard let value = snapshot.value, let count = value as? Int else {return}
            self.members.append(count)
            self.adapter.performUpdates(animated: false)
        }
    }
    
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReadyView {
    
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

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
