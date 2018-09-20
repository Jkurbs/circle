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
    var activities = [UserActivities]()
    var circles = [Circle]()
    var insights = ["1"]
    var circle: Circle?

    lazy var viewModel: UserActivitiesViewModel = {
        return UserActivitiesViewModel()
    }()
    
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.frame = collectionView.frame
        label.textColor = .darkText
        label.text = "You don't belong in a Circle yet :(. You can seach or create your own!"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Init the static view
        initView()
    }
    
    
    func initView() {
        self.title = "Dashboard"
        self.view.backgroundColor = .white
        
        let seachButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu-filled-20"), style: .plain, target: self, action:  #selector(settings))
            
        navigationItem.leftBarButtonItems = [seachButton, addButton]
        navigationItem.rightBarButtonItem = settingsButton
        
        collectionView.backgroundColor = .backgroundColor 
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        fetchUser()
        fetchUserActivities()
        fetchCircle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //DataService.call.circleListener?.remove()
        DataService.call.userListener?.remove()
        DataService.call.listener?.remove()
        self.user = []
        self.circles = []
        self.activities = []
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    private func fetchUser() {
        self.user = []
        DataService.call.fetchCurrentUser { (success, user, error) in
            if !success {
                print("error:", error?.localizedDescription ?? "")
            } else {
                self.user.append(user)
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    private func fetchUserActivities() {
        guard let circleId = UserDefaults.standard.string(forKey: "circleId") ?? circleId else {return}
        if !circleId.isEmpty {
            viewModel.fetchUserActivities(circleId, Auth.auth().currentUser!.uid)
        }
    }
    
    
    private func fetchCircle() {
        self.circles = []
        guard let circleId = UserDefaults.standard.string(forKey: "circleId") ?? circleId else {return}
        if !circleId.isEmpty {
            DataService.call.fetchCurrentUserCircle(circleId: circleId) { (success, error, circles) in
                if !success {
                    print("error:", error?.localizedDescription ?? "")
                } else {
                    guard let circles = circles else {return}
                    self.circles = circles
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getCircle"), object: nil, userInfo: ["circle": circles[0]])
                    self.adapter.reloadData(completion: nil)
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "pushNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getCircle"), object: nil)
    }
}

extension DashboardVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = user as [ListDiffable]
        data += viewModel.activities as [ListDiffable]
        data += circles as [ListDiffable]
        data += insights as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is User {
           return DashboardSection()
        } else if object is UserActivities {
            return UserActivitySection()
        } else if object is Circle {
            return UpperSection()
        } else {
            return CircleStateSection()
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func settings() {
        let vc = SettingsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}







