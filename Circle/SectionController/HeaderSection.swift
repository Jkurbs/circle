//
//  HeaderSection.swift
//  Circle
//
//  Created by Kerby Jean on 5/31/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class HeaderSection: ListSectionController {
    
    private var header: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }

    override init() {
        super.init()
        
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: NextPayoutHeaderCell.self, for: self, at: index) as? NextPayoutHeaderCell else {
            fatalError()
        }
        cell.configure("Recents")
        return cell
    }
    
    override func didUpdate(to object: Any) {
        header = object as? String
    }
}

