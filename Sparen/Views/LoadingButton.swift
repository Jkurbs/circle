//
//  LoadingButton.swift
//  Circle
//
//  Created by Kerby Jean on 1/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    var activityIndicator: UIActivityIndicatorView!
    
    
    func showLoading() {
        self.setTitleColor(.clear, for: .normal)
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
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
