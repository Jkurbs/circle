//
//  SettingPaymentCell.swift
//  Sparen
//
//  Created by Kerby Jean on 2/11/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import SDWebImage

class SettingPaymentCell: UITableViewCell {
    
    
    var cardImageView: UIImageView!
    var numberLabel: UILabel!
    var expLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cardImageView = UICreator.create.imageView(nil, contentView)
        numberLabel = UICreator.create.label("", 17, .darkText, .left, .regular, contentView)
        expLabel = UICreator.create.label("", 14, .darkText, .left, .regular, contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        constrain(cardImageView, numberLabel, expLabel, contentView) { (cardImageView, numberLabel, expLabel, contentView) in
            
            cardImageView.centerY == contentView.centerY
            cardImageView.left == contentView.left + 10
            cardImageView.height == 35
            cardImageView.width == 45
            
            numberLabel.top == cardImageView.top
            numberLabel.left == cardImageView.right + 10
            expLabel.top == numberLabel.bottom
            expLabel.left == cardImageView.right + 10
        }
        
        dispatch.async {
            self.cardImageView.cornerRadius = 5
        }
    }
    
    
    func configure( _ card: Card) {
        
        switch card.type {
        case "Visa":
            cardImageView.image = UIImage(named: "Visa")
        case "Mastercard":
            cardImageView.image = UIImage(named: "Mastercard")
        default:
            print("")
        }
        
        numberLabel.text = card.type! + " *" + card.last4!
        expLabel.text = "Expires \(card.expDate ?? "")"
    
    }
}
