////
////  UserDataSection.swift
////  Sparen
////
////  Created by Kerby Jean on 9/8/18.
////  Copyright © 2018 Kerby Jean. All rights reserved.
////
//
//
//import IGListKit
//import FirebaseAuth
//
//class UserActivitySection: ListSectionController {
//    
//    private var activity: UserActivities?
//    
//    override func sizeForItem(at index: Int) -> CGSize {
//        return CGSize(width: collectionContext!.containerSize.width, height: 60)
//    }
//    
//    
//    override init() {
//        super.init()
//        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUser(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
//        
//    }
//    
//    
//    @objc func updateUser(_ notification: NSNotification) {
//        if let dict = notification.userInfo as NSDictionary? {
//            if let user = dict["user"] as? User {
//                if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? SelectedUserDataCell {
//                cell.daysLabel.text = "\(user.daysLeft ?? 0)"
//                getUsersActivities(user)
//                    
//                }
//            }
//        }
//    }
//    
//    
//    override func numberOfItems() -> Int {
//        return 1
//    }
//    
//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        guard let cell = collectionContext?.dequeueReusableCell(of: SelectedUserDataCell.self, for: self, at: index) as? SelectedUserDataCell else {
//            fatalError()
//            
//        }
//        cell.configure(activity!)
//        return cell
//    }
//    
//    override func didUpdate(to object: Any) {
//        activity = object as? UserActivities
//    }
//    
//    func getUsersActivities(_ user: User) {
//        guard let circleId = user.circle, let userId = user.userId else {return}
//        
//        DataService.call.fetchUserActivities(circleId, userId) { (success, error, userActivities) in
//            if !success {
//                print("error:", error!.localizedDescription)
//            } else {
//                let data: [String: Any] = ["userActivities": userActivities]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userActivities"), object: nil, userInfo: data)
//            }
//        }
//    }
//}
