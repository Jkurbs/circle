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

class PaymentsCell: UITableViewCell, UITextFieldDelegate {
    
    var cardImageView: UIImageView!
    var numberField = TextFieldRect()
    var cardSeparator = UIView()
    
    var expirationField = TextFieldRect()
    var expirationSeparator = UIView()

    var cvvField = TextFieldRect()
    var cvvSeparator = UIView()

    var zipField = TextFieldRect()
    var zipSeparator = UIView()
    
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cardImageView = UICreator.create.imageView(UIImage(named: "Visa"), contentView)
        cardImageView.backgroundColor = .white
        cardImageView.contentMode = .scaleAspectFit
        
        numberField.placeholder = "Card Number"
        expirationField.placeholder = "MM/YY"
        cvvField.placeholder = "Security Code"
        zipField.placeholder = "Billing Zip Code"
        
        
        for field in [numberField, expirationField, cvvField, zipField] {
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.keyboardType = .numberPad
            field.clearButtonMode = .whileEditing
            field.font = .systemFont(ofSize: 15)
            field.minimumFontSize = 14.0
            field.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            field.delegate = self
            contentView.addSubview(field)
        }
        
        for separator in [cardSeparator, expirationSeparator, cvvSeparator, zipSeparator] {
            separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            contentView.addSubview(separator)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(cardImageView, numberField, expirationField, cvvField, zipField, cardSeparator, expirationSeparator, cvvSeparator, zipSeparator, contentView) { (cardImageView, cardField, mmyyField, securityField, zipField, cardSeparator, mmyySeparator, securitySeparator, zipSeparator, contentView) in

            cardField.left == cardImageView.right + 5
            cardField.width == contentView.width
            cardField.height == contentView.height/3
            
            cardImageView.left == contentView.left + 10
            cardImageView.centerY == cardField.centerY
            cardImageView.height == 30
            cardImageView.width == 30
            
            cardSeparator.top == cardField.bottom
            cardSeparator.centerX == contentView.centerX
            cardSeparator.width == contentView.width - 20
            cardSeparator.height == 0.5

            mmyyField.top == cardField.bottom
            mmyyField.width == contentView.width/2
            mmyyField.height == cardField.height
            mmyyField.left == contentView.left
            
            mmyySeparator.top == mmyyField.bottom
            mmyySeparator.left == contentView.left + 10
            mmyySeparator.width == (contentView.width/2) - 20
            mmyySeparator.height == 0.5
            
            securityField.top == cardField.bottom
            securityField.right == contentView.right
            securityField.width == contentView.width/2
            securityField.height == cardField.height
            
            securitySeparator.top == securityField.bottom
            securitySeparator.right == contentView.right - 10
            securitySeparator.width == (contentView.width/2) - 20
            securitySeparator.height == 0.5
            
            zipField.top == securityField.bottom
            zipField.width == contentView.width
            zipField.height == cardField.height
            
            zipSeparator.top == zipField.bottom
            zipSeparator.centerX == contentView.centerX
            zipSeparator.width == contentView.width - 20
            zipSeparator.height == 0.5
        }
    }
}


extension PaymentsCell {

    //MARK: UITextFieldDelegate
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case numberField:
            reformatAsCardNumber(textField)
            self.parentViewController().navigationItem.rightBarButtonItem?.isEnabled = true 
        case expirationField:
            reformatAsExpiration(textField)
        case cvvField:
            reformatAsCVV(textField)
        default: break
        }
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Save textField's current state before performing the change, in case
        // reformatAsCardNumber wants to revert it
        
        let prefix = numberField.text!.prefix(1)
        let state = CardState(fromPrefix: String(prefix))
        let type = cardType(forState: state)
        self.prefix = String(prefix)
        self.type = type
        
        switch textField {
        case numberField:
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
        
        if cardNumberWithoutSpaces.count == 0 {
            self.cardImageView.image = UIImage(named: "Generic")

        }
        
        if cardNumberWithoutSpaces.count > cardNumberLength {
            // If the user is trying to enter more than maxCreditCardNumberLength digits, we prevent
            // their change, leaving the text field in its previous state.
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            expirationField.becomeFirstResponder()
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
            zipField.becomeFirstResponder()
        }
    }
}







