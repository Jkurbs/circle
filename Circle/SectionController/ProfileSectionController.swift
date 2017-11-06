//
//  ProfileSectionController.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import SceneKit
import IGListKit

class ProfileSectionController: ListSectionController {
    
    var user: User?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 200)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ArtCell.self, for: self, at: index) as? ArtCell else {
            fatalError()
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}

