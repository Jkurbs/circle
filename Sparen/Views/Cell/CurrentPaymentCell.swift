//
//  CurrentPaymentCell.swift
//  Sparen
//
//  Created by Kerby Jean on 9/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import Cartography
import SDWebImage

class CurrentPaymentCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var last4Label: UILabel!
    var descLabel: UILabel!
    
    
    var titleLabel: UILabel!
    var button: UIButton!
    var pulse = Pulsator()
    
    var members: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UICreator.create.imageView(nil, contentView)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        
        imageView.isHidden = true
        
        last4Label = UICreator.create.label("", 16, .darkText, .left, .medium, contentView)
        
        titleLabel = UICreator.create.label("Payment Method", 17, .darkText, .left, .medium, contentView)
        button = UICreator.create.button("Add a debit card", nil, contentView.tintColor, nil, contentView)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addDebit), for: .touchUpInside)
        pulse.numPulse = 2
        pulse.radius = 30.0
        pulse.backgroundColor = UIColor.sparenColor.cgColor
        pulse.start()
        pulse.position = CGPoint(x: contentView.frame.width - 40, y: contentView.center.y)
        
        descLabel = UICreator.create.label("Add a payment method before the activation time", 14, .darkGray, .left, .regular, contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(imageView, last4Label, titleLabel, descLabel, button, contentView) { (imageView, last4Label, titleLabel, descLabel, button, contentView) in

            titleLabel.left == contentView.left + 20
            titleLabel.top == contentView.top + 10
            titleLabel.height == 30
            
            button.top == titleLabel.bottom + 5
            button.left == contentView.left + 20
            button.height == titleLabel.height
            
            imageView.top == titleLabel.bottom + 15
            imageView.left == contentView.left + 20
            imageView.width == 40
            imageView.height == 40
            
            last4Label.left == imageView.right + 10
            last4Label.centerY == imageView.centerY
            last4Label.height == 30
            
            descLabel.top == button.bottom + 30
            descLabel.width == contentView.width - 20
            descLabel.left == contentView.left + 20
        }
    }
    
    @objc func addDebit() {
        let vc = PaymentsVC()
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func configure(_ card: Card?) {

        self.button.isHidden = true
        imageView.isHidden = false
        descLabel.isHidden = true 
        self.imageView.sd_setImage(with: URL(string: card?.imageUrl ?? ""), completed: nil)
        self.last4Label.text = "*****\(card?.last4 ?? "")"
    }
}


class SettingPaymentCell: UICollectionViewCell {
    
    
    var brandImageView: UIImageView!
    var last4Label: UILabel!
    
    var titleLabel: UILabel!
    var pulse = Pulsator()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        brandImageView = UICreator.create.imageView(nil, contentView)
        brandImageView.contentMode = .scaleAspectFit
        brandImageView.backgroundColor = .white
        last4Label = UICreator.create.label("", 16, .darkText, .left, .medium, contentView)
        
        titleLabel = UICreator.create.label("Payment Method", 17, .darkText, .left, .medium, contentView)
        pulse.numPulse = 2
        pulse.radius = 30.0
        pulse.backgroundColor = UIColor.sparenColor.cgColor
        pulse.start()
        pulse.position = CGPoint(x: contentView.frame.width - 40, y: contentView.center.y)
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(brandImageView, last4Label, titleLabel, contentView) { (imageView, last4Label, titleLabel, contentView) in
            
            titleLabel.left == contentView.left + 20
            titleLabel.top == contentView.top + 10
            titleLabel.height == 30
            
            imageView.top == titleLabel.bottom + 5
            imageView.left == contentView.left + 20
            imageView.width == 40
            imageView.height == 40
            
            last4Label.left == imageView.right + 10
            last4Label.centerY == imageView.centerY
            last4Label.height == 30
        }
    }
    
    @objc func addDebit() {
        let vc = PaymentsVC()
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
     func configure(_ card: Card) {
                
        self.brandImageView.sd_setImage(with: URL(string: card.imageUrl ?? ""), completed: nil)
        self.last4Label.text = "*****\(card.last4 ?? "")"
        
    }
}



class AddCardCell: UICollectionViewCell {
    
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .red
        
        button = UICreator.create.button("Add new payment method", nil, UIColor.red, nil, contentView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(button, contentView) { (button, contentView) in
            
            button.edges == contentView.edges
        }
    }
    
    @objc func addDebit() {
        let vc = PaymentsVC()
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    func configure(_ title: String) {
        button.setTitle(title, for: .normal)
    }
}
