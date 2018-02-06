//
//  InfoCell.swift
//  Circle
//
//  Created by Kerby Jean on 1/31/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    let headline                = Headline()
    let subhead                 = Subhead()
    let footnote                = Footnote()
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setup() {
        contentView.addSubview(headline)
        headline.text = "Add your phone number"
        
        contentView.addSubview(subhead)
        subhead.text = "You'll use your phone number when you login"

    }
    
    
    

override func layoutSubviews() {
    let padding: CGFloat = 25
    let width: CGFloat = self.contentView.bounds.width - (padding * 2)  - 20
    let y: CGFloat =  40
    let centerX = contentView.center.x

    headline.frame = CGRect(x: 0, y: y , width: width, height: 60)
    headline.center.x = centerX

    subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 60)
    subhead.center.x = centerX
   }
}


