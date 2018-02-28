//
//  WelcomeView.swift
//  Circle
//
//  Created by Kerby Jean on 2/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    let headline = Headline()
    let subhead = Subhead()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true 
        self.backgroundColor = UIColor.textFieldBackgroundColor
       // self.cornerRadius = 10
        headline.frame = CGRect(x: 0, y: 20, width: self.frame.width, height: 50)
        headline.textColor = UIColor.darkText
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 20, width: self.frame.width, height: 50)
        headline.text = "Welcome to your Circle dashboard"
        subhead.text = "You'll receive an notification when an invitation has been accepted"
        self.addSubview(headline)
        self.addSubview(subhead)
    }
}
