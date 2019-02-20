//
//  FindCircleSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit

class FindCircleSection: ListSectionController {

    private var circle: Circle?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override init() {
        super.init()

        self.inset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
//    
//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        let cell = collectionContext?.dequeueReusableCell(of: FindCircleCell.self, for: self, at: index) as! FindCircleCell
//        cell.circle = circle
//        return cell
//    }
    
    override func didUpdate(to object: Any) {
        self.circle = object as? Circle
    }
}
