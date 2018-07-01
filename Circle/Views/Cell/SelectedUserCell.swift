//
//  SelectedUserCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import SDWebImage
import Lottie

class SelectedUserCell: UICollectionViewCell {
    
    var statusDesc = UILabel()
    var statusLabel = UILabel()
    var daysDesc = UILabel()
    var daysLabel = UILabel()
    var layerView = UIView()
    var imageView = UIImageView()
    var nameLabel = UILabel()
    
    private var animation: LOTAnimationView?

    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //setup()
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        //self.contentView.backgroundColor = UIColor.white
        setup()        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let descColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        let color = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        let centerX = self.center.x
        
        
        imageView.frame = CGRect(x: 0, y: 25, width: 60, height: 60)
        imageView.center.x = self.center.x
        imageView.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        
        nameLabel.frame = CGRect(x: 20, y: imageView.frame.maxY + 10, width: 70, height: 20)
        nameLabel.center.x = centerX
        nameLabel.textAlignment = .center
        nameLabel.font = font
        nameLabel.textColor = color
        
        let imageViewCenterY = imageView.center.y
        
        statusDesc.frame = CGRect(x: 20, y: 15, width: 70, height: 20)
        statusDesc.center.y = imageViewCenterY
        statusDesc.textAlignment = .center
        statusDesc.text = "Status"
        statusDesc.font = font
        statusDesc.textColor = descColor
        
        statusLabel.frame = CGRect(x: 20, y: statusDesc.layer.position.y + 10, width: 70, height: 20)
        statusLabel.textAlignment = .center
        statusLabel.font = font
        statusLabel.textColor = color
        
        daysDesc.frame = CGRect(x: self.frame.maxX - 100, y: 15, width: 90, height: 20)
        daysDesc.center.y = imageViewCenterY
        daysDesc.textAlignment = .center
        daysDesc.text = "Days Left"
        daysDesc.font = font
        daysDesc.textColor = descColor
        
        daysLabel.frame = CGRect(x: self.frame.maxX - 100, y: statusDesc.layer.position.y + 10, width: 90, height: 20)
        daysLabel.textAlignment = .center
        daysLabel.font = font
        daysLabel.textColor = color
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        self.layer.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
        self.layer.mask = rectShape
    }
    
    func setup() {
        self.addSubview(statusLabel)
        self.addSubview(statusDesc)
        self.addSubview(imageView)
        self.addSubview(daysDesc)
        self.addSubview(daysLabel)
    }
    
    func configure(_ user: User) {
        
        imageView.image = nil

        if let url = user.photoUrl {
            imageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "Profile-20"), options: .highPriority, completed: nil)
            //sd_setImage(with: URL(string: url))
        }
        
        nameLabel.text = user.firstName
        daysLabel.text = "\(user.daysLeft ?? 0)"
        
        if user.daysLeft == 0 {
            statusLabel.text = "Paid"
            //statusLabel.textColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        } else {
            statusLabel.text = "Waiting"
            statusLabel.textColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        }
    }
}

