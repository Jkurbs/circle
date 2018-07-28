//
//  AddUsersCell.swift
//  Sparen
//
//  Created by Kerby Jean on 7/26/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class AddUsersCell: UICollectionViewCell {
    
    var label: UILabel!
    var shareButton: UIButton!
    var copyButton: UIButton!
    var QRButton: UIButton!

    var qrcodeImage: CIImage!
    
    var circle: Circle!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        label = UICreator.create.label("Invite some people in your circle", 17, .darkText, .center, .medium, self.contentView)
        
        shareButton = UICreator.create.button("Share", nil, .blue, .red, contentView)
        copyButton = UICreator.create.button("Copy", nil, .blue, .red, contentView)
        QRButton = UICreator.create.button("QR", nil, .blue, .red, contentView)
        
        shareButton.addTarget(self, action: #selector(shareLink), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        QRButton.addTarget(self, action: #selector(qrLink), for: .touchUpInside)
    }
    
    
    @objc func shareLink() {
        
    }
    
    @objc func copyLink() {
        
    }
    
    @objc func qrLink() {
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constrain(label, copyButton, shareButton, QRButton, contentView) { label, copyButton, shareButton, QRButton, view in
            label.top == view.top + 60
            label.height == 60
            label.width == view.width - 20
            label.centerX == view.centerX
            
            copyButton.top == label.bottom + 30
            copyButton.width == 60
            copyButton.height == 60
            copyButton.centerX == view.centerX
            
            shareButton.top == label.bottom + 30
            shareButton.width == 60
            shareButton.height == 60
            shareButton.left == view.left + 40

            QRButton.top == label.bottom + 30
            QRButton.width == 60
            QRButton.height == 60
            QRButton.right == view.right - 40
        }
    }
    
    func configure(_ circle: Circle) {
        self.circle = circle
        
        let qrCode = generateQRCode(circle.link!)
        QRButton.setImage(qrCode, for: .normal)

    }
    
    func generateQRCode(_ string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 1, y: 1)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}


