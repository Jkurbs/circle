//
//  LoadingView.swift
//  Circle
//
//  Created by Kerby Jean on 2/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var label = Subhead()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }()
    
    
    func setup() {
        self.frame = CGRect(x: self.layer.position.x, y: self.layer.position.y, width: self.frame.width, height: self.frame.height)
        self.backgroundColor = .white
        
        let bounds = UIScreen.main.bounds
        
        activityView.center = CGPoint(x: bounds.width / 2.0, y: 200)
        self.addSubview(activityView)
        
       label.frame = CGRect(x: self.center.x, y: self.center.y, width: self.frame.width, height: self.frame.height)
       label.text = "Failed to load data"
    }
    
    func stop() {
        activityView.stopAnimating()
    }
    
    
    func showMessage() {
        activityView.stopAnimating()
    }
}
