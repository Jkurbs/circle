//
//  SetupSection.swift
//  Sparen
//
//  Created by Kerby Jean on 9/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit
import FirebaseAuth


class SetupSection: ListSectionController {
    
    private var member: Int?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = collectionContext!.containerSize.height
        let width = collectionContext!.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: height - 60)
        } else {
            return CGSize(width: width, height: 60)
        }
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: SetupCell.self, for: self, at: index) as? SetupCell else {
                fatalError()
            }
            cell.configure(member!)
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: OptionCell.self, for: self, at: index) as? OptionCell else {
                fatalError()
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        member = object as? Int
    }
}

