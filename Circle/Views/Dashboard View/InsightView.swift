//
//  InsightView.swift
//  Circle
//
//  Created by Kerby Jean on 2/19/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class InsightView: UIView {
    
    var amountDescLabel = UILabel()
    var amountLabel = UILabel()
    
    var endDescLabel = UILabel()
    var endLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
       
        amountDescLabel.text = "Next Payout"
        amountLabel.text = "3000$"
        self.addSubview(amountDescLabel)
        self.addSubview(amountLabel)
        
        endDescLabel.text = "Circle End"
        endLabel.text = "30 days"
        endDescLabel.textAlignment = .left
        endLabel.textAlignment = .left
        self.addSubview(endDescLabel)
        self.addSubview(endLabel)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        
        amountDescLabel.frame = CGRect(x: 50, y: 10, width: 40, height: 40)
        amountDescLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        amountDescLabel.sizeToFit()
        
        amountLabel.frame = CGRect(x: 50, y: amountDescLabel.layer.position.y + 10, width: 40, height: 40)
        amountLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        amountLabel.sizeToFit()
        
        endDescLabel.frame = CGRect(x: width - (width * 0.1) - 100, y: 10, width: 40, height: 40)
        endDescLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        endDescLabel.sizeToFit()
        
        endLabel.frame = CGRect(x: width - (width * 0.1) - 100, y: endDescLabel.layer.position.y + 10, width: 40, height: 40)
        endLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        endLabel.sizeToFit()
    }
}













