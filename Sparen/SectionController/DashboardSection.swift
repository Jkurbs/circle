//
//  DashboardSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit
import FirebaseAuth

class DashboardSection: ListSectionController {
    
    private var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 170)
    }
    
    
    override init() {
        super.init()
        self.minimumLineSpacing = 0.0
        self.inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUser(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
    }
    
    
    
    @objc func updateUser(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let user = dict["user"] as? User {
                if let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? SelectedUserCell {
                    cell.configure(user)

                    if user.userId == Auth.auth().currentUser?.uid {
                        self.viewController?.title = "Dashboard"
                    } else {
                        self.viewController?.title = user.firstName
                    }
                }
            }
        }
    }
    
    
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SelectedUserCell.self, for: self, at: index) as? SelectedUserCell else {
            fatalError()
        }
        cell.configure(user!)
        return cell
    }

    override func didUpdate(to object: Any) {
        user = object as? User
    }

}
