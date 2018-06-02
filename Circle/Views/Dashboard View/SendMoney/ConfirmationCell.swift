//
//  ConfirmationCell.swift
//  Circle
//
//  Created by Kerby Jean on 3/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ConfirmationCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var iconImageView = UIImageView()
    var descriptionLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        iconImageView.contentMode = .scaleAspectFit
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.addSubview(titleLabel)
        self.addSubview(iconImageView)
        self.addSubview(descriptionLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        let height = self.frame.height
        
        titleLabel.frame = CGRect(x: 40, y: 10, width: 100, height: height)
        iconImageView.frame = CGRect(x: 55, y: 15, width: 20, height: 20)
        descriptionLabel.frame = CGRect(x: self.titleLabel.frame.maxX + 5, y: 5, width: width - 60, height: height)
        
    }
}
