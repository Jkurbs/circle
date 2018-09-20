//
//  AmountsCell.swift
//  Circle
//
//  Created by Kerby Jean on 5/30/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class AmountsCell: UICollectionViewCell {
    
    var weeklyAmountLabel = transformLabel()
    var totalAmountLabel = transformLabel()
    
    var weeklyDescLabel =  transformLabel()
    var totalDescLabel = transformLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubview(weeklyAmountLabel)
        contentView.addSubview(totalAmountLabel)
        contentView.addSubview(weeklyDescLabel)
        contentView.addSubview(totalDescLabel)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        let descColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        weeklyAmountLabel.textColor = color
        totalAmountLabel.textColor = color
        
        weeklyAmountLabel.font = font
        totalAmountLabel.font = font
        
        weeklyAmountLabel.frame = CGRect(x: 20, y: 5, width: width / 3, height: 40)
        weeklyDescLabel.frame = CGRect(x: 20, y: weeklyAmountLabel.frame.maxY, width: width / 3 , height: 20)
        weeklyDescLabel.font = font
        weeklyDescLabel.textColor = descColor
        
        weeklyDescLabel.text = "Weekly"
        
        totalAmountLabel.frame = CGRect(x: self.frame.maxX - 150, y: 5, width: width / 3, height: 40)
        totalDescLabel.frame = CGRect(x: self.frame.maxX - 150, y: totalAmountLabel.frame.maxY, width: width / 3 , height: 20)
        totalDescLabel.font = font
        totalDescLabel.text = "Total"
        totalDescLabel.textColor = descColor
        
        totalAmountLabel.textAlignment = .center
        totalDescLabel.textAlignment = .center
        weeklyAmountLabel.textAlignment = .center
        weeklyDescLabel.textAlignment = .center
    }
    
    
    func configure(_ insight: Insight) {
        let weeklyAmount = insight.weeklyAmount ?? 0
        let totalAmount = insight.totalAmount ?? 0
        self.weeklyAmountLabel.text = "\(weeklyAmount) $"
        self.totalAmountLabel.text = "\(totalAmount) $"
    }
}

class HeaderCell: UICollectionViewCell {
    
    var label = UILabel()    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(label)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        
        let font = UIFont.systemFont(ofSize: 18, weight: .medium)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        label.textColor = color
        label.font = font
        label.frame = CGRect(x: 25, y: 5, width: width , height: 40)
            
    }
    
    
    func configure(_ text: String) {
        label.text = text
    }
    
}

class NextPayoutHeaderCell: UICollectionViewCell {
    
    var label = transformLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubview(label)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        label.textColor = color
        label.font = font
        label.frame = CGRect(x: 25, y: 5, width: width , height: 40)
    }
    
    func configure(_ text: String) {
        label.text = text
    }
}



