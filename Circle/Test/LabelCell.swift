//
//  LabelCell.swift
//  Circle
//
//  Created by Kerby Jean on 3/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

final class StoryboardCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        self.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let width = self.frame.width
        
        label.frame = CGRect(x: width - (width * 0.1) - 15, y: 10, width: width, height: 40)
        label.center.x = self.center.x
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
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
