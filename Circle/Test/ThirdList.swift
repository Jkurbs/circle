//
//  ThirdList.swift
//  Circle
//
//  Created by Kerby Jean on 3/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class ThirdList: ListSectionController {
    
    private var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 45)
    }
    
    
    override init() {
        super.init()
        
        print("USER FIRST NAME;:", user?.firstName)
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        let cell = collectionContext!.dequeueReusableCell(of: CircleCollectionViewCell.self , for: self, at: index)
        if let cell = cell as? CircleCollectionViewCell {
            //adapter.collectionView = cell.collectionView
        }
        return cell 
        
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
}


