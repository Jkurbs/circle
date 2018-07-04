//
//  EditAccountVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import IGListKit


final class EditAccountVC: UIViewController, ListAdapterDataSource {
    
    var user = [User]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white 

        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        retrieveCurrentUser()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    
    func retrieveCurrentUser() {
        
        DataService.call.REF_USERS.document(Auth.auth().currentUser!.uid).getDocument { (snapshot, error) in
            if let error = error {
                print("error", error.localizedDescription)
            } else {
                
                if let snap = snapshot {
                    if snap.exists {
                        let key = snap.documentID
                        let data = snap.data()
                        let user = User(key: key, data: data!)
                        self.user.append(user)
                    }
                }
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }
}

extension EditAccountVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return user as[ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return EditAccountSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
