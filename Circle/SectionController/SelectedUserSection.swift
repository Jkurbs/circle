//
//  SelectedUserSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class SelectedUserSection: ListSectionController {
    
    private var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override init() {
        super.init()
        
        
    }

    override func numberOfItems() -> Int {
        return 1
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        print("USERRR::", user?.lastName)
        guard let cell = collectionContext?.dequeueReusableCell(of: SelectedUserCell.self, for: self, at: index) as? SelectedUserCell else {
            fatalError()
        }
        cell.configure(user: user!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}

