//
//  NewsVC.swift
//  Sparen
//
//  Created by Kerby Jean on 2/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import FirebaseDatabase

class NewsVC: UIViewController, ListAdapterDataSource {
    
    var requests = [Request]()
    var insights = [Insight]()
    var users = [User]()
    
    var requestRef: DatabaseReference!
    var postRefHandle: DatabaseHandle!
    var query = DatabaseQuery()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.frame = view.frame
        label.textColor = .darkText
        label.backgroundColor = .white
        label.textAlignment = .center
        label.numberOfLines = 5
        label.text = "News empty"
        return label
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = .gray
        view.hidesWhenStopped = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        view.backgroundColor = .white
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        
        indicator.startAnimating()
        view.addSubview(indicator)


        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        observeRequest()
        observeCircleActivation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.requestRef.removeObserver(withHandle: self.postRefHandle!)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    func observeRequest() {
        
        if let string = UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
            requestRef = DataService.call.RefRequests.child(string).child(Auth.auth().currentUser!.uid)
            self.postRefHandle = requestRef.observe(.value) { (snapshot) in
                if snapshot.exists() {
                    self.requests.removeAll()
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let postDict = rest.value as! [String : AnyObject]
                        let request = Request(rest.key, postDict)
                        self.requests.append(request)
                        self.adapter.performUpdates(animated: true, completion: { (complete) in
                            self.indicator.stopAnimating()
                        })
                        rest.ref.updateChildValues(["seen": true])
                    }
                } else {
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    func observeCircleActivation() {
        if let string = UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
        DataService.call.RefCircleInsights.child(string).observe(.value) { (snapshot) in
            self.insights.removeAll()
            guard let value = snapshot.value, let postDict = value as? [String : AnyObject]  else {return}
            let insight = Insight(key: snapshot.key, data: postDict)
            if insight.round! > 0 {
                self.insights.append(insight)
            }
        }
    }
}
    
    @objc func observeNewUsers() {
        
        self.users = []
        
        if let string = UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
            DataService.call.RefCircleMembers.child(string).observe( .childAdded) { (snapshot) in
                
                let key = snapshot.key
                
                DataService.call.RefUsers.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let value = snapshot.value, let postDict = value as? [String : AnyObject] else {return}
                    let key = snapshot.key
                    let user = User(key: key, data: postDict)
                    self.users.append(user)
                })
            }
        }
    }
}


extension NewsVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        var object = requests as [ListDiffable]
        object += insights as [ListDiffable]
        object += users as [ListDiffable]
        return object as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Request {
            return RequestSection()
        } else if object is Insight {
            return ActivationSection()
        } else {
            return NewUserSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyLabel
    }
    
}
