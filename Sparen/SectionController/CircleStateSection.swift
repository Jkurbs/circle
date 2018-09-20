//
//  CircleStateSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit

class CircleStateSection: ListSectionController {
    
    private var insight: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height)
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCircle(_:)), name: NSNotification.Name(rawValue: "getCircle"), object: nil)
    }
    
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleStateCell.self, for: self, at: index) as? CircleStateCell else {
            fatalError()
        }
        cell.viewController = self.viewController
        return cell
    }
    
    override func didUpdate(to object: Any) {
        insight = object as? String
    }
    
    
    private func fetchCircleActivities(_ circleId: String) {
            if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? CircleStateCell {
                DataService.call.fetchCircleActivities(circleId) { (success, error, insight) in
                    if !success {
                        print("error:", error?.localizedDescription ?? "")
                    } else {
                    cell.insight = insight
                    let data: [String: Any] = ["insight": insight!]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pulseNotification"), object: nil, userInfo: data)
                }
            }
        }
    }
    
    @objc private func getCircle(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let circle = dict["circle"] as? Circle {
                let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as! CircleStateCell
                cell.circle = circle
                fetchCircleActivities(circle.id!)
            }
        }
    }
}











