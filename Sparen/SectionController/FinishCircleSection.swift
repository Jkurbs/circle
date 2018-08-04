//
//  FinishCircleSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/21/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class FinishCircleSection: ListSectionController {
    
    private var finish: Int?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    override func numberOfItems() -> Int {
        return 1
    }

    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: FinishMessageCell.self, for: self, at: index) as?  FinishMessageCell else {
            fatalError()
        }
        cell.configure()
        return cell
        
    }
    
    override func didUpdate(to object: Any) {
        finish = object as? Int
    }
}


