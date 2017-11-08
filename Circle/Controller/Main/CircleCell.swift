//
//  CircleCell.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage

class CircleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        layer.masksToBounds = true
        layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    }
    
    func configure(_ user: User?) {
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.bounds.height / 2
        }
        if user?.photoUrl != nil {
            print("CONFIGURE")
            imageView?.sd_setImage(with: URL(string: (user?.photoUrl!)!))
        }
    }
}
