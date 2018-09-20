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
        
//        cardField = UICreator.create.textField("Card Number", .decimalPad, contentView)
//        dateField = UICreator.create.textField("MM/YY", .decimalPad, contentView)
//        codeField = UICreator.create.textField("Security Code", .decimalPad, contentView)
//        zipField = UICreator.create.textField("ZIP Code", .decimalPad, contentView)
        
       // cardField.becomeFirstResponder()
        
        //paymentTextField.frame = CGRect(x: 0, y: 25, width: self.contentView.frame.width , height: 45)
       // paymentTextField.center.x = contentView.center.x
        paymentTextField.delegate = self
        
        contentView.addSubview(paymentTextField)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(paymentTextField, contentView) { (paymentTextField, view) in

//            cardField.top == view.top
//            cardField.left == view.left + 10
//            cardField.height == 60
//            cardField.width == view.width
//
//            dateField.left == cardField.left
//            dateField.top == cardField.bottom
//            dateField.height == 60
//            dateField.width == view.width/2
//
//            codeField.top == cardField.bottom
//            codeField.right == view.right
//            codeField.height == 60
//            codeField.width == dateField.width
//
//            zipField.left == cardField.left
//            zipField.top == dateField.bottom
//            zipField.height == 60
//            zipField.width == view.width
            
            paymentTextField.centerX == view.centerX
            paymentTextField.top == view.top + 25
            paymentTextField.width == view.width - 50
            
        }
    }
}








