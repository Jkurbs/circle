//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 4/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import IGListKit


class CircleInsightView: UIView, ListAdapterDataSource {

    var circleId: String!
    
    var vc: CircleVC!
    
    var tableView = UITableView()
    var insights = [Insight]()
    var users = [User]()
    var events = [Event]()
    var link = [String]()
    var data = [String]()
    
    private var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: vc, workingRangeSize: 3)
    }()
     
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        self.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        setup()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }

    
    
    func setup() {
        observeCircle()
        getInsidersByOrder()
        self.backgroundColor = UIColor.white
    }
    
    
    func observeCircle() {
        self.listener?.remove()
        self.insights = []
        self.adapter.performUpdates(animated: true)
        let circleId  = self.circleId ?? UserDefaults.standard.value(forKey: "circleId") as! String
        listener = DataService.instance.REF_CIRCLES.document(circleId).collection("time").addSnapshotListener({ querySnapshot, error in
            
            if let error = error {
                print("ERROR::", error.localizedDescription)
            } else {
                for snapshot in (querySnapshot?.documents)! {
                    if  snapshot.exists {
                        let data = snapshot.data()
                        let key = snapshot.documentID
                        let insight = Insight(key: key, data: data)
                        
                        self.insights.append(insight)
                        
                        //let circle = Circle(key: key, data: data)
                        //self.circles.append(circle)
                        //let link = circle.link
                        //                    let url = URL(string: link!)?.absoluteString
                        //                    self.link.append(url!)
                        self.adapter.performUpdates(animated: true)
                    }
                }
            }
        })
        listener?.remove()
    }
    
    
    func getInsidersByOrder() {
        self.users = []
        let circleId  = self.circleId ?? UserDefaults.standard.value(forKey: "circleId") as! String
         DataService.instance.REF_CIRCLES.document(circleId).collection("insiders").whereField("payed", isEqualTo: false).order(by: "position", descending: false).limit(to: 3).addSnapshotListener { [unowned self] (document, error) in
            if let error = error {
                print("ERROR", error.localizedDescription)
            } else {

                for document in (document?.documents)! {
                    if  document.exists {
                        let data = document.data()
                        let key = document.documentID
                        let user = User(key: key, data: data, bank: nil, event: nil, balance: nil)
                        self.users.append(user)
                        self.adapter.performUpdates(animated: false)
                    }
                }
                
                //self.stopListening()
            }
        }
    }

    
    func stopListening() {
        listener = nil
    }
    
    deinit {
        stopListening()
    }
}

extension CircleInsightView {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = self.data as [ListDiffable]
        data += insights as [ListDiffable]
        data += users as [ListDiffable]
        data += link as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if object is Insight {
           return CircleInsightSection()
        } else if object is User {
            return NextPayoutSection()
        } else if object is String {
            return HeaderSection()
        } else  {
            return CircleEventsSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
    



