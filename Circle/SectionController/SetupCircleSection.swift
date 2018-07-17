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
    
    private var user: User?
    
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
        
            guard let cell = collectionContext?.dequeueReusableCell(of: MonthlyAmoutCell.self, for: self, at: index) as? MonthlyAmoutCell else {
                fatalError()
            }
            cell.configure("Activate your circle")
            return cell
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
    
    override func didSelectItem(at index: Int) {
        
    }
}


