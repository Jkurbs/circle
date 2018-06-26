//
//  SettingsView.swift
//  Circle
//
//  Created by Kerby Jean on 2/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI

class SettingsCell: UICollectionViewCell, MFMessageComposeViewControllerDelegate {
    
    var settingbutton = UIButton()
    var inviteButton = UIButton()
    var circleLink = ""
    
    let label = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.yellow.cgColor,
            UIColor.brown.cgColor
        ]
        return layer
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
     }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.size.height)
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        label.textAlignment = .center

        self.addSubview(label)
        
        self.backgroundColor = .white
        
        inviteButton.frame = CGRect(x: 3, y: 0, width: 45, height: 45)
        inviteButton.setImage(#imageLiteral(resourceName: "Add-20"), for: .normal)
        self.addSubview(inviteButton)
        inviteButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        
        
        settingbutton.frame = CGRect(x: self.bounds.width - 45, y: 0, width: 45, height: 45)
        settingbutton.setImage(#imageLiteral(resourceName: "Menu-20"), for: .normal)
        self.addSubview(settingbutton)
        settingbutton.addTarget(self, action: #selector(settings), for: .touchUpInside)
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
    }
    
    
    @objc func settings() {
        
        let vc = SettingsVC()
        
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @objc func add() {
        
        guard let link = self.circleLink as? String else {
            return
        }
            
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Hey come join my circle to save money💰💰 \n\(link)";
        messageVC.recipients = [""]
        messageVC.messageComposeDelegate = self;
        
        self.parentViewController().present(messageVC, animated: true, completion: nil)
    }
    
    
    func configure(_ user: User, _ firstName: String) {
        label.text = ""
        if user.userId == Auth.auth().currentUser?.uid {
            label.text = "Dashboard"
        } else {
            label.text = firstName
        }
    }
    

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case .cancelled:
                self.parentViewController().dismiss(animated: true, completion: nil)
            case .failed:
                self.parentViewController().dismiss(animated: true, completion: nil)
            case .sent:
                self.parentViewController().dismiss(animated: true, completion: nil)
            default:
                break;
        }
    }
}
