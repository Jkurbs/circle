//
//  InsightCell.swift
//  Circle
//
//  Created by Kerby Jean on 2/6/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class InsightCell: UITableViewCell {
        
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var eventLabel = UILabel()
    var timeLabel = UILabel()
    var amountLabel = UILabel()

        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        profileImageView.contentMode = .scaleAspectFill
//        contentView.addSubview(profileImageView)

        self.backgroundColor = .textFieldBackgroundColor

        contentView.addSubview(timeLabel)
        timeLabel.textAlignment = .right
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        contentView.addSubview(eventLabel)
        eventLabel.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(amountLabel)
        amountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let blueColor = UIColor(red: 0.0/255.0, green: 153.0/255.0, blue: 229.0/255.0, alpha: 0.5)
        
        self.contentView.backgroundColor = selected ? blueColor : nil
        
        if selected {
            print("SELECTED")
        } else {
            print("DESELECTED")
        }
    }
    
    
    
    override func layoutSubviews() {
        
        
        let width = self.frame.width
        
        
        timeLabel.frame = CGRect(x: 10, y: 6, width: 40, height: 20)
        timeLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: timeLabel.frame.maxX + 10, y: 6, width: 20, height: 20)
        nameLabel.sizeToFit()
    
        eventLabel.frame = CGRect(x: nameLabel.frame.maxX + 2, y: 6, width: 50, height: 20)
        eventLabel.sizeToFit()
        
        amountLabel.frame = CGRect(x: width - (width * 0.1) - 30, y: 6, width: 50, height: 20)
        amountLabel.sizeToFit()
        

    }
    
    
    
   func configure(_ user: User) {
    
//    if user.photoUrl != nil {
//        self.profileImageView.sd_setImage(with: URL(string: user.photoUrl!))
//      }
    
    
    timeLabel.text = "2 hrs"
    nameLabel.text = user.firstName!
    eventLabel.text = "just payed"
    amountLabel.text = "200$"
    
   }
}

