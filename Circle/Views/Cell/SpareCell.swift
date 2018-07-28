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
    var slider = UISlider()
    var moneyLabel: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        label = UICreator.create.label(nil, 20, .darkerGray, .left, .semibold, contentView)
        moneyLabel = UICreator.create.label(nil, 13, .darkerGray, .center, .semibold, contentView)
        contentView.addSubview(slider)
        slider.maximumValue = 5000
        slider.minimumValue = 1000
        slider.tintColor = UIColor(white: 0.5, alpha: 1.0)
        slider.addTarget(self, action: #selector(slide(_:)), for: .valueChanged)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constrain(label, slider, moneyLabel, contentView) { label, slider, moneyLabel, view in
            label.top == view.top + 50
            label.left == view.left + 20
            label.right == view.right - 20
            label.height == 60
            slider.top == label.bottom + 10
            slider.leading == label.leading
            slider.trailing == view.trailing - 20
            moneyLabel.top == label.bottom + 10
            moneyLabel.left == slider.right + 10
            moneyLabel.right == slider.right + 70
            moneyLabel.centerY == slider.centerY
        }
    }
    
    
    @objc func slide(_ slider: UISlider) {
        UIView.animate(withDuration: 0.5) {
            constrain(self.slider, self.moneyLabel, self.contentView) {slider, moneyLabel, view in
                slider.trailing == view.trailing - 100
                moneyLabel.top == slider.top
                moneyLabel.left == slider.right + 10
                moneyLabel.right == slider.right + 70
                moneyLabel.centerY == slider.centerY
            }
        }
        
        
        
        
        moneyLabel.text = "$\(Int(slider.value))"
    }
    
    
    func configure(_ user: User) {
        label.text = "\(user.firstName ?? ""), how much money would you like to spare?"
    }
}

