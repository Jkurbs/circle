//
//  DatePickerCell.swift
//  Circle
//
//  Created by Kerby Jean on 4/9/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit




class SelectDateCell: UITableViewCell {
    
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.text = "Set End date"
        label.textColor = self.tintColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.contentView.addSubview(label)
        
    }
}



class DatePickerCell: UITableViewCell {
    
    var datePicker = UIDatePicker()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        datePicker.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 20)
        self.contentView.addSubview(datePicker)
    }
    
    func configure(_ date: Date) {
        datePicker.date = date
    }
}
