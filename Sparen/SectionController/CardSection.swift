
//  CardSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.



import IGListKit

class CardSection: ListSectionController {
    
    private var card: Card?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 90)
    }
    
    override init() {
        super.init()
        
        print("CARD:" , card?.imageUrl)
        
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: SettingPaymentCell.self, for: self, at: index) as? SettingPaymentCell else {
                fatalError()
        }
        cell.configure(card!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        card = object as? Card
    }
}


class AddCardSection: ListSectionController {
    
    private var add: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 90)
    }
    
    override init() {
        super.init()
        
        print("ADD CARD")
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: AddCardCell.self, for: self, at: index) as? AddCardCell else {
            fatalError()
        }
        
        cell.configure(add!)
        
        print("CELL::", cell.button.titleLabel?.text)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        add = object as? String
    }
}
