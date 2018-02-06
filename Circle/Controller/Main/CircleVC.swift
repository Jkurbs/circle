//
//  PendingInsidersVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit

    //    lazy var loginVC = LoginViewController()
    //    var nextDescriptionLabel: UILabel!
    //    var nextLabel: UILabel!
    //    var descriptionLabel: UILabel!
    //    var timeLabel: UILabel!
    //    var addButton: UIButton!
    //

final class PendingInsidersVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var contacts = [Contact]()

    var collectionView: UICollectionView!
    var circle = CircleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
    func setup() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: CircleLayout())
        collectionView.delegate = self
        collectionView.register(ContactsInviteCell.self, forCellWithReuseIdentifier: "ContactsInviteCell")
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        circle.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height)
        let shortestAxisLength = min(collectionView.bounds.width, collectionView.bounds.height)
        circle.radius = shortestAxisLength * 0.4
        self.view.insertSubview(circle, at: 0)
    }
    

    
   // update collection view if size changes (e.g. rotate device)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView?.performBatchUpdates(nil)
        })
    }
//
//
//    func setCircle()  {
//        DataService.instance.retrieveUser{ (success, error, user) in
//            if !success {
//                print("ERROR RETRIEVING CIRCLE", error.debugDescription)
//            } else {
//                DataService.instance.retrieveCircle(user?.circleId) { (success, error, circle, users)  in
//                    if !success {
//                        print("ERROR SETUP CIRCLE: \(String(describing: error?.localizedDescription))")
//                    } else {
//                        self.insiders.append(user!)
//                        if self.insiders.count == 0 {
//                            DispatchQueue.main.async {
//                                self.collectionView.reloadData()
//                            }
//                        } else {
//                            self.collectionView.insertItems(at: [IndexPath(item: self.insiders.count - 1, section: 0)])
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//    func setupViews() {
//
//        // ADD CIRCLE
//        collectionView.delegate = self
//        collectionView.backgroundColor = .clear
//        collectionView.dataSource = self
//        collectionView.collectionViewLayout = CircleLayout()
////
////        addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
////        addButton.center = CGPoint(x: circle.bounds.midX, y: circle.bounds.midY)
////        addButton.layer.cornerRadius = addButton.frame.height / 2
////        addButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
////        addButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
////        addButton.setImage(#imageLiteral(resourceName: "Add-24"), for: .normal)
////        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
////        collectionView.insertSubview(addButton, at: 1)
//    }
//
//    @objc func add() {
//
//    }
//}
//
//
//// MARK: UICollectionViewDataSource
//extension CircleVC {
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return contacts.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactsInviteCell", for: indexPath) as! ContactsInviteCell
        let contact = contacts[indexPath.row]
        cell.configure(contact)
        return cell
    }

}






