//
//  CircleInsightSection.swift
//  Circle
//
//  Created by Kerby Jean on 5/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import Lottie

class CircleInsightSection: ListSectionController {
    
    private var insight: Insight?
    private var animation: LOTAnimationView!
    
    override func sizeForItem(at index: Int) -> CGSize {
       if index == 0 || index == 3 {
          return CGSize(width: collectionContext!.containerSize.width, height: 50)
       }
        return CGSize(width: collectionContext!.containerSize.width, height: 90)
    }
    
    override init() {
        super.init()

    }
    
    override func numberOfItems() -> Int {
        return 4
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as? HeaderCell else {
                fatalError()
            }
            cell.configure("Circle")
            return cell
        }
        
        if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: CircleInsightCell.self , for: self, at: index) as? CircleInsightCell else {
                fatalError()
            }
            cell.configure(insight!)
            return cell
        } else if index == 2 {
            let cell = collectionContext!.dequeueReusableCell(of: AmountsCell.self , for: self, at: index)
            if let cell = cell as? AmountsCell {
                cell.configure(insight!)
            }
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: NextPayoutHeaderCell.self, for: self, at: index) as? NextPayoutHeaderCell else {
                fatalError()
            }
            cell.configure("Next Payouts")
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.insight = object as? Insight
    }
}
