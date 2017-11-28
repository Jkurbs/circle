//
//  CircleInfoCell.swift
//  Circle
//
//  Created by Kerby Jean on 11/8/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit

class CircleInfoCell: UICollectionViewCell {

    let nextDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize:18)
        view.textColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        view.text = "Next Payout"
        return view
    }()
    
    let nextLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 26)
        view.text = "20 days"
        return view
    }()
    
    
    let descriptionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = UIFont.boldSystemFont(ofSize:18)
        view.textColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        view.text = "Circle ends"
        return view
    }()
    
    let timeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = UIFont.boldSystemFont(ofSize:26)
        view.text = "40 days"
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(nextDescriptionLabel)
        self.contentView.addSubview(nextLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(timeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.contentView.frame.width/2
        let height: CGFloat = 50.0
        
        nextDescriptionLabel.frame = CGRect(x: 20, y: 20, width: width, height: height)
        nextLabel.frame = CGRect(x: 20, y: nextDescriptionLabel.layer.position.y, width: width, height: height)
        descriptionLabel.frame = CGRect(x: self.contentView.bounds.width - width - 20, y: 20, width: width, height: height)
        timeLabel.frame = CGRect(x: self.contentView.bounds.width - width - 20, y: descriptionLabel.layer.position.y, width: width, height: height)
        
    }

    
    func configure(nextPayout: String) {
        nextLabel.text = "\(nextPayout)"
    }
}






