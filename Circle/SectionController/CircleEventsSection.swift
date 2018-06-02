 //
//  CircleEventsSection.swift
//  Circle
//
//  Created by Kerby Jean on 5/31/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

 import UIKit
 import IGListKit
 
 class CircleEventsSection: ListSectionController {
    
    private var event: Event?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }

    
    
    override init() {
        super.init()
        
    }
    
//    override func numberOfItems() -> Int {
//        
//    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleEventsCell.self, for: self, at: index) as? CircleEventsCell else {
            fatalError()
        }
        cell.configure(event!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        event = object as? Event
    }
 }
 
