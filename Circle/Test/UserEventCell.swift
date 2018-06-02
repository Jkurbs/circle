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
    var imageView = UIImageView()
    var moreButton = UIButton()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(label)
        contentView.addSubview(moreButton)

        //contentView.addSubview(imageView)

        
        label.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .left
        
        
        dateLabel.textColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textAlignment = .left
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "Right-2-filled-20")
        
        moreButton.frame = CGRect(x: contentView.frame.maxX - 40, y: 10 , width: 40, height: 40)
        moreButton.setImage(#imageLiteral(resourceName: "More-filled-15"), for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width - 60
        
        imageView.frame = CGRect(x: 40, y: 10, width: 20, height: self.contentView.frame.height)
        
        
        label.frame = CGRect(x: 45, y: 10, width: width, height: 40)
        
        dateLabel.frame = CGRect(x: 45, y: 45, width: 60, height: 20)
        dateLabel.sizeToFit()
        
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
        dateLabel.text = "\(components.day!) \(nameOfMonth) \(components.hour!):\(components.minute!)"

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
