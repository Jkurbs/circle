//
//  ContentView.swift
//  Circle
//
//  Created by Kerby Jean on 2/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ContentView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup() {
        self.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.cornerRadius = 10
        self.clipsToBounds = true
    }
}
