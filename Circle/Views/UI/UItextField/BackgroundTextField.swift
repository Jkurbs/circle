//
//  BackgroundTextField.swift
//  Circle
//
//  Created by Kerby Jean on 1/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class BackgroundTextField: UITextField, UITextFieldDelegate {
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
        setup()
    }
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        self.clipsToBounds = true
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.font = font
        self.textColor = UIColor.darkGray
        self.borderStyle                = .none
        self.borderColor = UIColor.lightGray
        //self.borderWidth = 0.5
        self.cornerRadius = 5.0
        self.backgroundColor = textFieldBackgroundColor
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("focused")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("lost focus")
    }
    

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.leftView != nil {
            return bounds.insetBy(dx: 50, dy: 0)
        }
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if self.leftView != nil {
            return bounds.insetBy(dx: 50, dy: 0)
        }
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    func button(_ title: String? = nil, iconName: String? = nil) -> UIButton {
        self.leftView = nil
        self.rightView = nil
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.70, height: self.frame.height * 0.70)
        if title != nil {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(UIColor.blueColor, for: UIControlState())
            button.setTitleColor(UIColor.gray, for: .disabled)
            self.leftViewMode = .always
            self.leftView = button 
        }
        
        if iconName != nil {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            button.setImage(UIImage(named: iconName!), for: UIControlState())
            self.rightViewMode = .always
            self.rightView = button
        }

        return button
    }
    
    func errorDetected(superView: UIView, error: String, frame: CGRect) {
        self.borderColor = UIColor.red
        let errorLabel = Footnote()
        errorLabel.frame = frame
        errorLabel.textColor = UIColor.red
        superView.addSubview(errorLabel)
    }
    
    func ifPasswordValid(_ password: String) -> Bool {
        let passwordValidated = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordValidated.evaluate(with: password)
    }
}







