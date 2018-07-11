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
import Cartography


class CircleUserCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var view = UIView()
    
    var paidView = UIView()
    
    var gradientLayer: CAGradientLayer!
    
    var userViewModel: UserCellViewModel! {
        didSet {
            imageView.sd_setImage(with: URL(string: userViewModel.imageUrl))
            
            if userViewModel.payed == true {
                contentView.addSubview(paidView)
                createGradientLayer()
            } else {
                paidView.removeFromSuperview()
            }
        }
    }
    
    

    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
        imageView = UICreator.create.imageView(nil, contentView)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initLayout()

    }
    
    func initLayout() {
        dispatch.async {
            self.imageView.cornerRadius = self.imageView.frame.width/2
            
            constrain(self.imageView, self.view, self.contentView) { imageView, view, cView in
                view.width == cView.width - 3.5
                view.height == cView.width - 3.5
                view.center == cView.center
                
                imageView.width == view.width - 12
                imageView.height == view.height - 12
                imageView.center == view.center
            }
            
            
            self.backgroundColor = .white
            self.cornerRadius = self.frame.size.width/2
            
            self.view.clipsToBounds = true
            self.view.borderWidth = 3.5
            self.view.borderColor = UIColor(white: 0.8, alpha: 1.0)
            
            self.view.cornerRadius = self.view.frame.size.width/2
            
            self.imageView.layer.masksToBounds = true
            
            self.imageView.clipsToBounds = true
            self.imageView.cornerRadius = self.imageView.frame.width/2
        }
    }

    
    private func createGradientLayer() {
        
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
    
    
    func animate(_ isSelected: Bool) {
        
        if isSelected == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (completion) in
                
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (completion) in
                
            })
        }
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
        imageView.sd_setImage(with: URL(string: user.imageUrl!))
    }
}
