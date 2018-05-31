//
//  Transform.swift
//  Circle
//
//  Created by Kerby Jean on 5/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit


class transformLabel: UILabel {
    
    
    let duration = 1.0
    let fontSizeSmall: CGFloat = 20
    let fontSizeBig: CGFloat = 100
    var isSmall: Bool = true
    
    
    func enlarge() {
        var biggerBounds = self.bounds
        self.font = self.font.withSize(fontSizeBig)
        biggerBounds.size = self.intrinsicContentSize
        
        self.transform = scaleTransform(from: biggerBounds.size, to: self.bounds.size)
        self.bounds = biggerBounds
        
        UIView.animate(withDuration: duration) {
            self.transform = .identity
        }
    }
    
    func shrink() {
        let labelCopy = self.copyLabel()
        var smallerBounds = labelCopy.bounds
        labelCopy.font = self.font.withSize(fontSizeSmall)
        smallerBounds.size = labelCopy.intrinsicContentSize
        
        let shrinkTransform = scaleTransform(from: self.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = shrinkTransform
        }, completion: { done in
            self.font = labelCopy.font
            self.transform = .identity
            self.bounds = smallerBounds
        })
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }

}

extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        return label
    }
}
