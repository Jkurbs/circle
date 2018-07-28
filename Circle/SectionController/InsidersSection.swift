//
//  InsidersSection.swift
//  Sparen
//
//  Created by Kerby Jean on 7/28/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit

class InsidersSection: ListSectionController {
    
    var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override init() {
        super.init()
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {

        guard let cell = collectionContext?.dequeueReusableCell(of: InsidersCell.self, for: self, at: index) as? InsidersCell else {
            fatalError()
        }
        cell.configure(user!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
}
