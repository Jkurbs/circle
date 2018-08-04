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
import Cartography

class SettingsCell: UICollectionViewCell, MFMessageComposeViewControllerDelegate {
    
    var settingButton: UIButton!
    var inviteButton: UIButton!
    var circleLink = ""
    var user: User!
    
    var label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        
        label = UICreator.create.label(nil, 17, .darkerGray, .center, .semibold, contentView)
        
        inviteButton = UICreator.create.button(nil, #imageLiteral(resourceName: "Add-20"), nil, nil, contentView)
        inviteButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        settingButton = UICreator.create.button(nil, #imageLiteral(resourceName: "Menu-20"), nil, nil, contentView)
        settingButton.addTarget(self, action: #selector(settings), for: .touchUpInside)
     }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, inviteButton, settingButton, contentView) { label, inviteButton, settingbutton, view in
            label.edges == view.edges
            inviteButton.width == 45
            inviteButton.height == 45
            settingbutton.width == 45
            settingbutton.height == 45
            settingbutton.right == view.right
        }
    }
    
    
    @objc func settings() {
        let vc = SettingsVC()
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func add() {
//
//        let vc = InviteVC()
//        self.parentViewController().navigationController?.pushViewController(vc, animated: true)

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
        self.user = user
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
        }
    }
}
