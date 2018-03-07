//
//  UserView.swift
//  Circle
//
//  Created by Kerby Jean on 2/23/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import Stripe

class DashboardView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var requestButton: OptionButton!
    @IBOutlet weak var historyButton: OptionButton!
    @IBOutlet weak var sendButton: OptionButton!
 
    // AMOUNT VIEW
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var cancelButton: OptionButton!
    @IBOutlet weak var confirmButton: OptionButton!
 
    var amountTextField = BackgroundTextField()
    var formatter: NumberFormatter!
 
    // CONFIRMATION VIEW
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var sourceType: UILabel!
    @IBOutlet weak var sourceLast4: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    
    // PRCESSESSING VIEW
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var successImageView: OptionButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var user: User?
 
    enum mode {
        case Send, Request
    }

    var myMode = mode.Send
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        resize(toFitSubviews: userView)
        self.backgroundColor = UIColor.textFieldBackgroundColor
        userView.backgroundColor = UIColor.textFieldBackgroundColor
    }
    
 
    override func layoutSubviews() {
        super.layoutSubviews()
        amountTextField.delegate = self
        amountTextField.frame = CGRect(x: 0, y: toLabel.layer.position.y + 20, width: 200, height: 60)
        amountTextField.center.x = userView.center.x
        amountTextField.placeholder = "Enter amount"
        amountTextField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        amountTextField.keyboardType = .decimalPad
        let button = amountTextField.button(nil, iconName: "Dollar-20")
        amountTextField.isEnabled = true
        button.frame =  CGRect(x: 0, y: 0, width: 50, height: 50)
        transactionView.addSubview(amountTextField)
    }


    func configure(_ user: User?) {
        self.user = user
        nameLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        switch myMode {
        case .Send:
            toLabel.text = "Send money to \(user?.firstName ?? "")"
        case .Request:
            toLabel.text = "Request money from \(user?.firstName ?? "")"
        }
    }
 
    
 
    @IBAction func userAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            showMoreAlert()
        case 1:
             showTransactionView(true)
        case 2:
            showHistory()
        case 3:
            showTransactionView(false)
        case 4:
            showUserView()
        case 5:
            showConfirmationView()
        case 6:
            showConfirmationView()
        case 7:
            sendMoney()
        default:
            print("")
        }
    }
}



extension DashboardView: UITextFieldDelegate {
    
    
    
    func showMoreAlert() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        let remove = UIAlertAction(title: "Remove \(user?.firstName ?? "") \(user?.lastName ?? "")", style: .default) { (action) in
 
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(remove)
        alert.addAction(cancel)
        self.viewController?.present(alert, animated: true, completion: nil)
    }
    
 
    func showHistory() {
        
    }

 
    func showTransactionView(_ request: Bool) {
        resize(toFitSubviews: transactionView)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        confirmButton.isEnabled =  false
        confirmButton.alpha =  0.5
 
        switch request {
        case true:
            myMode = mode.Request
            self.toLabel.text = "Request money from \(self.user?.firstName ?? "")"
        case false:
            myMode = mode.Send
            self.toLabel.text = "Send money to \(self.user?.firstName ?? "")"
        }
        UIView.animate(withDuration: 0.3){
            self.userView.alpha = 0.0
            self.userView.isHidden = true
            self.transactionView.alpha = 1.0
            self.transactionView.isHidden = false 
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                self.amountTextField.becomeFirstResponder()
            }
        }
    }
 
    func showUserView() {
        resize(toFitSubviews: userView)
        UIView.animate(withDuration: 0.3) {
            self.transactionView.alpha = 0.0
            self.transactionView.isHidden = true
            self.confirmationView.alpha = 0.0
            self.confirmationView.isHidden = true
            self.userView.alpha = 1.0
            self.userView.isHidden = false
            self.amountTextField.text = ""
            self.amountTextField.resignFirstResponder()
        }
    } 
 
    func showConfirmationView() {
          resize(toFitSubviews: confirmationView)
        UIView.animate(withDuration: 0.3) {
            self.transactionView.alpha = 0.0
            self.transactionView.isHidden = true
            self.confirmationView.alpha = 1.0
            self.confirmationView.isHidden = false
            self.amountTextField.resignFirstResponder()
        }
        
        //sourceType.text = u
        //cardButton.setTitle("•••• \(user?.card!.last4 ?? "")", for: .normal)
        destinationLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        amountLabel.text = amountTextField.text!
    }
    
 
    func sendMoney() {
        self.showProcessingView()
        let amount = amountLabel.text!
        let firstName = user?.firstName ?? ""
        let lastName = user?.lastName ?? ""
        
        
        MoneyService.instance.sendMoney("\(amount)", user?.accountId ?? "", firstName, lastName) { (status, success)  in
                self.statusLabel.text = "Succeeded"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    UIView.animate(withDuration: 0.3) {
                    self.resize(toFitSubviews: self.userView)
                    self.processingView.alpha = 0.0
                    self.processingView.isHidden = true
                    self.userView.alpha = 1.0
                    self.userView.isHidden = false
                        
                }
            }
        }
    }
 
    func showProcessingView() {
        UIView.animate(withDuration: 0.3) {
            self.resize(toFitSubviews: self.processingView)
            self.successImageView.isHidden = false
            self.confirmationView.alpha = 0.0
            self.confirmationView.isHidden = true
            self.processingView.alpha = 1.0
            self.processingView.isHidden = false
        }
    }

 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Uses the number format corresponding to your Locale
//        formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.locale = Locale.current
//        formatter.maximumFractionDigits = 0
        
//        if let groupingSeparator = formatter.groupingSeparator {
//
//            if string == groupingSeparator {
//                return true
//            }
//            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
//                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
//                if string == "" { // pressed Backspace key
//                    totalTextWithoutGroupingSeparators.removeLast()
//                }
//                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
//                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
//                    textField.text = formattedText
//                    return false
//                }
//            }
//        }
        return true
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
    
    func resize(toFitSubviews view: UIView) {
        var w: Float = 0
        var h: Float = 0
        for v: UIView in view.subviews {
            let fw: Float = Float(v.frame.origin.x + v.frame.size.width)
            let fh: Float = Float(v.frame.origin.y + v.frame.size.height)
            w = max(fw, w)
            h = max(fh, h)
        }
        self.frame = CGRect(x: self.frame.origin.x, y:  self.frame.origin.y, width: self.frame.width, height: CGFloat(h))
        self.center.x = UIScreen.main.bounds.width * 0.5
    }
}



