//
//  ContactCell.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import MessageUI

class ContactCell: UITableViewCell {

 var profileImageView = UIImageView()
 var nameLabel = UILabel()
 var selectImageView = UIImageView()
    
    var contact: Contact?
    
    fileprivate let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor(white: 7, alpha: 1.0)
        return view
    }()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        
        
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)
        
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(selectImageView)

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
        
        profileImageView.addSubview(label)
        
        profileImageView.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true 
        profileImageView.backgroundColor = UIColor.textFieldBackgroundColor
        
        label.frame = profileImageView.bounds
        
        nameLabel.frame = CGRect(x: profileImageView.frame.maxX + 10, y: 25, width: contentView.frame.width, height: 20)
    }

    
    
    func configure(_ contact: Contact) {
        self.contact = contact
        
        if contact.imageData == nil {
            profileImageView.image = nil
    
            label.isHidden = false
            let letter = contact.givenName?.first
            if letter != nil {
               label.text = "\(String(describing: letter!))"
            }
        } else {
            label.isHidden = true
            let imageData = contact.imageData
            let image = UIImage(data: imageData!)
            profileImageView.image = image
        }
        
        if let phoneNumber = contact.phoneNumber, let givenName = contact.givenName {
            nameLabel.text = "\(givenName) \(contact.familyName ?? "")"
        }
    }
}

