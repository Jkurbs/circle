//
//  CircleSectionController.swift
//  Circle
//
//  Created by Kerby Jean on 11/8/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit

class SectionController: ListSectionController, ListAdapterDataSource {

    var circle: Circle?
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 0)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width
        let height = collectionContext?.containerSize.height
        if index == 0 {
            return CGSize(width: width!, height: 45)
        } else {
            return CGSize(width: width!, height: height! - 45)
        }
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
       if index == 0 {
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleInfoCell.self, for: self, at: index) as? CircleInfoCell else {
                fatalError()
            }
            cell.configure(nextPayout: "\(circle?.maxAmount)")
            return cell

       } else {
            let cell = collectionContext!.dequeueReusableCell(of: EmbeddedCollectionViewCell.self , for: self, at: index)
            if let cell = cell as? EmbeddedCollectionViewCell {
                adapter.collectionView = cell.collectionView
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        circle = object as? Circle
    }
}

extension SectionController {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (circle?.insiders)!
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CircleSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


