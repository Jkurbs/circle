//
//  ReadySectionController.swift
//  Sparen
//
//  Created by Kerby Jean on 8/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class ReadySectionController: ListSectionController {
    
    
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
        let cell = collectionContext?.dequeueReusableCell(of: ReadyCell.self, for: self, at: index) as! ReadyCell
        cell.configure(circle!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.circle = object as? Circle
    }
}
