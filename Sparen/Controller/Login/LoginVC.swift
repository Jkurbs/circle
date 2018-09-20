//
//  LoginVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class LoginVC: UIViewController {
    
    var loginButton: UIBarButtonItem!
    var label: UILabel!
    var emailPhoneField: UITextField!
    var passwordField: UITextField!
    var resetButton: UIButton!
    var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
       loginButton = UIBarButtonItem(title: "Log In", style: .done, target: self, action: #selector(login))
       loginButton.isEnabled = false

       navigationItem.rightBarButtonItem = loginButton
        
       label = UICreator.create.label("Log In", 35, .darkText, .left, .medium, view)
       emailPhoneField = UICreator.create.textField("Email or phone number", .default, view)
       passwordField = UICreator.create.textField("password", .default, view)
       passwordField.isSecureTextEntry = true
        
       emailPhoneField.addTarget(self, action: #selector(edited(_:)), for: .editingChanged)
        
       resetButton = UICreator.create.button("Reset", nil, view.tintColor, nil, view)
       resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
       resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
       createAccountButton = UICreator.create.button("Create Account", nil, .sparenColor, nil, view)
       createAccountButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        
       let email = UserDefaults.standard.string(forKey: "email") ?? ""
       emailPhoneField.text = email
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, emailPhoneField, passwordField, resetButton, createAccountButton, view) { (label, emailPhoneField, passwordField, resetButton, createAccountButton, view) in
            label.top == view.top + 150
            label.left == view.left + 40
            
            emailPhoneField.top == label.bottom + 50
            emailPhoneField.left == view.left + 40
            emailPhoneField.height == 45
            
            passwordField.top == emailPhoneField.bottom + 10
            passwordField.left == view.left + 40
            passwordField.width == 150
            passwordField.height == 45
            
            resetButton.top == passwordField.bottom + 10
            resetButton.left == view.left + 40
            
            createAccountButton.top == resetButton.bottom + 50
            createAccountButton.left == view.left + 40
        }
    }
    
    
    @objc func login() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        if let email = emailPhoneField.text, let pass = passwordField.text {
            AuthService.instance.signIn(email: email, password: pass) { (success, error, circleId) in
                if !success {
                    self.alert(error!.localizedDescription)
                    self.loginButton = UIBarButtonItem(title: "Log In", style: .done, target: self, action: #selector(self.login))
                    self.navigationItem.rightBarButtonItem = self.loginButton
                    activityIndicator.stopAnimating()
                } else {
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(pass, forKey: "password")
                    let vc = DashboardVC()
                    vc.circleId = circleId
                    self.loginButton = UIBarButtonItem(title: "Log In", style: .done, target: self, action: #selector(self.login))
                    self.navigationItem.rightBarButtonItem = self.loginButton
                    activityIndicator.stopAnimating()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func resetPassword() {
        let vc = ResetPassVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createAccount() {
        let vc = NameVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func edited(_ textField: UITextField) {
        if (emailPhoneField.text?.isEmpty)! && (passwordField.text?.isEmpty)! {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    func alert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
