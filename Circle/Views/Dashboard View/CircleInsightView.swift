//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 4/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import TableViewHelper
import FirebaseFirestore
import FirebaseAuth
import IGListKit


class CircleInsightView: UIView, ListAdapterDataSource {

    var circleId: String!
    
    var vc: CircleVC!
    
    var tableView = UITableView()
    var helper: TableViewHelper!
    var circles = [Circle]()
    var users = [User]()
    var events = [Event]()
    var header = ["Recent"]
    
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
        getCircleActivities()
        self.backgroundColor = UIColor.white
    }
    
    
    func observeCircle() {
        self.circles = []
        let circleId  = self.circleId ?? UserDefaults.standard.value(forKey: "circleId") as! String
        Firestore.firestore().collection("circles").document(circleId).addSnapshotListener { (document, error) in
            if let error = error {
                print("ERROR", error.localizedDescription)
            } else {
                if (document?.exists)! {
                    let data = document?.data()
                    let key = document?.documentID
                    let circle = Circle(key: key!, data: data!, users: nil)
                    self.circles.append(circle)
                    self.adapter.performUpdates(animated: false)
                }
            }
        }
    }
    
    
    func getInsidersByOrder() {
        self.users = []
        let circleId  = self.circleId ?? UserDefaults.standard.value(forKey: "circleId") as! String
        Firestore.firestore().collection("circles").document(circleId).collection("insiders").whereField("payed", isEqualTo: false).order(by: "position", descending: false).limit(to: 3).addSnapshotListener { (document, error) in
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
            }
        }
    }
    
    func getCircleActivities() {
        self.events = []
        let circleId  = self.circleId ?? UserDefaults.standard.value(forKey: "circleId") as! String
        Firestore.firestore().collection("circles").document(circleId).collection("events").addSnapshotListener { (document, error) in
            if let error = error {
                print("ERROR", error.localizedDescription)
            } else {
                
                for document in (document?.documents)! {
                    if document.exists {
                        let data = document.data()
                        let key = document.documentID
                        let event = Event(key: key, data: data)
                        self.events.append(event)
                        self.adapter.performUpdates(animated: false)
                    }
                }
            }
        }
    }
}

extension CircleInsightView {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = circles as [ListDiffable]
        data += users as [ListDiffable]
        data += header as [ListDiffable]
        data += events as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if object is Circle {
           return CircleInsightSection()
        } else if object is User {
            return NextPayoutSection()
        } else if object is String {
            return HeaderSection()
        } else {
            return CircleEventsSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
    



