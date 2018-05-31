//
//  CircleInsightSection.swift
//  Circle
//
//  Created by Kerby Jean on 5/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class CircleInsightSection: ListSectionController {
    
    private var circle: Circle?
    
    override func sizeForItem(at index: Int) -> CGSize {

        if index == 2 {
            return CGSize(width: collectionContext!.containerSize.width, height: 60)
        }
        
        return CGSize(width: collectionContext!.containerSize.width, height: 90)
    }
    
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        return 3
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: CircleInsightCell.self , for: self, at: index) as? CircleInsightCell else {
                fatalError()
            }
            cell.configure(circle!)
            return cell
        } else if index == 1 {
            let cell = collectionContext!.dequeueReusableCell(of: AmountsCell.self , for: self, at: index)
            if let cell = cell as? AmountsCell {
                cell.configure(circle!)
            }
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: NextPayoutHeaderCell.self, for: self, at: index) as? NextPayoutHeaderCell else {
                fatalError()
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        circle = object as? Circle
    }
}
