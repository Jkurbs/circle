//
//  ProfileImageCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ProfileImageCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView = UIImageView()
    var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(button)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.center.x = contentView.center.x
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        button.frame = CGRect(x: 0, y: contentView.frame.height - 20, width: contentView.frame.width, height: 20)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(contentView.tintColor, for: .normal)
        button.addTarget(self, action: #selector(changePicture), for: .touchUpInside)
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        } else {
            print("Something went wrong")
        }
        self.parentViewController().dismiss(animated: true, completion: nil)
    }
}


// UserName Cell

class UserNameCell: UICollectionViewCell {
    
    var label = UILabel()
    var textField = TextFieldRect()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 20, y: 0, width: contentView.frame.width, height: 30)
        label.textColor = .gray
        label.text = "Username"
        
        textField.frame = CGRect(x: 10, y: label.layer.position.y + 5, width: contentView.frame.width, height: contentView.frame.height - 30)
        textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textField.textColor = .gray
        textField.placeholder = "Enter a username"
    }
}

// DisplayName Cell

class DisplayNameCell: UICollectionViewCell {
    
    var label = UILabel()
    var textField = TextFieldRect()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 20, y: 0, width: contentView.frame.width, height: 30)
        label.textColor = .gray
        label.text = "Name"
        
        textField.frame = CGRect(x: 10, y: label.layer.position.y + 5, width: contentView.frame.width, height: contentView.frame.height - 30)
        textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textField.textColor = .gray
    }
}

// Email Cell

class EmailCell: UICollectionViewCell {
    
    var label = UILabel()
    var textField = TextFieldRect()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 20, y: 0, width: contentView.frame.width, height: 30)
        label.textColor = .gray
        label.text = "Email"
        
        textField.frame = CGRect(x: 10, y: label.layer.position.y + 5, width: contentView.frame.width, height: contentView.frame.height - 30)
        textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textField.textColor = .gray
    }
}

