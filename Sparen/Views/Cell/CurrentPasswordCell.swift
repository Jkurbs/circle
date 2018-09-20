//
//  CurrentPasswordCell.swift
//  Sparen
//
//  Created by Kerby Jean on 8/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class CurrentPasswordCell: UITableViewCell {

    var textField = TextFieldRect()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .gray
        textField.placeholder = "Current password"
        textField.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = contentView.frame

    }
}

class NewPasswordCell: UITableViewCell {
    
    var textField = TextFieldRect()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.textColor = .gray
        textField.placeholder = "New password"
        textField.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = contentView.frame
    }
}

class RepeatNewPasswordCell: UITableViewCell {
    
    var textField = TextFieldRect()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.textColor = .gray
        textField.placeholder = "Retype new password"
        textField.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = contentView.frame
    }
}
