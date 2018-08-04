//
//  Footnote.swift
//  Circle
//
//  Created by Kerby Jean on 1/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit

class Footnote: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        self.numberOfLines = 3
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        self.textAlignment = .center
    }
}
