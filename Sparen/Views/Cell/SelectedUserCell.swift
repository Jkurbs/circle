//
//  SelectedUserCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography

class SelectedUserCell: UICollectionViewCell {
    
    var statusDesc: UILabel!
    var statusLabel: UILabel!
    var daysDesc: UILabel!
    var daysLabel: UILabel!
    var layerView: UIView!
    var imageView =  UIImageView()
    var nameLabel: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //setup()
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        statusDesc = UICreator.create.label("Status" ,16, .darkerGray, .center, .semibold, contentView)
        daysDesc = UICreator.create.label("Days left", 16, .darkerGray, .center, .semibold, contentView)
        statusLabel = UICreator.create.label("", 16, .darkerGray, .center, .semibold, contentView)
        daysLabel = UICreator.create.label("", 16, .lighterGray, .center, .semibold, contentView)
        imageView = UICreator.create.imageView(nil, contentView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(statusDesc, statusLabel, imageView, daysDesc, daysLabel, contentView) { statusDesc, statusLabel, imageView, daysDesc, daysLabel, view in
            statusDesc.left  == view.left + 10
            statusLabel.left == view.left + 10
            statusDesc.width == 100
            statusLabel.width == 100
            statusDesc.top == view.top + 20
            statusLabel.top == statusDesc.bottom + 10

            imageView.centerX == view.centerX
            imageView.width == 60
            imageView.height == 60
            imageView.top == statusDesc.top

            daysDesc.right  == view.right - 10
            daysLabel.right == view.right - 10
            daysDesc.width  == 100
            daysLabel.width == 100
            daysDesc.top == statusDesc.top
            daysLabel.top == statusLabel.top
        }
        
        dispatch.async {
            self.imageView.clipsToBounds = true
            self.imageView.cornerRadius = self.imageView.frame.width / 2
        }
    }

    
    func configure(_ user: User) {

        imageView.image = nil

        if let url = user.imageUrl {
            imageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "Profile-40")
        }
        
        daysLabel.text = "\(user.daysLeft ?? 0)"
        switch user.daysLeft {
        case 0:
            statusLabel.text = "Paid"
        default:
            statusLabel.text = "Waiting"
            statusLabel.textColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        }
    }
}

