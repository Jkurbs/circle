//
//  InsightSection.swift
//  Circle
//
//  Created by Kerby Jean on 3/28/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit


class InsightSection: ListSectionController {
    
    private var insigth: Balance?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 60)
    }
    
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: InsightCell.self, for: self, at: index) as! InsightCell
        cell.configure(insigth!)
        
        return cell
    }
    
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func didUpdate(to object: Any) {
        self.insigth = object as? Balance
    }
    
}
