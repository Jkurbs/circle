//
//  GenderCell.swift
//  Sparen
//
//  Created by Kerby Jean on 2/3/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {
    
    var label = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var item: AccountModelItem? {
        didSet {
            guard let item = item as? AccountViewModelPersonalItem else {
                return
            }
            label.text = item.gender
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.text = "Unspecifie"
        contentView.layer.addSublayer(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: 0, width: contentView.frame.width - 10, height: contentView.frame.height)
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
}
