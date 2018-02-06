//
//  PendingInviteCell.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class PendingInviteCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()

        contentView.backgroundColor = .white
        
        
        layer.masksToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 2, y: 2, width: contentView.frame.width - 8, height: contentView.frame.height - 8)
        imageView.center = contentView.center
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.addSubview(imageView)
    }
    
    
    
    func configure(_ image: UIImage?) {
        imageView.image = image
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }
}

