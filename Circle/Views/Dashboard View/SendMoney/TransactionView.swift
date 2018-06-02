//
//  TransactionView.swift
//  Circle
//
//  Created by Kerby Jean on 3/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit


class TransactionView: UIView, UITextFieldDelegate {
    
    var parentView: UserDashboardView!
    var label = Subhead()
    var amountTextField = BackgroundTextField()
    var user: User!

    @IBOutlet weak var confirmButton: OptionButton!
    
    var mode = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 10, width: self.frame.width, height: 30)
        self.addSubview(label)
        
        amountTextField.delegate = self
        amountTextField.frame = CGRect(x: 0, y: label.layer.position.y + 20, width: 200, height: 60)
        amountTextField.center.x = self.center.x
        amountTextField.placeholder = "Enter amount"
        amountTextField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        amountTextField.keyboardType = .decimalPad
        let button = amountTextField.button(nil, iconName: "Dollar-20")
        amountTextField.isEnabled = true
        button.frame =  CGRect(x: 0, y: 0, width: 50, height: 50)
        self.addSubview(amountTextField)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        self.layer.mask = rectShape
    }
    
    @IBAction func actions(_ sender: OptionButton) {
        amountTextField.resignFirstResponder()
        switch sender.tag {
        case 0:
            parentView.hideShow(hideView: self, showView: parentView.userView)
        case 1:
            switch mode {
            case "Request":
                parentView.hideShow(hideView: self, showView: parentView.processingView)
                parentView.processingView.request(user: user, amount: amountTextField.text!)
            case "Send":
                parentView.confirmationView.amount = amountTextField.text!
                parentView.confirmationView.configure(user)
                parentView.hideShow(hideView: self, showView: parentView.confirmationView)
            default:
                print("default")
            }
            
        default:
            print("default")
        }
    }
    
    @objc func textChanged(sender: NSNotification) {
        if amountTextField.hasText {
            confirmButton.isEnabled = true
            confirmButton.alpha = 1.0
        } else {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
        }
    }
    
    
    func configure(_ user: User) {
        self.user = user
        switch mode {
        case "Request":
            self.label.text = "Request money from \(user.firstName ?? "")"
        case "Send":
            self.label.text = "Send money to \(user.firstName ?? "")"
        default:
            print("default")
        }
        
    }
    
    func confirm() {
        parentView.hideShow(hideView: self, showView: parentView.processingView)
    }
}


