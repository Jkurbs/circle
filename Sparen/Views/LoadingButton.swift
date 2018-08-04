//
//  LoadingButton.swift
//  Circle
//
//  Created by Kerby Jean on 1/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    var activityIndicator: ActivityIndicator!
    
    
    func showLoading() {
        self.setTitleColor(.clear, for: .normal)
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitleColor(.white, for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func createActivityIndicator() -> ActivityIndicator {
        let activityIndicator = ActivityIndicator()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.strokeColor = .lightGray
        activityIndicator.lineWidth = 2.0
        activityIndicator.numSegments = 12
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
         self.addConstraint(yCenterConstraint)
        
    }
}
