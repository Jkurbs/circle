//
//  CircleUserCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/28/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth


class CircleUserCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var view = UIView()
    
    
    var paidView = UIView()
    
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        view.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        self.cornerRadius = self.frame.width/2
        
        let height = contentView.frame.height
        let width = contentView.frame.width
        
        view.frame = CGRect(x: 0, y: 0, width: width - 3.5, height: height - 3.5)
        view.center = contentView.center
        view.cornerRadius = view.frame.width/2
        view.clipsToBounds = true
        view.borderWidth = 3.5
        view.borderColor = UIColor(white: 0.8, alpha: 1.0)
        
        imageView.frame = CGRect(x: 5.7, y: 5.7, width: 25, height: 25)
        
        imageView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = imageView.frame.width/2
        
        
        //createGradientLayer()

    }
    
    func configure(_ user: User) {
        
        if user.userId == Auth.auth().currentUser?.uid {
            
        }
        
        if user.daysLeft == 0 {
            print("zero")
            contentView.addSubview(paidView)
            createGradientLayer()
            view.borderColor = UIColor.red

        }
        
        imageView.sd_setImage(with: URL(string: user.photoUrl!))
    }
    
    func createGradientLayer() {
        
        paidView.frame = CGRect(x: contentView.frame.width - 15, y: 0, width: 20, height: 20)

        paidView.borderColor = .white
        contentView.addSubview(paidView)
        
        
        gradientLayer = CAGradientLayer()
        gradientLayer.contents = UIImage(named: "Dollar-10")?.cgImage
        gradientLayer.frame = self.paidView.bounds
        gradientLayer.cornerRadius = gradientLayer.frame.width/2
        gradientLayer.borderWidth = 1.0
        gradientLayer.borderColor = UIColor.white.cgColor
        gradientLayer.colors = [ UIColor.yellow.cgColor, UIColor(red: 243.0/255.0, green:  156.0/255.0, blue:  18.0/255.0, alpha: 1.0).cgColor, UIColor.orange.cgColor]
        self.paidView.layer.addSublayer(gradientLayer)
    }
}



class CircleIntroUserCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.frame
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(_ user: User) {
        imageView.sd_setImage(with: URL(string: user.photoUrl!))
    }
}
