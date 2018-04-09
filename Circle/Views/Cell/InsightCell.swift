//
//  InsightCell.swift
//  Circle
//
//  Created by Kerby Jean on 2/6/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class InsightCell: UICollectionViewCell {

    var amountLabel = UILabel()
    var amountDescLabel = UILabel()
    var timeLabel = UILabel()
    var descTimeLabel = UILabel()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .textFieldBackgroundColor
        
        contentView.addSubview(amountLabel)
        amountLabel.textAlignment = .center
        amountLabel.textColor = UIColor.darkText
        amountLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        contentView.addSubview(amountDescLabel)
        amountDescLabel.text = "Amount"
        amountDescLabel.textAlignment = .center
        amountDescLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func layoutSubviews() {
        
        let width = self.frame.width
        
        amountLabel.frame = CGRect(x: 10, y: 6, width: 40, height: 20)
        amountLabel.sizeToFit()
        
        amountDescLabel.frame = CGRect(x: 10, y: timeLabel.frame.maxY + 20, width: 20, height: 20)
        amountDescLabel.sizeToFit()
    }
    
    
    
    func configure(_ insight: Balance) {
       //amountLabel.text = insight.amount
        
   }
}

