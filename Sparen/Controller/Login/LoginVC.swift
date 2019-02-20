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
    
    var loginButton: UIButton!
    var createLabel: UILabel!
    var createButton: UIButton!
    var label: UILabel!
    var emailPhoneField: UITextField!
    var passwordField: UITextField!
    var resetButton: UIButton!
    var separator = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK: SetupViews
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        loginButton = UICreator.create.button("Sign In", nil, .white, .red, view)
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        loginButton.backgroundColor = UIColor.sparenColor
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        createLabel = UICreator.create.label("Don't have an account yet?", 13, .lightGray, .left, .medium, view)
        createLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createAccount)))
        createLabel.isUserInteractionEnabled = true
        
        createButton = UICreator.create.button("Join us!", nil, .sparenColor, nil, view)
        createButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        label = UICreator.create.label("Sparen", 35, .darkText, .center, .medium, view)
        emailPhoneField = UICreator.create.textField("Email or phone number", .default, view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        emailPhoneField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        passwordField = UICreator.create.textField("password", .default, view)
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        resetButton = UICreator.create.button("Forgot?", nil, view.tintColor, nil, view)
        resetButton.setTitleColor(.gray, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        emailPhoneField.text = email
        
        separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.addSubview(separator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, emailPhoneField, passwordField, resetButton, loginButton, createLabel, createButton, separator, view) { (label, emailPhoneField, passwordField, resetButton, loginButton, createLabel, createButton, separator, view) in
            
            label.top == view.top + 150
            label.centerX == view.centerX
            
            emailPhoneField.top == label.bottom + 80
            emailPhoneField.centerX == view.centerX
            emailPhoneField.height == 45
            emailPhoneField.width == view.width - 40
            
            passwordField.top == emailPhoneField.bottom + 10
            passwordField.centerX == view.centerX
            passwordField.width == view.width - 40
            passwordField.height == 45
            
            resetButton.top == emailPhoneField.bottom + 10
            resetButton.centerY == passwordField.centerY
            resetButton.right == passwordField.right - 10
            
            loginButton.top == passwordField.bottom + 60
            loginButton.centerX == view.centerX
            loginButton.height == 50
            loginButton.width == view.width - 40
            
            createLabel.top == view.bottom - 80
            createLabel.left == view.left + 65
            createLabel.height == 80
            
            createButton.top == view.bottom - 80
            createButton.right == createLabel.right + 60
            createButton.height == 80
            
            separator.top == createButton.top
            separator.width == view.width
            separator.height == 0.5
        }
    }
    
    
    // MARK: Actions
    
    @objc func login() {
        
        loginButton.isEnabled = false
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        if let email = emailPhoneField.text, let pass = passwordField.text {
            AuthService.instance.signIn(email, pass) { (success, error, circleId) in
                if !success {
                    self.loginButton.isEnabled = false
                    ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "An error occured", .error)
                    self.alert(error!.localizedDescription)
                    activityIndicator.stopAnimating()
                } else {
                    self.loginButton.isEnabled = false
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(pass, forKey: "password")
                    let vc =  DashboardVC()
                    let nav =  UINavigationController(rootViewController: vc)
                    vc.circleId = circleId
                    activityIndicator.stopAnimating()
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func resetPassword() {
        let vc = ResetPassVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createAccount() {
        let vc = EmailPhoneVC()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    @objc func textChanged(_ textField: UITextField) {
        if emailPhoneField.hasText && passwordField.hasText  {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
    }
    
    func alert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
