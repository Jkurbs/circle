//
//  ReadyCell.swift
//  Sparen
//
//  Created by Kerby Jean on 8/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography

class ReadyCell: UICollectionViewCell {

    var label: UILabel!
    var readyButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UICreator.create.label("Let everyone know you are ready", 17, .darkText, .center, .regular, contentView)
        readyButton = UICreator.create.button("Ready", nil, .sparenColor, nil, contentView)
        readyButton.addTarget(self, action: #selector(ready), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, readyButton, contentView) { (label, readyButton, contentView) in
            label.center == contentView.center
            label.height == 30
            
            readyButton.top == label.bottom
            readyButton.left == label.left
            readyButton.height == label.height
            readyButton.centerX == contentView.centerX
        }
    }
    
    @objc func ready() {
        
        DataService.call.userReady { (success, error) in
            if !success {
                print("error", error?.localizedDescription)
            } else {
                print("success")
            }
        }
        
    }
    
    func configure( _ circle: Circle) {

        
    }
}
