//
//  OptionButton.swift
//  Circle
//
//  Created by Kerby Jean on 2/21/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class OptionButton: UIButton {
    
    var optionButton = UIButton()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        let color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.layer.cornerRadius = 50/2
        self.backgroundColor = color
    }
}







