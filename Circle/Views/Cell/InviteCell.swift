//
//  InviteCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import IQKeyboardManager


class InviteCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var label = UILabel()
    var codeLabel = UILabel()
    var inviteView = UIView()
    var viewController: CircleVC!
    var shareImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.addSubview(inviteView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayShareSheet))
        inviteView.addGestureRecognizer(tapGesture)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = contentView.frame.width
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "Invite")
        
        label.frame = CGRect(x: imageView.layer.position.x + 50, y: 10, width: 250, height: 60)
        label.numberOfLines = 4
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor  = .darkText
        label.text = "More people in your Circle \nLess money limit"
        
        inviteView.frame = CGRect(x: 30, y: label.layer.position.y + 50, width: width - 60, height: 50)
        inviteView.cornerRadius = 5.0
        inviteView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        inviteView.clipsToBounds = true
        
        codeLabel.frame = CGRect(x: 20, y: 0, width: 200, height: 50)
        codeLabel.textAlignment = .left
        codeLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        codeLabel.textColor  = .darkText

        //codeLabel.text = "Share your Circle Link"
        
        shareImageView.frame = CGRect(x: inviteView.bounds.width - 50, y: 10 , width: 30, height: 30)

        shareImageView.contentMode = .scaleAspectFit
        shareImageView.image = #imageLiteral(resourceName: "Share-20")
        
        inviteView.addSubview(codeLabel)
        inviteView.addSubview(shareImageView)

    }
    
    
    @objc func displayShareSheet() {
        let code = codeLabel.text!
        let controller = UIActivityViewController(activityItems: [code as NSString], applicationActivities: nil)
        self.parentViewController().present(controller, animated: true, completion: nil)
    }
}




