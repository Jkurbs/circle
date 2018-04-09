//
//  PendingInviteCell.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth

class PendingInviteCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return view
    }()
    
    var view = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.bounds.width / 2
        layer.masksToBounds = true
        layer.borderWidth = 2.5
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        
        imageView.frame = CGRect(x: 2, y: 2, width: contentView.frame.width - 8, height: contentView.frame.height - 8)
        imageView.center = contentView.center
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.backgroundColor = UIColor.textFieldBackgroundColor
        
        contentView.addSubview(imageView)
        
        view.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        view.cornerRadius = view.frame.width / 2
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.6).cgColor
    }
    
    
    
    
    func isSelected() {
         self.layer.borderColor = UIColor.blueColor.cgColor
    }
    
    
    
    
    func image(_ img: UIImage) {
        imageView.image = img 
    }
    
    
    func configure(_ user: User?) {
    
        
        if user!.userId == Auth.auth().currentUser!.uid {
            isSelected()
        }
        
        if user?.activated != true {
            imageView.layer.addSublayer(view)
        }
        

        if user?.photoUrl != nil {
            view.position = imageView.center
            imageView.sd_setImage(with: URL(string: user!.photoUrl!))
        }
    }
}

