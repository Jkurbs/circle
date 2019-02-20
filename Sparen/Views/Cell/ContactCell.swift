//
//  ContactCell.swift
//  Sparen
//
//  Created by Kerby Jean on 1/24/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

protocol CustomTableViewCellDelegate {
    func didToggleRadioButton(_ indexPath: IndexPath)
}

class ContactCell: UITableViewCell {
    
    
    var contactImageView: UIImageView!
    var nameLabel: UILabel!
    var button: UIButton!


    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contactImageView = UICreator.create.imageView(UIImage(named: "one"), self.contentView)
        nameLabel = UICreator.create.label("", 15, .darkText, .natural, .medium, self.contentView)
        button = UICreator.create.button(nil, nil, nil, nil, self.contentView)
        button.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        constrain(contactImageView, nameLabel, button, contentView) { (imageView, nameLabel, button, contentView) in
            
            imageView.width == 45
            imageView.height == 45
            imageView.left == contentView.left + 10
            imageView.centerY == contentView.centerY
            
            nameLabel.left == imageView.right + 10
            nameLabel.centerY == imageView.centerY
            
            button.right == contentView.right - 15
            button.centerY == contentView.centerY
            button.width == 30
            button.height == 30

        }
        
        dispatch.async {
            self.contactImageView.cornerRadius = self.contactImageView.frame.width/2
            self.button.cornerRadius = self.button.frame.width/2

        }
    }
    
    func configure(_ contact: PhoneContact) {
    
        nameLabel.text = contact.name
        if let imageData = contact.avatarData {
            contactImageView.image = nil
            contactImageView.image = UIImage(data: imageData)
        } else {
            contactImageView.image = nil
            contactImageView.image = UIImage(named:"profile")
        }
    }
}
