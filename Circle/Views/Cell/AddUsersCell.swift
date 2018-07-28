//
//  AddUsersCell.swift
//  Sparen
//
//  Created by Kerby Jean on 7/26/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import SDWebImage

class AddUsersCell: UICollectionViewCell {
    
    var label: UILabel!
    var shareImageView: UIImageView!
    var copyImageView: UIImageView!
    var qrImageView: UIImageView!

    var qrcodeImage: CIImage!
    
    var circle: Circle!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        label = UICreator.create.label("Invite some people in your circle", 17, .darkText, .center, .medium, self.contentView)
        
        shareImageView = UICreator.create.imageView(nil, contentView)
        copyImageView = UICreator.create.imageView(nil, contentView)
        qrImageView = UICreator.create.imageView(nil, contentView)
        
        
        qrImageView.isUserInteractionEnabled = true
        qrImageView.contentMode = .scaleAspectFill
        //shareButton.addTarget(self, action: #selector(shareLink), for: .touchUpInside)
        //copyImageView.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qrLink))
        qrImageView.addGestureRecognizer(tapGesture)
        //addTarget(self, action: #selector(qrLink), for: .touchUpInside)
        
        constrain(self.label, self.copyImageView, self.shareImageView, self.qrImageView, self.contentView) { label, copyImageView, shareButton, QRButton, view in
                label.top == view.top + 60
                label.height == 60
                label.width == view.width - 20
                label.centerX == view.centerX
                
                copyImageView.top == label.bottom + 10
                copyImageView.width == 60
                copyImageView.height == 60
                copyImageView.centerX == view.centerX
                
                shareButton.top == label.bottom + 10
                shareButton.width == 60
                shareButton.height == 60
                shareButton.left == view.left + 40
                
                QRButton.top == label.bottom + 10
                QRButton.width == 60
                QRButton.height == 60
                QRButton.right == view.right - 40
        }
        
        dispatch.async {
            self.shareImageView.cornerRadius = 10
            self.copyImageView.cornerRadius = 10
            self.qrImageView.cornerRadius = 10
        }
    }
    
    
    @objc func shareLink() {
        
    }
    
    @objc func copyLink() {
        
    }
    
    @objc func qrLink() {
        
    }
    
    
    override func layoutSubviews() {
        //super.layoutSubviews()
  
  
    }
    
    func configure(_ circle: Circle) {
        self.circle = circle
        
        let qrCode = generateQRCode(circle.link!)
        qrImageView.image = qrCode

    }
    
    func generateQRCode(_ string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            guard let qrCodeImage = filter.outputImage else {return nil}
            
            let scaleX = 60 / qrCodeImage.extent.size.width
            let scaleY = 60 / qrCodeImage.extent.size.height

            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}

class InsidersCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var nameLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel = UICreator.create.label(nil, 17, .darkText, .center, .medium, self.contentView)
        imageView = UICreator.create.imageView(nil, contentView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(self.imageView, self.nameLabel, self.contentView) {imageView, nameLabel, view in
            imageView.left == view.left + 20
            imageView.centerY == view.centerY
            imageView.width == 40
            imageView.height == 40
            
            nameLabel.left == imageView.right + 20
            nameLabel.centerY == view.centerY
        }
        
        dispatch.async {
            self.imageView.cornerRadius = self.imageView.frame.width/2 
        }
    }
    
    func configure(_ user: User) {
        if let url = URL(string: user.imageUrl!) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        nameLabel.text = "\(user.firstName ?? "")"
    }
}

class InsidersHeaderCell: UICollectionViewCell {
    
    var label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        label = UICreator.create.label(nil, 17, .darkText, .left, .medium, self.contentView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constrain(self.label, self.contentView) {label, view in
            label.left == view.left + 20
            label.width == view.width
            label.height == view.height
        }
    }
    
    func configure(_ circle: Circle) {
        if circle.activated == true {
            label.text = "Insiders"
        }
    }
    
}


