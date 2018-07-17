//
//  UpperSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import Lottie

class UpperSection: ListSectionController, ListAdapterDataSource {
    
    private var user: User?
    private var admin: String!
    private var users = [User]()
    private var nextPayoutUsers = [User]()
    private var circle = [Circle]()
    private var insight = [Insight]()
    private var setup = ["1"]
    private var finish = [1]
    private var circleLink: String!
    private var cell: CircleCollectionViewCell!
    private var settingsCell: SettingsCell!
    

    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 0)
        adapter.dataSource = self
        return adapter
    }()
    
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    

    let animation: LOTAnimationView = {
        var view = LOTAnimationView()
        view.backgroundColor = .red
        view = LOTAnimationView(name: "firework")
        view.loopAnimation = true
        view.play()
        return view
    }()
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width =  collectionContext!.containerSize.width
        let height = collectionContext!.containerSize.height
        
        let userHeight = height/8
        let colHeight = (height/2) - (userHeight + 40)
        print(colHeight)

        switch index {
        case 0:
            return CGSize(width: width, height: 40)
        case 1:
            return CGSize(width: width, height: userHeight)
        case 2:
            return CGSize(width: width, height: colHeight + 100)
        case 3:
            return CGSize(width: width, height: colHeight)
        default:
            return CGSize(width: width, height: 100)
        }
    }
    
    
    override init() {
        super.init()
        finish = []
        //self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        retrieveUsers()
        retrieveCircle()
        retrieveInsight()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUser(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    
    
    @objc func updateUser(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let user = dict["user"] as? User {
                if let cell = collectionContext?.cellForItem(at: 1, sectionController: self) as? SelectedUserCell, let settingsCell = collectionContext?.cellForItem(at: 0, sectionController: self) as? SettingsCell  {
                    cell.configure(user)
                    settingsCell.configure(user, user.firstName!)
                }
            }
        }
    }


    override func numberOfItems() -> Int {
        return 4
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: SettingsCell.self, for: self, at: index) as? SettingsCell else {
                fatalError()
            }
            cell.configure(user!, user!.firstName ?? user!.userName!)
            self.settingsCell = cell
            return cell
        } else if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: SelectedUserCell.self, for: self, at: index) as? SelectedUserCell else {
                fatalError()
            }
            cell.configure(user!)
            return cell
        } else if index == 2 {
            guard let cell = collectionContext?.dequeueReusableCell(of: CircleCollectionViewCell.self, for: self, at: index) as? CircleCollectionViewCell else {
                fatalError()
            }
            self.cell = cell
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else {
                fatalError()
            }
            adapter.collectionView = cell.collectionView
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}

extension UpperSection {
    
    func retrieveUsers() {
        viewModel.initFetch()
    }
    

    func retrievePayoutUsers() {
        DataService.call.fetchPayoutUsers { (success, user, error) in
            if !success {
                print("error:", error!.localizedDescription)
            } else {
                self.nextPayoutUsers.append(user!)
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    private func retrieveCircle() {
        self.circle = []
        let circleId  = UserDefaults.standard.string(forKey: "circleId") ?? ""
        DataService.call.REF_CIRCLES.document(circleId).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.exists {
                let key = snapshot.documentID
                let data = snapshot.data()
                let circle = Circle(key: key, data: data!)
                self.settingsCell.circleLink = circle.link!
                if self.user!.userId == circle.adminId && !circle.activated! {
                    self.settingsCell.addSubview(self.settingsCell.inviteButton)
                } else if circle.activated == true {
                    self.settingsCell.inviteButton.removeFromSuperview()
                }
                self.circle.append(circle)
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    private func retrieveInsight() {
        let circleId  = UserDefaults.standard.string(forKey: "circleId") ?? ""
        let ref = DataService.call.REF_CIRCLES.document(circleId).collection("insight")
        ref.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if diff.document.exists {
                    switch diff.type {
                        case .added:
                            let key = diff.document.documentID
                            let data = diff.document.data()
                            let insight = Insight(key: key, data: data)
                            self.insight.append(insight)
                            self.cell.configure(insight)
                            self.adapter.performUpdates(animated: true)
                            self.retrievePayoutUsers()
                            print("New user: \(diff.document.data())")
                            self.setup = []
                        case .modified:
                            if !self.insight.isEmpty {
                                self.insight = []
                                let key = diff.document.documentID
                                let data = diff.document.data()
                                let insight = Insight(key: key, data: data)
                                self.cell.configure(insight)
                                self.insight.append(insight)
                                self.adapter.reloadData(completion: nil)
                                print("INSIGHT:", diff.document.data())
                            }
                        case .removed:
                        //self.insight = []
                        self.nextPayoutUsers = []
                        self.setup = []
                        self.finish = [1]
                        self.insight.remove(at: 0)
                        self.adapter.performUpdates(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = insight as [ListDiffable]
        data += nextPayoutUsers as [ListDiffable]
        data += setup as [ListDiffable]
        data += finish as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Insight {
           return CircleInsightSection()
        } else if object is User {
           return NextPayoutSection()
        } else if object is String {
           return SetupCircleSection()
        } else {
           return FinishCircleSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

