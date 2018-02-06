//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import HGCircularSlider

class CircleView: CircularSlider  {
    

    func setup() {
        
        self.thumbRadius = 0.0
        self.endThumbStrokeColor = UIColor(white: 0.7, alpha: 1.0)
        self.lineWidth = 4.0
        self.endPointValue = 0.4
        self.trackColor = UIColor(white: 0.8, alpha: 1.0)
        self.backtrackLineWidth = 4.0
        self.diskFillColor = UIColor(red: 52, green: 128, blue: 219, alpha: 1.0)
        self.diskColor = .white
        self.backgroundColor = .white
    }    
}
