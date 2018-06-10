//
//  DragCell.swift
//  Circle
//
//  Created by Kerby Jean on 5/31/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit


class DragCell: UICollectionViewCell {
    
    var view = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        view.frame = CGRect(x: 0 , y: 5, width: 30, height: 5)
        view.center.x = self.center.x
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.cornerRadius = 2.5
        
    }
}


