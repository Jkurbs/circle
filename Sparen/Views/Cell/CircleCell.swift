//
//  ContactsInviteCell.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit

class ContactsInviteCell: UICollectionViewCell {
    
    
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
        
        layer.masksToBounds = true
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        //imageView.cornerRadius = imageView.frame.size.width/2
    }
    
    
    
    func configure(_ contacts: Contact?) {
        imageView.image = #imageLiteral(resourceName: "two")
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.bounds.height / 2
        }
        if contacts?.imageData != nil {
            let image = UIImage(data: (contacts?.imageData)!)
            imageView.image = image
        } else {
            
        }
    }
}
