//
//  LoginVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let headline = Headline()
    
    let nextButton  = LogButton()
    let forgetPasswordButton = UIButton()
    
    let phoneEmailField = BackgroundTextField()
    let passwordField = BackgroundTextField()
    
    let registerButton             = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headline.frame = CGRect(x: 0, y: 50 , width: width, height: 60)
        headline.center.x = centerX
        
        phoneEmailField.frame = CGRect(x: 0, y: headline.layer.position.y + 40, width: width, height: 50)
        phoneEmailField.center.x = centerX
        
        passwordField.frame = CGRect(x: 0, y: phoneEmailField.layer.position.y + 40, width: width, height: 50)
        passwordField.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: passwordField.layer.position.y + 50, width: width, height: 50)
        nextButton.center.x = centerX
        
        forgetPasswordButton.frame = CGRect(x: 0, y: nextButton.layer.position.y + 15, width: width, height: 50)
        forgetPasswordButton.center.x = centerX
        
        registerButton.backgroundColor = UIColor.textFieldBackgroundColor
        registerButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        registerButton.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - registerButton.frame.size.height)
        registerButton.center.x = centerX
    }
    
    func setupView() {
        
        view.addSubview(headline)
        headline.text = "Log In"
        
        view.addSubview(phoneEmailField)
        phoneEmailField.autocorrectionType = .no
        phoneEmailField.keyboardType = .default
        phoneEmailField.placeholder = "Phone number or email"
        
        view.addSubview(passwordField)
        passwordField.keyboardType = .default
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        
        view.addSubview(nextButton)
        nextButton.setTitle("Log In", for: .normal)
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        nextButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(forgetPasswordButton)
        forgetPasswordButton.setTitle("Forgot password?", for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        forgetPasswordButton.setTitleColor(UIColor.blueColor, for: .normal)
        forgetPasswordButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(registerButton)
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(UIColor.blueColor, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
        
    
    
    @objc func login() {
        nextButton.showLoading()
        AuthService.instance.signIn(email: phoneEmailField.text!, password: passwordField.text!) { (success, error, circleId)  in
            if !success {
                self.nextButton.hideLoading()
            } else {
                print("CIRCLE_ID", circleId)
                self.nextButton.hideLoading()
                let circleVC = CircleVC()
                circleVC.circleId = circleId
                self.navigationController?.pushViewController(circleVC, animated: true)
            }
        }
    }
    
    
    @objc func forgotPassword() {
        let vc = ForgotPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc func register() {
        
        let nav = UINavigationController(rootViewController: ContactInfoVC())
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func isNumeric(a: String) -> Bool {
        return Double(a) != nil
    }
}
