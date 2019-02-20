//
//  PendingSection.swift
//  Sparen
//
//  Created by Kerby Jean on 11/6/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit

class PendingSection: ListSectionController {
    
    private var pending: Int?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width - 20
        let height = (collectionContext!.containerSize.height/3)
        return CGSize(width: width, height: height)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCircle(_:)), name: NSNotification.Name(rawValue: "getCircle"), object: nil)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: PendingCell.self, for: self, at: index) as? PendingCell else {
            fatalError()
        }
        cell.viewController = self.viewController
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pending = object as? Int
    }

    @objc private func getCircle(_ notification: NSNotification) {
        if let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? PendingCell {
            
            if let dict = notification.userInfo as NSDictionary? {
                if let circle = dict["circle"] as? Circle {
                    cell.circle = circle
                }
            }
        }
    }
}
