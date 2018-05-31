//
//  AmountsSection.swift
//  Circle
//
//  Created by Kerby Jean on 5/30/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit

class AmountsSection: ListSectionController {
    
    private var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    
    override init() {
        super.init()
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: NextPayoutCell.self, for: self, at: index) as? NextPayoutCell else {
            fatalError()
        }
        cell.configure(user!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}
