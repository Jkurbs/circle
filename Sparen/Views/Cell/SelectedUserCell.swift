//
//  SelectedUserCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography

class SelectedUserCell: UICollectionViewCell {
    
    var statusDesc: UILabel!
    var statusLabel: UILabel!
    var daysDesc: UILabel!
    var daysLabel: UILabel!
    var layerView: UIView!
    var imageView =  UIImageView()
    var nameLabel: UILabel!
    var circleView = CircleView() 
    
    var view = UIView()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        
        view.backgroundColor = .white
        view.layer.addShadow()
        view.layer.roundCorners(radius: 10)
        contentView.addSubview(view)
        
        circleView.endThumbStrokeColor = .sparenColor
        circleView.lineWidth = 4.0
        circleView.backtrackLineWidth = 3.5
        view.addSubview(circleView)
        imageView = UICreator.create.imageView(nil, circleView)

        
        statusDesc = UICreator.create.label("Balance", 15, .darkerGray, .center, .semibold, view)
        statusLabel = UICreator.create.label("$0", 14 , .lighterGray, .center, .regular , view)
        daysDesc = UICreator.create.label("Days left", 15, .darkerGray, .center, .semibold, view)
        daysLabel = UICreator.create.label(" 0", 14, .lighterGray, .center, .regular, view)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(view, circleView, imageView, statusLabel, statusDesc, daysLabel, daysDesc, contentView) {view, circleView, imageView, statusLabel, statusDesc, daysLabel, daysDesc, contentView in
            
            view.width == contentView.width - 20
            view.height == contentView.height - 20
            view.center == contentView.center
            
            circleView.centerX == view.centerX
            circleView.top == view.top + 10
            circleView.width == 80
            circleView.height == 80
            
            imageView.center == circleView.center
            imageView.width == circleView.width - 20
            imageView.height == circleView.height - 20
            
            statusLabel.height == 20
            statusLabel.top == imageView.bottom + 20
            statusLabel.left == contentView.left + 80

            statusDesc.height == 20
            statusDesc.top == statusLabel.bottom
            statusDesc.centerX == statusLabel.centerX

            daysLabel.top == imageView.bottom + 20
            daysLabel.right == view.right - 80
            
            daysDesc.height == 20
            daysDesc.top == daysLabel.bottom
            daysDesc.centerX == daysLabel.centerX
        }

        dispatch.async {
            self.imageView.clipsToBounds = true
            self.imageView.cornerRadius = self.imageView.frame.width / 2
        }
    }

    
    func configure(_ user: User) {

        imageView.image = nil
        
        let daysTotal = user.daysTotal ?? 0
        let daysLeft = user.daysLeft ?? 0
        
        let daysPassed = daysTotal - daysLeft
        
        self.circleView.maximumValue = CGFloat(daysTotal)
        self.circleView.endPointValue = CGFloat(daysPassed)
        
        daysLabel.text = "\(daysLeft)"
        
        if let url = user.imageUrl {
            imageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "Profile-40")
        }        
    }
}


// MARK: Data Cell

class SelectedUserDataCell: UICollectionViewCell {
    
    
    var statusView = UIView()
    var daysView = UIView()
    
    var statusDesc: UILabel!
    var statusLabel: UILabel!
    var daysDesc: UILabel!
    var daysLabel: UILabel!
    
    var view = UIView()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        view.backgroundColor = .white
        view.shadowRadius = 5.0
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.shadowOpacity = 0.2
        contentView.addSubview(view)
        
        statusDesc = UICreator.create.label("To start", 12, .lighterGray, .center, .regular, view)
        statusLabel = UICreator.create.label("Ready", 16, .darkerGray, .center, .semibold, view)
        daysDesc = UICreator.create.label("Circle", 12, .lighterGray, .center, .regular, view)
        daysLabel = UICreator.create.label(" 0", 16, .darkerGray, .center, .semibold, view)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(view, statusLabel, statusDesc, daysLabel, daysDesc, contentView) {view, statusLabel, statusDesc, daysLabel, daysDesc, contentView in
            
            view.width == contentView.width - 20
            view.height == contentView.height
            view.center == contentView.center
            
            statusLabel.top == view.top + 10
            statusLabel.left == view.left + 80
            
            statusDesc.height == view.height/2
            statusDesc.top == statusLabel.bottom
            statusDesc.left == view.left + 80
            statusDesc.centerX == statusLabel.centerX
            
            daysLabel.top == view.top + 10
            daysLabel.right == view.right - 80
            daysDesc.height == view.height/2
            daysDesc.top == daysLabel.bottom
            daysDesc.right == view.right - 80
            daysDesc.centerX == daysLabel.centerX
        }
        
        dispatch.async {
//            self.view.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        }
    }
    
    
    func configure(_ user: User) {
        if user.circle == "" {
              daysLabel.text = "0"
              daysDesc.text = "Circle"
        } else {
            daysDesc.text = "DaysLeft"
            daysLabel.text = "\(user.daysLeft ?? 0)"
        }
    }
}



