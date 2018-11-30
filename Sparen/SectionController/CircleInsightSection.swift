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
    
    private var insight: Insight?
    
    override func sizeForItem(at index: Int) -> CGSize {
       if index == 0 || index == 3 {
          return CGSize(width: collectionContext!.containerSize.width, height: 50)
       }
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override init() {
        super.init()

    }
    
    override func numberOfItems() -> Int {
        return 3
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as? HeaderCell else {
                fatalError()
            }
            cell.configure("Round \(insight!.round ?? 0)")
            return cell
        }
        
        if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: CircleInsightCell.self , for: self, at: index) as? CircleInsightCell else {
                fatalError()
            }
            cell.configure(insight!)
            return cell
        } else  {
            let cell = collectionContext!.dequeueReusableCell(of: AmountsCell.self , for: self, at: index)
            if let cell = cell as? AmountsCell {
                cell.configure(insight!)
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.insight = object as? Insight
    }
}
