//
//  SpinningCircle.swift
//  Circle
//
//  Created by Kerby Jean on 5/3/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class SpinningView: UIView {
    
    let circleLayer = CAShapeLayer()
    var animating: Bool = true

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        circleLayer.lineWidth = 2.5
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor(red: 0.8078, green: 0.2549, blue: 0.2392, alpha: 1.0).cgColor
        layer.addSublayer(circleLayer)
        updateAnimation()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth/2
        
        let startAngle = CGFloat(-Double.pi)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.position = center
        circleLayer.path = path.cgPath
    }
    
    
    func updateAnimation() {
        print("ANIMATE")
        if animating == true {
            layer.add(strokeEndAnimation, forKey: "strokeEnd")
            layer.add(strokeStartAnimation, forKey: "strokeStart")
        } else {
            layer.removeAnimation(forKey: "strokeEnd")
            layer.removeAnimation(forKey: "strokeStart")
        }
    }
    
    let strokeEndAnimation: CAAnimation = {
        print("PRINT END")
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
}
