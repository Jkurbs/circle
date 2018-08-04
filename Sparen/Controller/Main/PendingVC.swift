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
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VIEW HEIGHT::", view.frame.height)

        
        // Init the static view
        initView()
    }
    
    
    func initView() {
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
        DataService.call.fetchCurrentUser { (success, user,  error) in
            if !success {
                print("error" )
            } else {
                self.user = user
                self.adapter.performUpdates(animated: true)
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










