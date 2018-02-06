//
//  ContactCell.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import MessageUI

class ContactCell: UICollectionViewCell, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    var contact: Contact?
    
    fileprivate let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor(white: 7, alpha: 1.0)
        return view
    }()
    
    
    
    
    override func layoutSubviews() {
        label.frame = profileImageView.bounds
        profileImageView.addSubview(label)
//        button.frame = CGRect(x: 0, y: contentView.frame.maxY, width: self.contentView.frame.width, height: 60)
//        contentView.addSubview(button)
    }
        
    @IBAction func inviteAction(_ sender: UIButton) {
        
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
         controller.dismiss(animated: true, completion: nil)
    }

    
    func configure(_ contact: Contact) {
        self.contact = contact
        
        if contact.imageData == nil {
            profileImageView.image = nil
    
            label.isHidden = false
            let letter = contact.givenName?.first
            if letter != nil {
               label.text = "\(String(describing: letter!))"
            }
        } else {
             label.isHidden = true
            let imageData = contact.imageData
            let image = UIImage(data: imageData!)
            profileImageView.image = image
        }

        
        if let phoneNumber = contact.phoneNumber, let givenName = contact.givenName {
            nameLabel.text = givenName
            emailLabel.text = phoneNumber
            if phoneNumber.isEmpty {
                emailLabel.text = contact.emailAddress
            }
        }
    }
}

