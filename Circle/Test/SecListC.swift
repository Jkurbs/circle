////
////  SecListC.swift
////  Circle
////
////  Created by Kerby Jean on 3/12/18.
////  Copyright © 2018 Kerby Jean. All rights reserved.
////
//
//import UIKit
//import IGListKit
//
//class SecListC: ListSectionController {
//    
//    private var user: User?
//    let FirstList = FirstListC()
//    
//    lazy var collectionView: UICollectionView = {
//        let layout = CircleLayout()
//        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.backgroundColor = .clear
//        return view
//    }()
//    
//    override func sizeForItem(at index: Int) -> CGSize {
//        let width = collectionContext!.containerSize.width
//        if index == 0 {
//            return CGSize(width: width, height: 45)
//        }
//        return CGSize(width: width, height: width)
//    }
//    
//    
//    override init() {
//        super.init()
//        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//        self.viewController?.view.addSubview(collectionView)
//        collectionView.frame = CGRect(x: 0, y: 250, width: (collectionContext?.containerSize.width)!, height:  (collectionContext?.containerSize.width)!)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(PendingInviteCell.self, forCellWithReuseIdentifier: "PendingInviteCell")
//        collectionView.reloadData()
//    }
//
//    
//    override func numberOfItems() -> Int {
//        return 1
//    }
//    
//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        guard let cell = collectionContext?.dequeueReusableCell(of: EventCell.self, for: self, at: index) as? EventCell else {
//            fatalError()
//        }
//        cell.text = user?.firstName
//        return cell
//    }
//    
//    override func didSelectItem(at index: Int) {
//        
//    }
//    
//    override func didUpdate(to object: Any) {
//        self.user = object as? User
//    }
//}
//
//
//
//extension SecListC: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return FirstList.insider.count
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PendingInviteCell", for: indexPath) as! PendingInviteCell
//        let user = FirstList.insider[indexPath.row]
//        cell.configure(user)
//        return cell
//    }
//
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////
////            if (userViewIsShow) {
////                userViewIsShow = false
////            } else {
////                //First Tap
////                userViewIsShow = true
////                contentView.addSubview(dashboardView)
////                dashboardView.isHidden = false
////            }
////
////            let user = self.users[indexPath.row]
////
////            if(selectedIndex != indexPath) {
////                var indicesArray = [IndexPath]()
////                if(selectedIndex != nil) {
////
////                    let cell = collectionView.cellForItem(at: selectedIndex!) as! PendingInviteCell
////                    UIView.animate(withDuration: 0.3, animations: {
////                        cell.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
////                        cell.transform = CGAffineTransform.identity
////                    }, completion: { (completion) in
////                    })
////                    indicesArray.append(selectedIndex!)
////                }
////
////                selectedIndex = indexPath
////                let cell = collectionView.cellForItem(at: indexPath) as! PendingInviteCell
////
////                UIView.animate(withDuration: 0.3, animations: {
////                    cell.layer.borderColor = UIColor.blueColor.cgColor
////                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
////                }, completion: { (completion) in
////                    dispatch.async {
////                        if user?.userId != Auth.auth().currentUser!.uid {
////                            self.dashboardView.configure(user)
////                        } else {
////                            print("CURRENT USER")
////                        }
////                    }
////             })
////                indicesArray.append(indexPath)
////        }
////    }
//}
//
