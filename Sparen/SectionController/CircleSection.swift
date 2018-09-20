//
//  CircleSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit
import Hero

class CircleSection: ListSectionController {
    
    private var circle: Circle?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.width)
    }
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleCollectionViewCell.self, for: self, at: index) as? CircleCollectionViewCell else {
            fatalError()
        }
        
        
        cell.circle = circle
        return cell
    }
    
    override func didUpdate(to object: Any) {
        circle = object as? Circle
    }
//
//    override func didSelectItem(at index: Int) {
//        let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as! UserCircleCell
//        cell.badge.removeFromSuperview()
//        let vc = CircleVC()
//        vc.circleId = circle?.id
//        self.viewController?.navigationController?.pushViewController(vc, animated: true)
//    }
}
