//
//  StackView.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit


extension UIStackView {
    
    func addBackgroundView(_ color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.borderWidth = 0.5
        subView.layer.cornerRadius = 5
        subView.layer.borderColor = UIColor.lightGray.cgColor
        self.insertSubview(subView, at: 0)
    }
    
}
