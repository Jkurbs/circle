//
//  ReadyCell.swift
//  Sparen
//
//  Created by Kerby Jean on 8/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography

class ReadyCell: UICollectionViewCell {

    var label: UILabel!
    var getReadyView: UIView!
    var insightView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .red
        
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure( _ circle: Circle) {

        
    }
}
