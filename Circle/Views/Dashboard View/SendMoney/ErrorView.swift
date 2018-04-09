//
//  ErrorView.swift
//  Circle
//
//  Created by Kerby Jean on 3/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    var parentView: UserDashboardView!
    
    @IBOutlet weak var errorLabel: UILabel!
    var errorMessage: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    @IBAction func actions(_ sender: OptionButton) {
        switch sender.tag {
        case 0:
            parentView.hideShow(hideView: self, showView: parentView.userView)
        case 1:
            parentView.hideShow(hideView: self, showView: parentView.processingView)
            resend()
        default:
            print("")
        } 
    }
    
    func resend() {
        parentView.confirmationView.send()
    }
}
