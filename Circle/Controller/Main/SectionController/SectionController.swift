////
////  CircleSectionController.swift
////  Circle
////
////  Created by Kerby Jean on 11/8/17.
////  Copyright © 2017 Kerby Jean. All rights reserved.
////
//
//
//import UIKit
//import IGListKit
//
//final class SectionController: ListSectionController {
//
//    private var circle: Circle?
//    private var insider: User?
//    
//    
//    override init() {
//        super.init()
//        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    
//    
//    override func sizeForItem(at index: Int) -> CGSize {
//        let width = collectionContext?.containerSize.width
//        let height = collectionContext?.containerSize.height
//        return CGSize(width: width!, height: height! - 45)
//    }
//    
//    override func numberOfItems() -> Int {
//        return 1
//    }
//    
//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        guard let cell = collectionContext?.dequeueReusableCell(of: CircleCell.self, for: self, at: index) as? CircleCell else {
//            fatalError()
//        }
//        cell.configure(insider)
//        return cell
//    }
//    
//    override func didUpdate(to object: Any) {
//        insider = object as? User
//    }
//    
////    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
////        return insiders as [ListDiffable]
////    }
////
////    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
////        return CircleSectionController()
////    }
////
////    func emptyView(for listAdapter: ListAdapter) -> UIView? {
////        return nil
////    }
//}
//
//
//
