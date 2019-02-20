//
//  UserInsideCell.swift
//  Sparen
//
//  Created by Kerby Jean on 9/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import SDWebImage

class UserInsideCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(imageView, contentView) { (imageView, contentView) in
            imageView.edges == contentView.edges
        }
        imageView.cornerRadius = imageView.frame.width/2
    }
    
    func configure(_ user: User) {
        imageView.sd_setImage(with: URL(string: user.imageUrl!))
    }
}
