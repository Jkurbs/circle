//
//  AddUsersVC.swift
//  Sparen
//
//  Created by Kerby Jean on 7/26/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class AddUsersVC: UIViewController, ListAdapterDataSource {
    
    var circle = [Circle]()
    var users = [User]()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
    }
    
    
    
    func initView() {
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .white
            //UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        retrieveCircle()
        retrieveInsiders()
    }

    
    func retrieveCircle() {
        let circleID = UserDefaults.standard.string(forKey: "circleId")
        DataService.call.fetchCircle(circleID) { (success, error, circle) in
            if !success {
                print("ERROR", error!.localizedDescription)
            } else {
                self.circle.append(circle!)
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    func retrieveInsiders() {
        DataService.call.fetchUsers { (success, users, error) in
            if !success {
                print("ERROR", error!.localizedDescription)
            } else {
                self.users = users!
                self.adapter.performUpdates(animated: true)
            }
        }
    }
}

extension AddUsersVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
       var data = circle as [ListDiffable]
       data += users as [ListDiffable]
       return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Circle {
           return AddUsersSection()
        } else {
            return InsidersSection() 
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
