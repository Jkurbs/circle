//
//  CircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IGListKit


enum State {
    case collapsed
    case expanded
}


class CircleVC: UIViewController, ListAdapterDataSource {

    
    var circleId: String?
    var user = [User]()
    var circle = [Circle]()
    
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        collectionView.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        collectionView.isScrollEnabled = false 
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        retrieve()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    private func retrieve() {
        if let uid = Auth.auth().currentUser?.uid ?? UserDefaults.standard.value(forKey: "userId") as? String {
            DataService.instance.REF_USERS.document(uid).getDocument { (snapshot, error) in
                if let error = error {
                    return
                } else {
                    
                    guard let snap = snapshot else {
                        return
                    }                    
                    let key = snap.documentID
                    let data = snap.data()
                    let user = User(key: key, data: data!)
                    self.user.append(user)
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        }
    }
}

extension CircleVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return user as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return UpperSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil 
    }
    
}










