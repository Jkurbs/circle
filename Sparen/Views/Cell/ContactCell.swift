//
//  ContactCell.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

 var profileImageView = UIImageView()
 var nameLabel = UILabel()
 var button = UIButton()
    
    
    var contact: UserContact?
    
    fileprivate let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor(white: 7, alpha: 1.0)
        return view
    }()
    
    
    var item: ViewModelItem? {
        didSet {
            nameLabel.text = item?.contact.givenName
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("ITEM IN CELL", item?.contact.givenName)

        
        self.selectionStyle = .none
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)
        
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        
//        let button = UIButton(type: .system)
//        button.setTitle("done", for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        button.cornerRadius = button.frame.width/2
//        button.borderColor = UIColor(white: 0.9, alpha: 1.0)
//        button.borderWidth = 3
//        
//        accessoryView = button
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        
        let center =  contentView.center.y
        
        profileImageView.addSubview(label)
        
        profileImageView.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
        profileImageView.center.y = contentView.center.y
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.textFieldBackgroundColor
        
        label.frame = profileImageView.bounds
        
        nameLabel.frame = CGRect(x: profileImageView.frame.maxX + 10, y: 0, width: contentView.frame.width, height: 20)
        nameLabel.center.y = center
        
        
            
    }

    
    
   func configure(_ contact: UserContact) {
    
    }
}

