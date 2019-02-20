//
//  ProfileImageCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import Cartography
import Photos


class ProfileImageCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileImageView = UIImageView()
    var button = UIButton()
    
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
            guard let item = item as? AccountViewModelGeneralItem else {
                return
            }
            profileImageView.sd_setImage(with: URL(string: item.pictureUrl), placeholderImage: UIImage(named: "profile"))
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        contentView.backgroundColor = .white
        contentView.addSubview(profileImageView)
        contentView.addSubview(button)
        contentView.layer.addSublayer(separator)
        
        profileImageView.image = UIImage(named: "profile")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        constrain(profileImageView, button, contentView) { (profileImageView, button, contentView) in
            
            profileImageView.centerX == contentView.centerX
            profileImageView.top == contentView.top + 20
            profileImageView.height == 60
            profileImageView.width == 60
            
            button.top == profileImageView.bottom + 10
            button.width == contentView.width
            button.height == 30
        }
        

        dispatch.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(contentView.tintColor, for: .normal)
        button.addTarget(self, action: #selector(changePicture), for: .touchUpInside)
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
    
    @objc func changePicture() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.parentViewController().present(actionSheet, animated: true, completion: nil)
    }
    
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    
                }
            })
                case .restricted:  print("User do not have access to photo album.")

                case .denied: print("User has denied the permission.")
        }
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.parentViewController().present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.parentViewController().present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentViewController().dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("GOT IMAGE")
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.profileImageView.image = pickedImage
        self.parentViewController().dismiss(animated: true, completion: nil)
    }
}

// UserName Cell

class UsernameCell: UITableViewCell {
    
    var textField = TextFieldRect()
    
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
            guard let item = item as? AccountViewModelGeneralItem else {
                return
            }
            textField.text = item.username
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        contentView.layer.addSublayer(separator)
        
        textField.autocorrectionType = .no

        textField.tag = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        textField.frame = contentView.frame
        textField.placeholder = "Enter a username"
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
}

// DisplayName Cell

class DisplayNameCell: UITableViewCell {
    
    var textField = TextFieldRect()
    
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
            guard let item = item as? AccountViewModelGeneralItem else {
                return
            }
            
            textField.text = item.name

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        textField.placeholder = "Full name"
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        contentView.layer.addSublayer(separator)

        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        textField.frame = contentView.frame
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
}

// Email Cell

class EmailCell: UITableViewCell {
    
    var textField = TextFieldRect()
    
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
            textField.text = item.email
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        textField.placeholder = "Email"
        textField.autocorrectionType = .no
        contentView.layer.addSublayer(separator)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = contentView.frame
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
}


// Phone Cell

class PhoneCell: UITableViewCell {
    
    var textField = TextFieldRect()
    
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
            textField.text = item.phone
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.placeholder = "Phone"
        contentView.layer.addSublayer(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = contentView.frame
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)

    }
}

