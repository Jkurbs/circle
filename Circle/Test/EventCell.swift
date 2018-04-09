//
//  EventCell.swift
//  Circle
//
//  Created by Kerby Jean on 3/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //contentView.backgroundColor = .red 
        
        let width = self.frame.width
        
        label.frame = CGRect(x: width - (width * 0.1) - 15, y: 10, width: width, height: 40)
        label.center.x = self.center.x
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
    }
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
}
