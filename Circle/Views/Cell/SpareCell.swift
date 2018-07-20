//
//  SpareCell.swift
//  Sparen
//
//  Created by Kerby Jean on 7/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class SpareCell: UICollectionViewCell {
    
    var label: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        label = UICreator.create.label(nil, 20, .darkerGray, .center, .semibold, contentView)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constrain(label, contentView) { label, view in
            label.left == view.left + 60
            label.height == 60
        }
    }
    
    func configure(_ user: User) {
        label.text = "\(user.firstName ?? ""), how much money \n would you like to spare?"
    }
}
