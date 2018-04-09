////
////  TestVC.swift
////  Circle
////
////  Created by Kerby Jean on 3/12/18.
////  Copyright © 2018 Kerby Jean. All rights reserved.
////
//
//import UIKit
//import IGListKit
//import FirebaseAuth
//
//class TestVC: UIViewController {
//
//    var circleId: String?
//    var currentUser = [User]()
//    var circle = [Circle]()
//    
//    lazy var adapter: ListAdapter = {
//        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
//    }()
//    
//    let data = Array(0..<20)
//    
//    let collectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
//    )
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        view.backgroundColor = .white
//        view.addSubview(collectionView)
//        collectionView.backgroundColor =  UIColor.clear
//        adapter.collectionView = collectionView
//        adapter.dataSource = self
//        retrieveUser()
//       
//    }
//
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds
//    }
//    
//    
//    private func retrieveUser()  {
//        DataService.instance.retrieveUser(Auth.auth().currentUser!.uid) { (success, error, user, data, bank, event) in
//            if !success {
//                 print("Failed to retrieve user")
//            } else {
//                self.currentUser = []
//                self.currentUser.insert(user!, at: 0)
//                self.adapter.performUpdates(animated: true)
//            }
//        }
//    }
//}
//
//
//
//
//
//extension TestVC: ListAdapterDataSource {
//    
//    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        return currentUser as [ListDiffable]
//    }
//    
//    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//           return FirstListC()
//    }
//    
//    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        return nil
//    }
//}

