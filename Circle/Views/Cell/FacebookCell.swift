//
//  FacebookCell.swift
//  Circle
//
//  Created by Kerby Jean on 1/24/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class FacebookCell: UICollectionViewCell {
    
    var headline = Headline()
    var subhead = Subhead()
    var facebookConnect = LogButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headline.text = "Invite Loved ones"
        subhead.text = "Invite at least five trustworthy person"
        facebookConnect.setTitle("Access Contacts", for: .normal)
        facebookConnect.addTarget(self, action: #selector(facebookInvite), for: .touchUpInside)
        contentView.addSubview(headline)
        contentView.addSubview(subhead)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        
        let padding: CGFloat = 25
        let width = contentView.bounds.width - (padding * 2)  - 20
        let y: CGFloat =  40
        let centerX = contentView.center.x
        
        headline.frame = CGRect(x: 0, y: y, width: width, height: 60.0)
        headline.center.x = centerX
        
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 60)
        subhead.center.x = centerX
        
        facebookConnect.frame = CGRect(x: 0, y: subhead.layer.position.y + 50, width: width, height: 50)
        facebookConnect.center.x = centerX
    }
    
    @objc func facebookInvite() {
        print("FACEBOOK INVITE")
    }
}
