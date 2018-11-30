//
//  PaymentsCell.swift
//  Sparen
//
//  Created by Kerby Jean on 9/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Stripe
import Cartography

class PaymentsCell: UITableViewCell, STPPaymentCardTextFieldDelegate {
    
    var cardField = UITextField()
    var dateField = UITextField()
    var codeField = UITextField()
    var zipField = UITextField()
    
    let paymentTextField = STPPaymentCardTextField()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 0.0 
        
        contentView.addSubview(paymentTextField)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(paymentTextField, contentView) { (paymentTextField, view) in
            
            paymentTextField.centerX == view.centerX
            paymentTextField.top == view.top + 25
            paymentTextField.width == view.width - 50
            paymentTextField.height == view.height
            
        }
    }
}








