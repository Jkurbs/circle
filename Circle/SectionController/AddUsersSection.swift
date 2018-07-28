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
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width:  collectionContext!.containerSize.width, height: collectionContext!.containerSize.height)
    }
    
    override init() {
        super.init()
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AddUsersCell.self, for: self, at: index) as? AddUsersCell else {
            fatalError()
        }
        cell.configure(circle!)
        return cell
    }
    
    
    func retrieveInsiders() {
        
    }
    
    override func didUpdate(to object: Any) {
        self.circle = object as? Circle
    }

}
