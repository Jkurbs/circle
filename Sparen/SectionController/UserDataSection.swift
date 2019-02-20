//
//  UserDataSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/8/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import IGListKit

class UserDataSection: ListSectionController {
    
    private var activity: UserActivities?
    
    override func sizeForItem(at index: Int) -> CGSize {
        if index == 0 {
            return CGSize(width: collectionContext!.containerSize.width, height: 100)
        } else {
            return CGSize(width: collectionContext!.containerSize.width, height: 90)
        }
    }
    
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: SelectedUserCell.self, for: self, at: index) as? SelectedUserCell else {
                fatalError()
            }
            cell.configure(user!)
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: SelectedUserDataCell.self, for: self, at: index) as? SelectedUserDataCell else {
                fatalError()
            }
            cell.configure(user!)
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}
