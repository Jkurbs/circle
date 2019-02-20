

//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 2/18/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class CircleView: CircularSlider  {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        test()
    }

    func test()  {
        self.maximumValue = 0
        self.endPointValue = 0
        self.thumbRadius = 0.0
        self.trackFillColor = UIColor.sparenColor
        self.endThumbStrokeColor = UIColor.sparenColor
        self.lineWidth = 6.5
        self.trackColor = UIColor(white: 0.9, alpha: 1.0)
        self.backtrackLineWidth = 4.5
        self.diskFillColor = UIColor.clear
        self.diskColor =  UIColor.clear
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

