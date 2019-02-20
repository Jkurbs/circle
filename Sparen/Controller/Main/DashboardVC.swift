//
//  DashboardVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/3/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IGListKit

class DashboardVC: UIViewController, ListAdapterDataSource {
    
    var circleId: String?
    var user = [User]()
    var circles = [Circle]()
    var insights: [String] = ["1"]
    var pending: [Int] = [1]
    var circle: Circle?
    
    var users = [User]()
    
    var notificationButton: SSBadgeButton!


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
        label.text = "Tap the search button to find a Circle to join \n or create your own with the + button."
        return label
    }()
    
    
    var searchButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(leave(_:)), name: .leave, object: nil)
        
        if currentReachabilityStatus == .notReachable {self.present(ErrorHandler.show.internetError(), animated: true, completion: nil)} //true connected
        
        self.view.backgroundColor = .backgroundColor
        
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))

        navigationItem.leftBarButtonItems = [addButton]
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false

        initView()
        fetchUser()
        initFetch()
        fetchCircle()

        
        notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: -40, right: 0)
        notificationButton.setImage(UIImage(named: "icons8-menu-filled-25")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.addTarget(self, action: #selector(news), for: .touchUpInside)
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu-filled-20"), style: .plain, target: self, action:  #selector(settings))
        
        let newsButton = UIBarButtonItem(customView: notificationButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        navigationItem.rightBarButtonItems = [settingsButton, newsButton]
        
        observeForNews()
        
//        initFetch()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func news() {
        let vc = NewsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @objc func initFetch() {
        
        self.users = []
        
        if let string = UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
            
            var key: String!
            
            DataService.call.RefCircleMembers.child(string).observe( .value) { (snapshot) in
                
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    key = rest.key
                    
                    DataService.call.RefUsers.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let value = snapshot.value, let postDict = value as? [String : AnyObject] else {return}
                        let key = snapshot.key
                        let user = User(key: key, data: postDict)
                        self.users.append(user)
                        NotificationCenter.default.post(name: .fetchUsers, object: nil, userInfo: ["users": self.users])
                    })
                }
            }
        }
    }
    
    
    // MARK: User
    
    private func fetchUser() {
        self.user.removeAll()
        DataService.call.fetchCurrentUser { (success, error, user) in
            if !success {
                print("error:", error!.localizedDescription)
            } else {
                self.user.append(user)
                let firstName = self.user[0].firstName
                self.title = firstName
                self.adapter.reloadData(completion: nil)
            }
        }
    }

    
    // MARK: Circle
    
    private func fetchCircle() {
        self.circles.removeAll()
        if let string = circleId ?? UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
            self.emptyLabel.removeFromSuperview()
            self.navigationItem.leftBarButtonItems  = []
            DataService.call.fetchCurrentUserCircle(string) { (success, error, circle) in
                self.circles.removeAll()
                if !success {
                    print("error:", error?.localizedDescription ?? "")
                } else {
                    self.circles.append(circle)
                    if circle.activated == true {
                        self.notificationButton.badge = "1"
                        self.navigationItem.leftBarButtonItems = []
                        self.insights = ["1"]
                        self.pending = []
                    } else {
                        self.notificationButton.badge = nil
                        self.insights = []
                        self.pending = [1]
                    }
                    self.adapter.reloadData(completion: { (done) in
                        NotificationCenter.default.post(name: .pulse, object: nil, userInfo: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getCircle"), object: nil, userInfo: ["circle": circle])
                    })
                }
            }
        } else {
            self.navigationItem.leftBarButtonItems = [addButton]
//            self.collectionView.addSubview(emptyLabel)
        }
    }
    
    
    // MARK: News
    
    func observeForNews() {
        
//        if let string = UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
//            DataService.call.RefBase.child("requests").child(string).child(Auth.auth().currentUser!.uid).queryOrdered(byChild: "seen").queryEqual(toValue: false).observe(.value) { (snapshot) in
//                
//                if snapshot.exists() {
//                    self.notificationButton.badge = "1"
//                } else {
//                    self.notificationButton.badge = nil
//                }
//            }
//        }
    }

    
    @objc func leave(_ notification: Notification) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to leave the Circle?", preferredStyle: .actionSheet)
        let leave = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            let circle = self.circles[0]
            let position = self.user[0].position
            DataService.call.leaveCircle(circle, position!) { (success, error) in
                if !success {
                    print("error:", error!.localizedDescription)
                } else {
                    self.circles.removeAll()
                    self.pending.removeAll()
                    self.adapter.reloadData(completion: { (done) in
                        self.adapter.performUpdates(animated: true, completion: nil)
                        self.collectionView.addSubview(self.emptyLabel)
                        self.navigationItem.leftBarButtonItems  = [self.searchButton, self.addButton]
                        UserDefaults.standard.removeObject(forKey: "circleId")
                    })
                }
            }

            
//            NotificationCenter.default.post(name: .userLeft, object: nil, userInfo: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(leave)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

    deinit {
        
        NotificationCenter.default.removeObserver(self)

//        DataService.call.RefCircles.removeObserver(withHandle: DataService.call.circleHandle)
//        DataService.call.RefUsers.removeObserver(withHandle: DataService.call.circleMembersHandle)

        NotificationCenter.default.removeObserver(self, name: .fetchUsers, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "pushNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getCircle"), object: nil)
    }
}

extension DashboardVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = user as [ListDiffable]
        data += circles as [ListDiffable]
        data += insights as [ListDiffable]
        data += pending as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is User {
           return DashboardSection()
        } else if object is Circle {
            return UpperSection()
        } else if object is String {
            return CircleStateSection()
        } else {
            return PendingSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension DashboardVC {
    
    @objc func search() {
        let vc = FindCircleVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func add() {
        let vc = CreateCircleVC()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func settings() {
        let vc = SettingsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}









