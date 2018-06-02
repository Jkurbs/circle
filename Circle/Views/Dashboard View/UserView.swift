//
//  UserView.swift
//  Circle
//
//  Created by Kerby Jean on 3/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import FirebaseFirestore


class UserView: UIView, ListAdapterDataSource, ListSingleSectionControllerDelegate {
    
    var viewController: CircleVC!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 4)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var view = UIView()
    
    var parentView: UserDashboardView!
    var events = [Event]()
    var listener: ListenerRegistration!
    var expanded: Bool = false
    var collectionViewFrame: CGRect!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight]
        collectionViewFrame = collectionView.frame
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let displayWidth: CGFloat = self.frame.width
        collectionView.frame =  CGRect(x: 0, y: 0, width: displayWidth, height: 150)
        self.addSubview(collectionView)
        
        self.addSubview(view)

        view.frame = CGRect(x: 0 , y: self.bounds.height - 15, width: 60, height: 5)
        view.center.x = self.center.x
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.cornerRadius = 2.5
    }
    
    
    func get(_ user: User) {
        events = []
        self.adapter.reloadData(completion: nil)
        listener = DataService.instance.REF_USERS.document(user.userId!).collection("events").order(by: "date", descending: true).addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreiving snapshots \(error!)")
                return
            }
            for document in snapshot.documents {
                if document.exists {
                    let data = document.data()
                    let key = document.documentID
                    let event = Event(key: key, data: data)
                    self.events.append(event)
                    self.reload()
                }
            }
            self.listener.remove()
        }
    }
    
    
    func reload() {
        self.adapter.performUpdates(animated: true) { (success) in
            //self.listener.remove()
        }
    }
}

extension UserView {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return events as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return UserListController()
    }
    
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel()
        label.frame = self.frame
        label.text = "No data to show yet."
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }
}
