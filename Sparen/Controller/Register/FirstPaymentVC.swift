//
//  FirstPaymentVC.swift
//  Sparen
//
//  Created by Kerby Jean on 2/14/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Stripe
import Cartography


class FirstPaymentVC: UIViewController, UITextFieldDelegate {
    
    var label = UILabel()
    var secondLabel = UILabel()
    var cardField = TextFieldRect()
    var expField = TextFieldRect()
    var cvvField = TextFieldRect()
    var last4Field = TextFieldRect()
    var nextButton: UIButton!
    
    fileprivate var previousTextFieldContent: String?
    fileprivate var previousSelection: UITextRange?
    
    var cardNumberLength: Int = 19
    
    var numberSeparator: String = " "
    
    /// Separator used between month and year numbers in expiration field
    var expirationSlash: Character = "/"
    
    /// Maximum length for CVV number
    var maxCVVLength: Int = 3
    
    var type: String?
    var prefix: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let bagColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        cardField = UICreator.create.textField("Card Number", .default, self.view)
        expField = UICreator.create.textField("MM/YY", .default, self.view)
        cvvField = UICreator.create.textField("Security Code", .default, self.view)
        
        cardField.backgroundColor = bagColor
        expField.backgroundColor = bagColor
        cvvField.backgroundColor = bagColor
        
        
        for field in [cardField, expField, cvvField] {
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.keyboardType = .numberPad
            field.clearButtonMode = .whileEditing
            field.font = .systemFont(ofSize: 15)
            field.minimumFontSize = 14.0
            field.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            field.delegate = self
        }
        
        
        let font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        label.text = "Add Debit Card"
        label.textAlignment = .center
        
        view.addSubview(label)
        view.addSubview(secondLabel)
        
        nextButton = UICreator.create.button("Done", nil, .white, .red, view)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.backgroundColor = UIColor.sparenColor
        nextButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, secondLabel, cardField, expField, cvvField, nextButton, view) { (label, secondLabel, cardField, expField, cvvField, nextButton, view) in
            
            label.top == view.top + 150
            label.width == view.width
            label.centerX == view.centerX
            
            secondLabel.top == label.bottom + 20
            secondLabel.width == view.width - 100
            secondLabel.centerX == view.centerX
            
            cardField.top == secondLabel.bottom + 40
            cardField.width == view.width - 40
            cardField.height == 45
            cardField.centerX == view.centerX
            
            expField.top == cardField.bottom + 20
            expField.left == cardField.left
            expField.width == cardField.width/2 - 10
            expField.height == 45
            
            cvvField.top == cardField.bottom + 20
            cvvField.right == cardField.right
            cvvField.width == cardField.width/2 - 10
            cvvField.height == 45
            
            nextButton.top == expField.bottom + 60
            nextButton.centerX == view.centerX
            nextButton.height == 50
            nextButton.width == view.width - 40
        }
    }
    

    // MARK: Action
    
    @objc func add() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        let cardParams = STPCardParams()
        
        let cardNumber = cardField.text!
        let expirationDates = expField.text?.components(separatedBy: "/")
        let expMonth = UInt(expirationDates!.first!)
        let expYear = UInt(expirationDates!.last!)
        
        let cvv = cvvField.text!
        let cardType = self.type
        let prefix = self.prefix!
        
        cardParams.number = cardNumber
        cardParams.expMonth = expMonth!
        cardParams.expYear = expYear!
        cardParams.cvc = cvv
        cardParams.currency = "usd"
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let accountToken = token, error == nil else {
                ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "An error has occured", .error)
                return
            }
            
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                guard let token = token, error == nil else {
                    ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "An error has occured", .error)
                    return
                }
                
                DataService.call.addPayment(accountToken.tokenId, token.tokenId,  cardType!, "\(expMonth!)/\(expYear!)", cardParams.cvc!, prefix,  complete: { (success, error) in
                    
                    let nav = UINavigationController(rootViewController: DashboardVC())
                    activityIndicator.stopAnimating()
                    self.navigationController?.present(nav, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    @objc func textChanged(_ textField: UITextField) {
        if cardField.hasText && expField.hasText && cvvField.hasText {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Save textField's current state before performing the change, in case
        // reformatAsCardNumber wants to revert it
        
        let prefix = cardField.text!.prefix(1)
        let state = CardState(fromPrefix: String(prefix))
        let type = cardType(forState: state)
        self.prefix = String(prefix)
        self.type = type
        
        switch textField {
        case cardField:
            previousTextFieldContent = textField.text
            previousSelection = textField.selectedTextRange
        default:
            break
        }
        return true
    }
    
    
    func cardType(forState cardState:CardState) -> String? {
        switch cardState {
        case .identified(let cardType):
            switch cardType{
            case .visa:         return "Visa"
            case .masterCard:   return "MasterCard"
            case .amex:         return ""
            case .diners:       return ""
            case .discover:     return "Discovery"
            case .jcb:          return ""
            }
        case .indeterminate: return ""
        case .invalid:      return ""
        }
    }
    
    
    open func removeNonDigits(_ string: String, cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        var digitsOnlyString = ""
        for i in 0..<string.count {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if "0"..."9" ~= characterToAdd {
                digitsOnlyString.append(characterToAdd)
            }
            else {
                if (i < originalCursorPosition) {
                    cursorPosition -= 1
                }
            }
        }
        return digitsOnlyString
    }
    
    open func insertSpacesEveryFourDigits(_ string: String, cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in 0..<string.count {
            if ((i>0) && ((i % 4) == 0)) {
                stringWithAddedSpaces += numberSeparator
                if (i < cursorPositionInSpacelessString) {
                    cursorPosition += numberSeparator.count
                }
            }
            stringWithAddedSpaces.append(string[string.index(string.startIndex, offsetBy: i)])
        }
        return stringWithAddedSpaces
    }
    
    //MARK: Card number formatting
    
    open func reformatAsCardNumber(_ textField: UITextField) {
        // In order to make the cursor end up positioned correctly, we need to
        // explicitly reposition it after we inject spaces into the text.
        // targetCursorPosition keeps track of where the cursor needs to end up as
        // we modify the string, and at the end we set the cursor position to it.
        guard let selectedRange = textField.selectedTextRange, let textString = textField.text else { return }
        var targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        
        let cardNumberWithoutSpaces = removeNonDigits(textString, cursorPosition: &targetCursorPosition)
        
        
        if cardNumberWithoutSpaces.count > cardNumberLength {
            // If the user is trying to enter more than maxCreditCardNumberLength digits, we prevent
            // their change, leaving the text field in its previous state.
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            cvvField.becomeFirstResponder()
            return
        }
        
        let cardNumberWithSpaces = insertSpacesEveryFourDigits(cardNumberWithoutSpaces, cursorPosition: &targetCursorPosition)
        
        // update text and cursor appropiately
        textField.text = cardNumberWithSpaces
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    //MARK: Expiration date formatting
    open func reformatAsExpiration(_ textField: UITextField) {
        guard let string = textField.text else { return }
        let expirationString = String(expirationSlash)
        let cleanString = string.replacingOccurrences(of: expirationString, with: "", options: .literal, range: nil)
        if cleanString.count >= 3 {
            let monthString = cleanString[Range(0...1)]
            var yearString: String
            if cleanString.count == 3 {
                yearString = cleanString[2]
            } else {
                yearString = cleanString[Range(2...3)]
            }
            textField.text = monthString + expirationString + yearString
        } else {
            textField.text = cleanString
        }
        if cleanString.count == 4 {
            cvvField.becomeFirstResponder()
        }
    }
    
    //MARK: CVV formatting
    open func reformatAsCVV(_ textField: UITextField) {
        guard let string = textField.text else { return }
        if string.count > 4 {
            textField.text = string[0..<4]
        }
    }
    
    //MARK: UITextFieldDelegate
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case cardField:
            reformatAsCardNumber(textField)
        case expField:
            reformatAsExpiration(textField)
        case cvvField:
            reformatAsCVV(textField)
        default: break
        }
    }
}
