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
    
    var gradientLayer: CAGradientLayer!
    
    var view = UIView()
    
    var paidImageView: UIImageView!
    
    var spinningView = SpinningView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        
        contentView.addSubview(view)
        view.addSubview(imageView)
        
        paidImageView = UIImageView(frame:CGRect(x: 0, y: contentView.frame.maxY - 15, width: 17, height: 17))
        paidImageView.center.x = contentView.center.x
        paidImageView.cornerRadius = paidImageView.frame.width/2
        
        paidImageView.borderWidth = 2
        paidImageView.layer.borderColor = UIColor.white.cgColor
        paidImageView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.bounds.width / 2
        layer.masksToBounds = true
        
        view.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - 5 , height: contentView.frame.height - 5)
        view.center = contentView.center
        view.cornerRadius = view.frame.width / 2
        
        view.layer.cornerRadius = view.bounds.width / 2
        view.borderWidth = 3.0
        view.borderColor = UIColor(white: 0.8, alpha: 1.0)
        view.backgroundColor = .white

        imageView.frame = CGRect(x: 5, y: 5, width: view.frame.width - 10, height: view.frame.height - 10)
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }

    
    func image(_ img: UIImage) {
        imageView.image = img 
    }
    
    
    func configure(_ user: User) {

        if user.photoUrl != nil {
            imageView.sd_setImage(with: URL(string: user.photoUrl!))
        }
        
        if user.daysLeft == 0 {
            contentView.addSubview(paidImageView)
            createGradientLayer()
            
            paidImageView.alpha = 1.0
            layer.borderColor = UIColor(red: 232.0/255.0, green:  126.0/255.0, blue:  4.0/255.0, alpha: 1.0).cgColor
        }
    }
    

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.paidImageView.bounds
        
        gradientLayer.colors = [ UIColor.yellow.cgColor, UIColor.red.cgColor]
        
        self.paidImageView.layer.addSublayer(gradientLayer)

        let myImage = UIImage(named: "Dollar-10")?.cgImage
        gradientLayer.contents = myImage
    }
}

