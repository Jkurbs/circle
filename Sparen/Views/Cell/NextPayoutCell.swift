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
import Cartography

class NextPayoutCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var daysLeftLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        imageView = UICreator.create.imageView(nil, contentView)
        nameLabel = UICreator.create.label("", 15, UIColor.darkerGray, .left, .semibold, contentView)
        daysLeftLabel = UICreator.create.label("", 15, UIColor.lighterGray, .left, .semibold, contentView)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
            constrain(self.imageView, self.nameLabel, self.daysLeftLabel, self.contentView) { imageView, nameLabel, daysLeftLabel, contentView  in
                imageView.height == 40
                imageView.width == 40
                imageView.left  == contentView.left + 20
                imageView.centerY == contentView.centerY
                nameLabel.left == imageView.right + 10
                nameLabel.centerY == imageView.centerY
                daysLeftLabel.right == contentView.right - 20
                daysLeftLabel.centerY == imageView.centerY
                dispatch.async {
                    self.imageView.cornerRadius = self.imageView.frame.height / 2
                }
        }
    }

    
    func configure(_ user: User) {
        imageView.sd_setImage(with: URL(string: user.imageUrl!))
        nameLabel.text = user.firstName
        daysLeftLabel.text =  "\(user.daysLeft ?? 0) days left"
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if user.userId == uid {
            nameLabel.text = "You"
        }
    }
}
