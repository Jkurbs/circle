//
//  WelcomeVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    var circleId: String?
    
    let subhead                 = Subhead()
    let footnote                = Footnote()
    
    var loadingView = LoadingView()
    
    var users = [User]()
    
    
    var headline = Headline()
    var button = UIButton()
    

    
    @objc func notificationAccess() {
        //AuthService.instance.appDel.userNotification()
        
        DispatchQueue.main.async {
            let vc = ContactInfoVC()
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        }
        if let circleId = UserDefaults.standard.string(forKey: "circleId") {
            //            if circleId != nil {
            //                DispatchQueue.main.async {
            //                    let vc = PhoneVCTwo()
            //                    let navigationController = UINavigationController(rootViewController: vc)
            //                    self.present(navigationController, animated: true, completion: nil)
            //                }
            //            } else {
            //            }
        }
    }
    
    
    
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        retrieve()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PendingInviteCell.self, forCellWithReuseIdentifier: "PendingInviteCell")
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 25
        let width: CGFloat = self.view.bounds.width - (padding * 2)  - 20
        let y: CGFloat = 40
        let centerX = view.center.x

        subhead.frame = CGRect(x: 0, y: y + 30 , width: width, height: 60)
        subhead.center.x = centerX

        collectionView.frame = CGRect(x: 0, y: subhead.layer.position.y + 110, width: view.frame.width, height: 300)
        
        loadingView.frame = collectionView.frame
        
        
        button = UIButton(frame: CGRect(x: 0, y: collectionView.layer.position.y + 200, width: 200, height: 50))
        button.center.x = centerX
        button.setTitleColor(view.tintColor, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("Let's go!", for: .normal)
        button.addTarget(self, action: #selector(notificationAccess), for: .touchUpInside)

    }
    
    func setup() {
         view.addSubview(subhead)
         view.addSubview(collectionView)
    }
    
    
    func retrieve() {
        view.addSubview(loadingView)
        DataService.instance.retrieveDynamicLinkCircle(circleId!){ (success, error, admin, insider)  in
            if !success {
               self.loadingView.removeFromSuperview()
            } else {
                if let admin = admin {
                    self.subhead.text = "Start earning and saving money with \(admin.firstName ?? "") \(admin.lastName ?? "") and others on Circle"
                    self.loadingView.removeFromSuperview()
                }
                self.users.append(insider!)
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: [IndexPath(row: self.users.count - 1, section: 0 )])
                    UserDefaults.standard.set(self.circleId, forKey: "circleId")
                    self.view.addSubview(self.button)
                })
            }
        }
    }
}


extension WelcomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
}


