////
////  PaymentSection.swift
////  Sparen
////
////  Created by Kerby Jean on 9/22/18.
////  Copyright © 2018 Kerby Jean. All rights reserved.
////
//
//import IGListKit
//
//
//class PaymentSection: ListSectionController {
//    
//    private var card: Card?
//    
//    override func sizeForItem(at index: Int) -> CGSize {
//        return CGSize(width: collectionContext!.containerSize.width, height: 90)
//    }
//    
//    override init() {
//        super.init()
//        
//        
//    }
//    
//    
//    override func numberOfItems() -> Int {
//        return 1
//    }
//    
//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        guard let cell = collectionContext?.dequeueReusableCell(of: CurrentPaymentCell.self, for: self, at: index) as? CurrentPaymentCell else {
//            fatalError()
//        }
//        
//        cell.configure(card!)
//        return cell
//    }
//    
//    override func didUpdate(to object: Any) {
//        card = object as? Card
//    }
//}
