//
//  SetupCircleSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class SetupCircleSection: ListSectionController {
    
    private var circle: Circle?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height)
    }
    
    override init() {
        super.init()
        
    }

    override func numberOfItems() -> Int {
        return 1
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleStateCell.self, for: self, at: index) as? CircleStateCell else {
            fatalError()
        }
        //cell.configure("Activate your circle:", circle!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        circle = object as? Circle
    }
    
    
    override func didSelectItem(at index: Int) {
        
    }
}


