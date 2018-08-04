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
    
    private var link: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        if index == 0 {
            return CGSize(width: collectionContext!.containerSize.width, height: 40)
        }
        return CGSize(width: collectionContext!.containerSize.width, height: 150)
    }

    override init() {
        super.init()
        
    }
    
    
    override func didUpdate(to object: Any) {
        link = object as? String
    }
    
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: NextPayoutHeaderCell.self, for: self, at: index) as? NextPayoutHeaderCell else {
                fatalError()
            }
            cell.configure("Invite trusted ones")
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: InviteCell.self, for: self, at: index) as? InviteCell else {
                fatalError()
            }            
            cell.codeLabel.text = link
            return cell
        }
    }
}

