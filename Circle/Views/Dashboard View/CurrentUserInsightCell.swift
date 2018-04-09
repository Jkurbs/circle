//
//  CurrentUserInsightCell.swift
//  Circle
//
//  Created by Kerby Jean on 3/28/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class CurrentUserInsightCell : UICollectionViewCell {
    
    var balanceLabel = UILabel()
    var balDesc = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        contentView.addSubview(balanceLabel)
        contentView.addSubview(balDesc)
        contentView.layer.addSublayer(separator)
        
        balanceLabel.textColor = .darkText
        balanceLabel.numberOfLines = 1
        balanceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        balanceLabel.textAlignment = .center
        
        balDesc.textColor = .darkText
        balDesc.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        balDesc.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        balanceLabel.frame = CGRect(x: 10, y: 5, width: 60, height: 40)

        let width = self.frame.width - 60
        balDesc.frame = CGRect(x: 10, y: balDesc.frame.maxY + 5, width: width, height: 40)
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
    
    func configure(_ event: Balance) {
    
    }
}
