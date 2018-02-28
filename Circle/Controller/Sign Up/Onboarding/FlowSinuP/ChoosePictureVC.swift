//
//  ChoosePictureVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase

class ChoosePictureVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let headline                  = Headline()
    let subhead                   = Subhead()
    
    let imageView                 = UIImageView()

    let nextButton                = LogButton()
    
    var imagePicker = UIImagePickerController()

    var name: [String]!
    var password: String!
    
    var circleId: String?
    var pendingInsiders: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        print(" ChoosePictureVC CIRCLE ID", circleId)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 25
        let width = self.view.bounds.width - (padding * 2)  - 20
        let y = (self.navigationController?.navigationBar.frame.height)! + 40
        let centerX = view.center.x
        
        headline.frame = CGRect(x: 0, y: y , width: width, height: 60)
        headline.center.x = centerX
        
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y , width: width, height: 60)
        subhead.center.x = centerX

        imageView.frame = CGRect(x: 0, y: subhead.layer.position.y + 50, width: 100, height: 100)
        imageView.center.x = centerX
        imageView.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.textFieldBackgroundColor

        nextButton.frame = CGRect(x: 0, y: imageView.layer.position.y + 100, width: width, height: 50)
        nextButton.center.x = centerX
    }
    
    func setup() {
        
        imagePicker.delegate = self

        view.addSubview(headline)
        headline.text = "Choose picture"
        
        view.addSubview(subhead)
        subhead.text = "Your picture will help you be recognized"
        
        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        nextButton.setTitle("Next", for: .normal)
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editPhotoAlert))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func editPhotoAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "Take a Picture", style: .default) { (action) in
            self.openCamera()
        }
        
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(takePhoto)
        alert.addAction(library)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

    
    @objc func nextStep() {
                
        self.nextButton.showLoading()
        let password = self.password
        let vc = BankAccountVC()
        vc.password = password
        vc.name = self.name
        vc.circleId = circleId ?? ""
        
        let image = imageView.image!
        
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            DataService.instance.saveImageData(data) { (url, success, error) in
                if !success {
                    let alert = Alert()
                    dispatch.async {
                        self.nextButton.hideLoading()
                        alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                    }
                } else {
                    DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).setData(["image_url": url ?? ""], options: SetOptions.merge())
                    self.nextButton.hideLoading()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openLibrary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


}
