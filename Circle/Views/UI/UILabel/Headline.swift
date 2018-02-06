//
//  Headline.swift
//  Circle
//
//  Created by Kerby Jean on 1/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class Headline: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        self.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        self.textAlignment = .center
        self.textColor = .darkText
        self.numberOfLines = 3
    }
}
