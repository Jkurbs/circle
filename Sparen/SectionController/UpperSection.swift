//
//  UpperSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth

class UpperSection: ListSectionController {

    private var circle: Circle?
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width =  collectionContext!.containerSize.width
        let height = collectionContext!.containerSize.height - 200
        return CGSize(width: width, height: height/2)
    }
    
    
    override init() {
        super.init()
    }


    override func numberOfItems() -> Int {
        return 1
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: CircleCollectionViewCell.self, for: self, at: index) as? CircleCollectionViewCell else {
            fatalError()
        }
        
        cell.circle = circle
        return cell
    }

    
    override func didUpdate(to object: Any) {
           circle = object as? Circle
        }
    }

