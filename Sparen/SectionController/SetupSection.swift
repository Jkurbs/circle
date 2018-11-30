//
//  SetupSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit
import FirebaseAuth


class SetupSection: ListSectionController {
    
    private var member: Int?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SetupCell.self, for: self, at: index) as? SetupCell else {
            fatalError()
        }
        
        cell.configure(member!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        member = object as? Int
    }
}

