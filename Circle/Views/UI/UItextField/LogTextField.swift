//
//  BackgroundTextField.swift
//  Circle
//
//  Created by Kerby Jean on 1/17/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

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
    
    
    func setup(){
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.font = font
        self.borderStyle                = .none
        self.borderColor = UIColor.lightGray
        self.borderWidth = 0.5
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
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    func button(_ title: String? = nil, image: UIImage? = nil, left: Bool) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.rightViewMode = .always
        if title != nil {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15 * self.multiflierForDevice())
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.setTitleColor(UIColor.gray, for: .disabled)
        }
        
        if image != nil {
            button.setImage(image, for: UIControlState())
        }
        
        if left == true {
            self.leftView = button
        } else {
            self.rightView = button
        }
        
        return button
    }
}
