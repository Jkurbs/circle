//
//  SettingsView.swift
//  Circle
//
//  Created by Kerby Jean on 2/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsView: UIView {
    
    var settingbutton = UIButton()
    
    let label = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.yellow.cgColor,
            UIColor.brown.cgColor
        ]
        return layer
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
     }
    
    func setup() {

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        gradientLayer.frame = self.bounds
        //        self.layer.addSublayer(gradientLayer)
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkText
        label.textAlignment = .center
        self.addSubview(label)
        
        self.backgroundColor = .white
            //UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        settingbutton.frame = CGRect(x: 3, y: 3, width: 45, height: 45)
        settingbutton.setImage(#imageLiteral(resourceName: "Settings-20"), for: .normal)
        self.addSubview(settingbutton)
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
        self.layer.addSublayer(separator)
    }
    
    
    func configure(_ userName: String) {
        label.text = ""
        label.text = userName
    }
    
}
