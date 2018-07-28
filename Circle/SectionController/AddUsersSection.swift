//
//  AddUsersSection.swift
//  Sparen
//
//  Created by Kerby Jean on 7/26/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit


class AddUsersSection: ListSectionController {
    
    var circle: Circle?
    var users = [User]() 
    
    override func sizeForItem(at index: Int) -> CGSize {
        if index == 0 {
            return CGSize(width:  collectionContext!.containerSize.width, height: 200)

        } else {
            return CGSize(width:  collectionContext!.containerSize.width, height: 60)
        }
    }
    
    override init() {
        super.init()
        retrieveInsiders()
    }
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: AddUsersCell.self, for: self, at: index) as? AddUsersCell else {
                fatalError()
            }
            cell.configure(circle!)
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: InsidersHeaderCell.self, for: self, at: index) as? InsidersHeaderCell else {
                fatalError()
            }
            return cell
        }
    }
    
    
    func retrieveInsiders() {
        DataService.call.fetchUsers { (success, users, error) in
            if !success {
                
            } else {
                if !users!.isEmpty {
                    if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? AddUsersCell, let secCell = self.collectionContext?.cellForItem(at: 1, sectionController: self) as? InsidersHeaderCell {
                        cell.label.text = "Invite more people"
                        secCell.label.text = "Insiders"
                    }
                }
            }
        }
    }
    
    override func didUpdate(to object: Any) {
        self.circle = object as? Circle
    }
}
