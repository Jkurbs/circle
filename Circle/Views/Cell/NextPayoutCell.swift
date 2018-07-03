//
//  NextPayoutCell.swift
//  Circle
//
//  Created by Kerby Jean on 5/29/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import SDWebImage
import FirebaseAuth

class NextPayoutCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var daysLeftLabel =  UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(daysLeftLabel)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        let descColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        imageView.frame = CGRect(x: 25, y: 5, width: 40, height: 40)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = imageView.frame.height / 2
    
        nameLabel.frame = CGRect(x: imageView.layer.position.x + 40, y: 10, width: 100, height: 30)
        nameLabel.font = font
        nameLabel.textColor = color
        
        daysLeftLabel.frame = CGRect(x: contentView.bounds.width - 90, y: 10, width: 40, height: 30)
        daysLeftLabel.sizeToFit()
        daysLeftLabel.font = font
        daysLeftLabel.textColor = descColor
    }
    
    
    func configure(_ user: User) {
        imageView.sd_setImage(with: URL(string: user.imageUrl!))
        nameLabel.text = user.firstName
        daysLeftLabel.text =  "\(user.daysLeft ?? 0) days left"
        
        if let uid = Auth.auth().currentUser!.uid as? String {
            if user.userId == uid {
                nameLabel.text = "You"
            }
        }
    }
}
