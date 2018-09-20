//
//  CircleInsightCell.swift
//  Circle
//
//  Created by Kerby Jean on 4/9/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class CircleInsightCell: UICollectionViewCell {
    
    var endTimeLabel = transformLabel()
    var endDescLabel = transformLabel()
    
    var nextPayoutLabel =  transformLabel()
    var nextDescLabel = transformLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(endTimeLabel)
        contentView.addSubview(endDescLabel)
        contentView.addSubview(nextPayoutLabel)
        contentView.addSubview(nextDescLabel)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        
        
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        let descColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)

        nextPayoutLabel.textColor = color
        endTimeLabel.textColor = color
        
        nextPayoutLabel.font = font
        endTimeLabel.font = font
        
        endTimeLabel.frame = CGRect(x: 20, y: 5, width: width / 3, height: 40)
        endDescLabel.frame = CGRect(x: 20, y: endTimeLabel.frame.maxY, width: width / 3 , height: 20)
        endDescLabel.font = font
        endDescLabel.textColor = descColor

        endDescLabel.text = "Total"
  
        nextPayoutLabel.frame = CGRect(x: self.frame.maxX - 150, y: 5, width: width / 3, height: 40)
        nextDescLabel.frame = CGRect(x: self.frame.maxX - 150, y: nextPayoutLabel.frame.maxY, width: width / 3 , height: 20)
        nextDescLabel.font = font
        nextDescLabel.text = "Left"
        nextDescLabel.textColor = descColor

        endTimeLabel.textAlignment = .center
        endDescLabel.textAlignment = .center
        nextPayoutLabel.textAlignment = .center
        nextDescLabel.textAlignment = .center
    }
    
    
    func configure(_ insight: Insight) {
        let daysTotalLeft = insight.daysTotal ?? 0
        let daysBeforeNextPayout = insight.daysLeft ?? 0
        self.endTimeLabel.text = "\(daysTotalLeft) days"
        self.nextPayoutLabel.text = "\(daysBeforeNextPayout) days"
    }
}





class OrderCell: UITableViewCell {
    
    var descAmountLabel = UILabel()
    var  amountLabel = UILabel()
    
    var slider = UISlider()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height =  self.frame.height
        
        descAmountLabel.frame = CGRect(x: 20, y: 0, width: 80, height: height)
        slider.frame = CGRect(x: descAmountLabel.frame.maxX + 5, y: 0, width: self.frame.width - 180, height: height)
        amountLabel.frame = CGRect(x: slider.frame.maxX + 10, y: 0, width: 80, height: height)

        let font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        descAmountLabel.font = font
        amountLabel.font = font
        
        descAmountLabel.text = "Total amount"
        
        slider.minimumValue = 1000
        slider.maximumValue = 5000
        slider.addTarget(self, action: #selector(slide), for: .valueChanged)
        
        self.addSubview(descAmountLabel)
        self.addSubview(slider)
        self.addSubview(amountLabel)
        
    }

    @objc func slide(_ sender: UISlider) {
        amountLabel.text = "\(Int(sender.value))$"
    }
    

    
    func configure(_ totalAmount: Int) {
         slider.value = Float(totalAmount)
         amountLabel.text = "\(Float(totalAmount))$"
    }
}


class WeeklyPaymentCell: UITableViewCell {
    
    var descAmountLabel = UILabel()
    var  amountLabel = UILabel()
    
    var slider = UISlider()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height =  self.frame.height
        
        descAmountLabel.frame = CGRect(x: 20, y: 0, width: 80, height: height)
        slider.frame = CGRect(x: descAmountLabel.frame.maxX + 5, y: 0, width: self.frame.width - 180, height: height)
        amountLabel.frame = CGRect(x: slider.frame.maxX + 10, y: 0, width: 80, height: height)
        
        let font =  UIFont.systemFont(ofSize: 12, weight: .regular)
        
        descAmountLabel.font = font
        amountLabel.font = font
        
        descAmountLabel.text = "Weekly Payment"
        
        slider.minimumValue = 20
        slider.maximumValue = 1000
        slider.addTarget(self, action: #selector(slide), for: .valueChanged)
        
        self.addSubview(descAmountLabel)
        self.addSubview(slider)
        self.addSubview(amountLabel)
        
    }
    
    @objc func slide(_ sender: UISlider) {
        amountLabel.text = "\(Int(sender.value))$"
    }
    
    
    
    func configure(_ totalAmount: Int) {
        slider.value = Float(totalAmount)
        amountLabel.text = "\(Float(totalAmount))$"
    }
}



class SetupCircleCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        label.text = "Setup Circle"
        label.textColor = self.tintColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        self.addSubview(label)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width
        label.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
    }
}

class UpdateCircleCell: UITableViewCell {
    
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .red
        let width = self.frame.width
        
        label.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        label.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        label.text = "Update Circle"
        label.textColor = self.tintColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        self.addSubview(label)
    }
}


class CircleSettings: UITableViewCell {
    
    var label = UILabel()
    var stack = UIStackView()
    var alertImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        label.backgroundColor = UIColor.textFieldOpaqueBackgroundColor
        label.text = "Settings"
        label.textColor = self.tintColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        
        alertImageView.image = #imageLiteral(resourceName: "Alert-10")
        alertImageView.contentMode = .scaleAspectFit
        alertImageView.clipsToBounds = true

        self.addSubview(label)
        //self.addSubview(alertImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width
        let height = self.frame.height
        
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.center.x = self.center.x
        
        alertImageView.frame = CGRect(x: label.frame.maxX + 5, y: 20, width: 10, height: 10)
    }
}
 
