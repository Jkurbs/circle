//
//  PageCell.swift
//  Sparen
//
//  Created by Kerby Jean on 2/12/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography


class PageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    var startedButton: UIButton!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        
        imageView = UICreator.create.imageView(UIImage(named:"sparen"), contentView)
        imageView.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = contentView.frame
        
        label = UICreator.create.label("", 16, .darkText, .center, .regular, contentView)
        label.sizeToFit()
        
        startedButton = UICreator.create.button("Get Started", nil, .sparenColor, UIColor(white: 0.9, alpha: 1.0), contentView)
        startedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startedButton.isHidden = true
        startedButton.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        
    }
    
    @objc func getStarted() {
        let nav = UINavigationController(rootViewController: EmailPhoneVC())
        UserDefaults.standard.set(true, forKey: "NewUser")
        UserDefaults.standard.synchronize()
        self.parentViewController().present(nav, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(imageView, label, startedButton, contentView) { (imageView, label, startedButton, contentView) in
            imageView.center == contentView.center
            imageView.width == contentView.width
            imageView.height == contentView.width
            label.centerX == contentView.centerX
            label.top == contentView.top + 100
            label.width == contentView.width - 50
            
            startedButton.centerX == contentView.centerX
            startedButton.height == 50
            startedButton.width == 140
            startedButton.bottom == contentView.bottom - 80
        }
    }
    
    func configure(_ title: String, _ image: UIImage) {
        label.text = title
        imageView.image = image
    }
}
