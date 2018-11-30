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
        label.backgroundColor = .backgroundColor
        label.textAlignment = .center
        label.numberOfLines = 5
        label.text = "Tap the search button to find a Circle to join \n or create your own with the + button."
        return label
    }()
    
    var searchButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var removeButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Init the static view
        initView()
    }
    
    
    func initView() {
        self.title = "Dashboard"
        self.view.backgroundColor = .white
        
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        removeButton = UIBarButtonItem(image: UIImage(named: "Remove-20"), style: .done, target: self, action: #selector(leave))

        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu-filled-20"), style: .plain, target: self, action:  #selector(settings))
            
        navigationItem.leftBarButtonItems = [searchButton, addButton]
        navigationItem.rightBarButtonItem = settingsButton
        
        collectionView.backgroundColor = .backgroundColor 
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("VIEW WILL APPEAR")
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        fetchUser()
        fetchCircle()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    private func fetchUser() {
        DataService.call.fetchCurrentUser { (success, error, user) in
            self.user.removeAll()
            if !success {
                print("error:", error!.localizedDescription)
            } else {
                self.user.removeAll()
                self.user.append(user)
                self.adapter.reloadData(completion: nil)
            }
        }
    }
    
    
    private func fetchCircle() {

        print("fetch circle")
        guard let circleId = UserDefaults.standard.string(forKey: "circleId") ?? circleId else {return}
        print("CIRCLE ID::", circleId)
        if !circleId.isEmpty {
            self.emptyLabel.removeFromSuperview()
           self.navigationItem.leftBarButtonItems  = [removeButton]
            DataService.call.fetchCurrentUserCircle(circleId) { (success, error, circle) in
                self.circles.removeAll()
                if !success {
                    print("error:", error?.localizedDescription ?? "")
                } else {
                    
                    print("NOT EMPTY")
                    
                    self.circles.append(circle)
                    
                    if circle.activated == true {
                         self.navigationItem.leftBarButtonItems = []
                        self.insights = ["1"]
                        self.pending = []
                    } else {
                        self.insights = []
                        self.pending = [1]
                    }
                    self.adapter.reloadData(completion: { (done) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getCircle"), object: nil, userInfo: ["circle": circle])
                    })
                }
            }
        } else {
            self.navigationItem.leftBarButtonItems  = [searchButton, addButton]
            self.collectionView.addSubview(emptyLabel)
        }
    }
    
    
    @objc func leave() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to leave the Circle?", preferredStyle: .actionSheet)
        let leave = UIAlertAction(title: "Leave", style: .destructive) { (action) in
            
            guard let circle = self.circles[0] as? Circle else { return }
                DataService.call.leaveCircle(circle) { (success, error) in
                    if !success {
                        print("error:", error!.localizedDescription)
                    } else {
                        self.circles.removeAll()
                        self.pending.removeAll()
                        self.adapter.reloadData(completion: { (done) in
                        self.adapter.performUpdates(animated: true, completion: nil)
                        self.collectionView.addSubview(self.emptyLabel)
                        self.navigationItem.leftBarButtonItems  = [self.searchButton, self.addButton]
                    })
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(leave)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

    deinit {
        
        DataService.call.RefCircles.removeObserver(withHandle: DataService.call.circleHandle)
        DataService.call.RefUsers.removeObserver(withHandle: DataService.call.circleMembersHandle)
        
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









