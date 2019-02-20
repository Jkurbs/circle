//
//  AmountsCell.swift
//  Circle
//
//  Created by Kerby Jean on 5/30/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit


postfix operator %

postfix func % (percentage: Double) -> Double {
    return (percentage / 100)
}

class AmountsCell: UICollectionViewCell {
    
    var weeklyAmountLabel = UILabel()
    var totalAmountLabel = UILabel()
    
    var weeklyDescLabel =  UILabel()
    var totalDescLabel = UILabel()
    
    
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
        
        
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        let descColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        weeklyAmountLabel.textColor = color
        totalAmountLabel.textColor = color
        
        weeklyAmountLabel.font = font
        totalAmountLabel.font = font
        
        weeklyAmountLabel.frame = CGRect(x: 20, y: 5, width: width / 3, height: 25)
        weeklyDescLabel.frame = CGRect(x: 20, y: weeklyAmountLabel.frame.maxY, width: width / 3 , height: 20)
        weeklyDescLabel.font = font
        weeklyDescLabel.textColor = descColor
        
        weeklyDescLabel.text = "Weekly"
        
        totalAmountLabel.frame = CGRect(x: self.frame.maxX - 150, y: 5, width: width / 3, height: 25)
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
        
        let weeklyAmount =  insight.weeklyAmount!
        let totalAmount = insight.totalAmount!
        self.weeklyAmountLabel.text = "\(weeklyAmount.rounded()) $"
        self.totalAmountLabel.text = "\(totalAmount.rounded()) $"
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
        label.textAlignment = .center
        label.font = font
        label.frame = CGRect(x: 0, y: 0, width: width , height: self.frame.height)
    }
    
    
    func configure(_ text: String) {
        label.text = text
    }
}

class NextPayoutHeaderCell: UICollectionViewCell {
    
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


