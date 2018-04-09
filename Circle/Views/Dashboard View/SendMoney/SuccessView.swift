//
//  SuccessView.swift
//  Circle
//
//  Created by Kerby Jean on 3/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class SuccessView: UIView {
   
    @IBOutlet weak var label: UILabel!
    var parentView: UserDashboardView!
    
    func configure(message: String) {
        label.text = message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.parentView.hideShow(hideView: self, showView: self.parentView.userView)
        }
    }
}
