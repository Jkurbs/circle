//
//  PushNotificationCell.swift2//  SparenDARH DSTRJH
//
//  Created by Kerby Jean on 8/12/18.
//

import UIKit
import Cartography

class PushNotificationCell: UITableViewCell {
    
    var label: UILabel!
    var pushSwitch = UISwitch()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UICreator.create.label("Push notification", 16, .darkGray, .left, .regular, contentView)
        contentView.addSubview(pushSwitch)
        pushSwitch.isOn = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        constrain(label, pushSwitch, contentView) { label, pushSwitch, contentView in
            label.left == contentView.left + 20
            label.width == contentView.width - 60
            label.height == contentView.height
            pushSwitch.right == contentView.right - 20
        }
    }
}
