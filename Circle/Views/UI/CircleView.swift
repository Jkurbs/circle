//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

//
//  CircleView.swift
//  Circle
//
//  Created by Kerby Jean on 2/18/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import HGCircularSlider

class CircleView: CircularSlider  {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        

        
        self.thumbRadius = 0.0
        self.trackFillColor = UIColor(red: 243.0/255.0, green:  156.0/255.0, blue:  18.0/255.0, alpha: 1.0)
        self.endThumbStrokeColor = UIColor(white: 0.7, alpha: 1.0)
        self.lineWidth = 6.0
        self.trackColor = UIColor(white: 0.8, alpha: 1.0)
        self.backtrackLineWidth = 4.0
        self.diskFillColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.diskColor =  UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }
}

