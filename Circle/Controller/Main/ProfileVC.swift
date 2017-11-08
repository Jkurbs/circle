
//  ProfileVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-05.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit
import FirebaseAuth

class ProfileVC: UIViewController, ListAdapterDataSource, ListSingleSectionControllerDelegate {

    lazy var loginVC = LoginViewController()
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
        print("PROFILE VC")
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.performUpdates(animated: true)
        setupViews()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    func setupViews() {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = button
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return user
    }
}

extension ProfileVC {
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ProfileSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        
    }
}




