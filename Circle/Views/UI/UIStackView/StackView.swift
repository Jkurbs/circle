//
//  StackView.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit


class StackView: UIStackView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.axis = .horizontal
        self.spacing = 0
        self.distribution = .equalSpacing
        self.alignment = .center
    }
}
