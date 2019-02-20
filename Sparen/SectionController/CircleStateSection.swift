//
//  CircleStateSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit

class CircleStateSection: ListSectionController {
    
    private var insight: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width - 20, height: collectionContext!.containerSize.height - 200)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
    }
    
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleStateCell.self, for: self, at: index) as? CircleStateCell else {
            fatalError()
        }
        
        cell.viewController = self.viewController
        return cell
    }
    
    override func didUpdate(to object: Any) {
        insight = object as? String
    }
}
