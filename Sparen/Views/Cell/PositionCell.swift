//
//  PositionCell.swift
//  Sparen
//
//  Created by Kerby Jean on 1/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography
import FirebaseAuth

class PositionCell: UITableViewCell {
    
    var userImageView: UIImageView!
    var nameLabel: UILabel!
    var positionLabel: UILabel!
    
    var blurView = UIView()
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImageView = UICreator.create.imageView(nil, self.contentView)
        nameLabel = UICreator.create.label("", 15, .darkText, .natural, .medium, self.contentView)
        
        blurView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(userImageView, nameLabel, contentView) { (imageView, nameLabel, contentView) in
            
            imageView.width == 45
            imageView.height == 45
            imageView.left == contentView.left + 10
            imageView.centerY == contentView.centerY
            
            nameLabel.left == imageView.right + 10
            nameLabel.centerY == imageView.centerY
            
        }
        
        dispatch.async {
            self.userImageView.cornerRadius = self.userImageView.frame.width/2
        }
    }
    
    func configure(_ user: User) {
        blurView.frame = userImageView.bounds
        
        if let url = user.imageUrl {
            userImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            userImageView.image = UIImage(named: "profile")
        }
        userImageView.addSubview(blurView)
        nameLabel.text = user.firstName

        if user.userId != Auth.auth().currentUser!.uid {
            blurView.alpha = 1.0
            self.isUserInteractionEnabled = false
            nameLabel.isEnabled = false
        } else {
            blurView.alpha = 0.0
            self.isUserInteractionEnabled = true
            nameLabel.isEnabled = true
        }
    }
}
