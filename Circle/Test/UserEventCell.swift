//
//  UserEventCell.swift
//  Circle
//
//  Created by Kerby Jean on 3/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserEventCell: UICollectionViewCell {
    
    var dateLabel = UILabel()
    var label = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .textFieldBackgroundColor
        contentView.addSubview(dateLabel)
        contentView.addSubview(label)
        contentView.layer.addSublayer(separator)
    
        dateLabel.textColor = .darkText
        dateLabel.numberOfLines = 3
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        dateLabel.textAlignment = .center
        
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect(x: 10, y: 10, width: 60, height: 40)
        
        let width = self.frame.width - 60
        label.frame = CGRect(x: dateLabel.frame.maxX + 20, y: 10, width: width, height: 40)
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
    
    func configure(_ event: Event) {

        let date = event.date
        let userCalendar = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date!)
        let components = userCalendar.dateComponents(requestedComponents, from: date!)
        dateLabel.text = "\(components.day!) \n \(nameOfMonth) \n \(components.hour!):\(components.minute!)"

        switch event.type {
            case "received":
                label.text = "Received \(event.amount ?? "undefined")$ from you"
            case "send":
                label.text = "Send \(event.amount ?? "undefined")$ to you"
            default:
                print("DEFAULT")
        }
    }
}
