//
//  IntroView.swift
//  Circle
//
//  Created by Kerby Jean on 2/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class IntroView: UIView {
    
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
        self.backgroundColor = UIColor.white
        headline.frame = CGRect(x: 0, y: 20, width: self.frame.width, height: 50)
        headline.textColor = UIColor.darkText
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 20, width: self.frame.width, height: 50)
        self.addSubview(headline)
        self.addSubview(subhead)
    }
    
    
    
    func setText(_ headline: String, _ subhead: String) {
        self.headline.text = headline
        self.subhead.text = subhead
    }
}
