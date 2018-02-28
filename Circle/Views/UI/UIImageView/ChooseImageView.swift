//
//  ChooseImageView.swift
//  Circle
//
//  Created by Kerby Jean on 2/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ChooseImageView: UIImageView {

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        self.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.textFieldBackgroundColor
    }
}
