//
//  CircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class CircleVC: UIViewController {
    
    // Views
    let contentView = ContentView()
    var settingsView: SettingsView!
    var welcomeView: IntroView!
    let circleInsightView: CircleInsightView = UIView.fromNib()
    let currentUserView: CurrentUserView = UIView.fromNib()
    let userViews: UserDashboardView = UIView.fromNib()


    var loadingView = LoadingView()
    var circleView = CircleView()
    var circleButton = UIButton()
    
    // Cells
    var selectedIndex: IndexPath?
    var users = [User?]()
    var cell: EmbeddedCollectionViewCell!
    
    var userViewIsShow: Bool = false
    
    var circleId: String?
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        collectionView.register(PendingInviteCell.self, forCellWithReuseIdentifier: "PendingInviteCell")
        
        view.addSubview(contentView)
        collectionView.delegate = self
        collectionView.dataSource = self
        retrieveUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height: CGFloat = 280
        
        contentView.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height)
        
        // add settingsView
        settingsView = SettingsView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: 45))
        settingsView.settingbutton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        contentView.addSubview(settingsView)

        welcomeView = IntroView(frame: CGRect(x: 0, y: 45, width: contentView.frame.width, height: height))
        welcomeView.headline.text = "Welcome to your Circle dashboard"
        welcomeView.subhead.text = "You'll receive an notification when an invitation has been accepted"
        
        
        circleInsightView.frame = CGRect(x: 0, y: view.bounds.height - (self.circleInsightView.frame.height + 20), width: view.frame.width, height: self.circleInsightView.frame.height)
        self.contentView.addSubview(circleInsightView)
        
        // Add userView
        userViews.frame = CGRect(x: 0, y: 45, width: userViews.frame.width, height:  userViews.frame.height)
        userViews.alpha = 0.0
        self.contentView.addSubview(userViews)
        
        currentUserView.frame = CGRect(x: 0, y: 45, width: currentUserView.frame.width, height: currentUserView.frame.height)
        currentUserView.alpha = 1.0
        self.contentView.addSubview(currentUserView)
        
        collectionView.frame = CGRect(x: 0, y: welcomeView.bounds.height + 5, width: welcomeView.frame.width, height: 290)
        
        circleView.frame = CGRect(x: 0, y: welcomeView.bounds.height + 5, width: welcomeView.frame.width - 130, height: 290)
        circleView.center.x = collectionView.center.x
        contentView.insertSubview(circleView, at: 0)
        
        loadingView.frame = collectionView.frame

//        circleButton.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
//        circleButton.layer.position = CGPoint(x: collectionView.frame.width / 2, y: collectionView.frame.height / 2)
//        circleButton.cornerRadius = circleButton.frame.width / 2
//        circleButton.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
//        collectionView.addSubview(circleButton)
    }
    
    
   
    
    
    func retrieveUser() {
        users = []
        self.view.addSubview(loadingView)
        let circleId  = self.circleId ?? UserDefaults.standard.value(forKey: "circleId") as! String
        DataService.instance.retrieveCircle(circleId){ (success, error, circle, insider) in
            if !success {
                    print("ERRROR RETRIVING CIRCLE", error!.localizedDescription)
            } else {
                
                self.circleInsightView.totalAmountSlider.setValue(Float(circle?.maxAmount ?? 0), animated: true)
                self.circleInsightView.amountLabel.text = "\(circle?.maxAmount ?? 0)"
                self.users.append(insider)
                self.collectionView.insertItems(at: [IndexPath(row: self.users.count - 1, section: 0 )])

                self.circleInsightView.circle = circle 
                if circle?.activated == true {
                self.circleInsightView.setupButton.isEnabled = true
                    dispatch.async {
                        //self.circleInsightView
                           // self.contentView.addSubview(self.currentUserView)
                        }
                    } else {
                self.circleInsightView.setupButton.isEnabled = false
                        dispatch.async {
                           // self.contentView.addSubview(self.welcomeView)
                        }
                    }
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    
    @objc func logOut() {
        UserDefaults.standard.removeObject(forKey: "userId")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DispatchQueue.main.async {
                let controller = LoginVC()
                let nav = UINavigationController(rootViewController: controller)
                self.present(nav, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("SIGNOUT ERROR:\(signOutError)")
        }
    }
}


// MARK: COLLECTIONVIEW DELEGATE, DATASOURCE

extension CircleVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PendingInviteCell", for: indexPath) as! PendingInviteCell
        let user = self.users[indexPath.row]
        cell.configure(user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let user = self.users[indexPath.row]
//
//        if (self.userViewIsShow) {
//            //self.contentView.addSubview(self.currentUserView)
//
//        } else {
//
//        }
        
        if(selectedIndex != indexPath) {
            var indicesArray = [IndexPath]()
            if(selectedIndex != nil) {
                
                let cell = collectionView.cellForItem(at: selectedIndex!) as! PendingInviteCell
                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
                    cell.transform = CGAffineTransform.identity
                }, completion: { (completion) in
                })
                indicesArray.append(selectedIndex!)
            }
            
            selectedIndex = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as! PendingInviteCell

                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.borderColor = UIColor.blueColor.cgColor
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    
                }, completion: { (completion) in
                    switch user!.userId {
                    case Auth.auth().currentUser!.uid?:
                        self.userViews.alpha = 0.0
                        self.userViews.isHidden = true
                        self.currentUserView.alpha = 1.0
                        self.currentUserView.isHidden = false
                        self.settingsView.configure("Your dashboard")
                        //self.hideViews(hideViews: [ self.userViews], showView: self.currentUserView)
                    default:
                        self.currentUserView.alpha = 0.0
                        self.currentUserView.isHidden = true
                         self.userViews.alpha = 1.0
                        self.userViews.isHidden = false
                       // self.hideViews(hideViews: [self.currentUserView], showView: self.userViews)
                        //self.userViews.user = user
                        self.userViews.configure(user)
                        self.settingsView.configure(user!.firstName!)
                    }
                })
            indicesArray.append(indexPath)
        }
    }
    
    func hideViews(hideViews: [UIView], showView: UIView) {
        for view in hideViews {
            view.alpha = 0.0
            view.isHidden = true
        }
        showView.alpha = 1.0
        showView.isHidden = false
    }
}










