//
//  PendingVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class PendingVC: UIViewController {
    
    // Views
    let contentView = ContentView()
    var settingsView: SettingsView!
    var welcomeView: WelcomeView!
    var insightView = InsightView()
    let userView: UserView = UIView.fromNib()

    var loadingView = LoadingView()
    var circleView = CircleView()
    var circleButton = UIButton()
    
    // Cells
    var selectedIndex: IndexPath?
    var users = [User?]()
    var cell: EmbeddedCollectionViewCell!
    
    var userViewIsShow: Bool = false
    
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }()
    
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 10 , left: 0, bottom: 0, right: 0)
        view.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        view.alwaysBounceHorizontal = false
        view.allowsSelection = false
        return view
    }()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        //UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource  = self
        tableView.register(InsightCell.self, forCellReuseIdentifier: "InsightCell")

        
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

        // welcome View
        welcomeView = WelcomeView(frame: CGRect(x: 0, y: 45, width: contentView.frame.width, height: height))
        
        // insight View
        self.insightView.frame = CGRect(x: 0, y: 45, width: contentView.frame.width, height:  height)
        tableView.frame = CGRect(x: 0, y: 60 , width: insightView.frame.width - 50, height:  insightView.frame.height - 60)
        tableView.center.x = insightView.center.x
        insightView.addSubview(tableView)
        
        // add userView
        userView.frame = CGRect(x: 0, y: 60, width: userView.frame.width, height:  200)
        //userView.isHidden = true
        self.view.addSubview(userView)
        
        collectionView.frame = CGRect(x: 0, y: welcomeView.bounds.height + 20, width: welcomeView.frame.width, height: 300)

        circleView.frame = CGRect(x: 0, y: welcomeView.bounds.height + 20, width: welcomeView.frame.width - 130, height: 300)
        circleView.center.x = collectionView.center.x
        contentView.insertSubview(circleView, at: 0)
        
        loadingView.frame = collectionView.frame

        circleButton.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        circleButton.layer.position = CGPoint(x: collectionView.frame.width / 2, y: collectionView.frame.height / 2)
        circleButton.cornerRadius = circleButton.frame.width / 2
        circleButton.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        collectionView.addSubview(circleButton)
        circleButton.addTarget(self, action: #selector(circleButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func circleButtonTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            self.circleButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.contentView.addSubview(self.insightView)
        }, completion: { (completion) in
            self.circleButton.transform = CGAffineTransform.identity
        })
    }
    
    
    var circleId = ""
    
    func retrieveUser() {
        users = []
        self.view.addSubview(loadingView)
        DataService.instance.retrieveCircle({ (success, error, circle, insider) in
                if !success { 
                    print("ERRROR RETRIVING CIRCLE")
                } else {
                    self.users.append(insider)
                    self.collectionView.insertItems(at: [IndexPath(row: self.users.count - 1, section: 0 )])
                    self.tableView.reloadData()
                    if circle?.activated == true {
                        dispatch.async {
                            self.contentView.addSubview(self.userView)
                        }
                    } else {
                        dispatch.async {
                            //self.contentView.addSubview(self.welcomeView)
                        }
                    }
                self.loadingView.removeFromSuperview()
            }
        })
    }
}





// MARK: COLLECTIONVIEW DELEGATE, DATASOURCE

extension PendingVC: UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCell", for: indexPath) as! InsightCell
        let user = users[indexPath.row]
        cell.configure(user!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? InsightCell {
//
//        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    
    
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

        if (userViewIsShow) {
            userViewIsShow = false
        } else {
            //First Tap
            userViewIsShow = true
            contentView.addSubview(userView)
            userView.isHidden = false
        }
        
        let user = self.users[indexPath.row]

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
                    dispatch.async {
                        self.userView.configure(user)
                    }
                })
            indicesArray.append(indexPath)
        }
    }
    
    @objc func logOut() {
        
        UserDefaults.standard.removeObject(forKey: "userId")
        
        //Defaults.remove(.key_uid)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DispatchQueue.main.async {
                let controller = PhoneViewController()
                let nav = UINavigationController(rootViewController: controller)
                self.present(nav, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("SIGNOUT ERROR:\(signOutError)")
        }
        
//        let vc = SettingsVC()
//        let nav = UINavigationController(rootViewController: vc)
//        self.navigationController?.pushViewController(vc, animated: true)

    }
}












