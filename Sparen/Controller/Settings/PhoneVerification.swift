//
//  PhoneVerification.swift
//  Sparen
//
//  Created by Kerby Jean on 8/31/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class PhoneVerification: UIViewController {

    var label = UILabel()
    var changeButton = UIButton()
    var textField = UITextField()
    var nextButton: UIButton!
    var resendButton = LoadingButton()

    var data = [String]()
    var position: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        let font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        label.numberOfLines = 4
        label.font = font
        label.textAlignment = .center
        label.text = "Enter The Code We Sent to \(data[0]) "
        
        view.addSubview(label)
        
        changeButton.setTitleColor(.blueColor, for: .normal)
        changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        changeButton.setTitle("Change phone number", for: .normal)
        changeButton.addTarget(self, action: #selector(changePhone), for: .touchUpInside)
        
        view.addSubview(changeButton)
        
        textField = UICreator.create.textField("Verification number", .numberPad , self.view)
        textField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        resendButton.setTitleColor(.blueColor, for: .normal)
        resendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        resendButton.setTitle("Resend", for: .normal)
        resendButton.addTarget(self, action: #selector(resend), for: .touchUpInside)
        
        textField.addSubview(resendButton)
        
        nextButton = UICreator.create.button("Next", nil, .white, .red, view)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.backgroundColor = UIColor.sparenColor
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(label, changeButton, textField, resendButton, nextButton, view) { (label, changeButton, textField, resendButton,  nextButton, view) in
            
            label.top == view.top + 100
            label.width == view.width - 100
            label.left == view.left + 50
            
            changeButton.top == label.bottom + 10
            changeButton.width == view.width - 100
            changeButton.left == view.left + 50
            
            textField.top == changeButton.bottom + 40
            textField.width == view.width - 40
            textField.centerX == view.centerX
            textField.height == 45
            
            resendButton.centerY == textField.centerY
            resendButton.right == textField.right - 10
            
            nextButton.top == textField.bottom + 60
            nextButton.centerX == view.centerX
            nextButton.height == 50
            nextButton.width == view.width - 40
        }
    }
    
    @objc func resend() {
        print("RESEND")
        resendButton.showLoading()
        let phone = self.data[0]
        AuthService.instance.verifyPhone(phone) { (success, error) in
            if !success {
                ErrorHandler.show.showMessage(self, "Error resending code", .error)
                self.resendButton.hideLoading()
                self.resendButton.setTitle("Resend", for: .normal)
            } else {
                ErrorHandler.show.showMessage(self, "Code has been resend", .success)
                self.resendButton.hideLoading()
                self.resendButton.setTitle("Resend", for: .normal)
            }
        }
    }
    
    
    @objc func changePhone() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func textChanged(_ textField: UITextField) {
        if self.textField.hasText  {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    @objc func nextStep() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        data.append(textField.text!)
        let code = textField.text!
        data.append(code)
        let vc = NameVC()
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func alert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
