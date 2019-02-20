//
//  EmailPhoneVC.swift
//  Sparen
//
//  Created by Kerby Jean on 8/30/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import LTMorphingLabel

class EmailPhoneVC: UIViewController, CountryListDelegate {
    
    var label = UILabel()
    var phoneTextField = BackgroundTextField()
    var emailTextField: UITextField!
    var passwordField: UITextField!
    var separator = UIView()
    
    var nextButton: UIButton!
    
    var loginLabel: UILabel!
    var loginButton: UIButton!
    
    var agreementLabel: UILabel!
    var agreementButton: UIButton!

    
    var countryList = CountryList()
    
    var country: String!
    var phoneExtension = "1"
    
    var countryButton = UIButton()

    var data = [String]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupViews()
    }
    
    
    func setupViews() {
        view.backgroundColor = .white
        
        
        let font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        label.textAlignment = .center
        label.text = "Phone & Email"
        
        view.addSubview(label)
        
        agreementLabel = UICreator.create.label("By registering your account, you agree to our ", 13, .lightGray, .left, .medium, view)
        agreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAgreement)))
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.sizeToFit()
        
        agreementButton = UICreator.create.button("Services Agreement", nil, .sparenColor, nil, view)
        agreementButton.addTarget(self, action: #selector(showAgreement), for: .touchUpInside)
        agreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        loginLabel = UICreator.create.label("Already have an account?", 13, .lightGray, .left, .medium, view)
        loginLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(login)))
        loginLabel.isUserInteractionEnabled = true
        
        loginButton = UICreator.create.button("Sign In.", nil, .sparenColor, nil, view)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        view.addSubview(phoneTextField)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "Phone number"
        phoneTextField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        countryButton = phoneTextField.button("US +1")
        countryButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        countryButton.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)
        
        nextButton = UICreator.create.button("Next", nil, .white, .red, view)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.backgroundColor = UIColor.sparenColor
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        
        separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.addSubview(separator)
        
        countryList.delegate = self

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setTitle("US", for: .normal)
        button.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)

        emailTextField = UICreator.create.textField("Email Address", .emailAddress , self.view)
        emailTextField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        emailTextField.autocorrectionType = .no
        
        passwordField = UICreator.create.textField("Password", .default, self.view)
        passwordField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        passwordField.isSecureTextEntry = true

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(label, phoneTextField, emailTextField, passwordField, nextButton, loginLabel, loginButton, separator, view) { (label, phoneTextField, emailTextField, passwordField, nextButton, loginLabel, loginButton, separator, view) in
            
            label.top == view.top + 150
            label.width == view.width
            label.centerX == view.centerX
            
            phoneTextField.top == label.bottom + 40
            phoneTextField.width == view.width - 40
            phoneTextField.height == 45
            phoneTextField.centerX == view.centerX
    
            emailTextField.top == phoneTextField.bottom + 10
            emailTextField.width == view.width - 40
            emailTextField.height == 45
            emailTextField.centerX == view.centerX
            
            passwordField.top == emailTextField.bottom + 10
            passwordField.width == view.width - 40
            passwordField.height == 45
            passwordField.centerX == view.centerX
            
            nextButton.top == passwordField.bottom + 60
            nextButton.centerX == view.centerX
            nextButton.height == 50
            nextButton.width == view.width - 40
            
            loginLabel.top == view.bottom - 80
            loginLabel.left == view.left + 65
            loginLabel.height == 80
            
            loginButton.top == view.bottom - 80
            loginButton.right == loginLabel.right + 60
            loginButton.height == 80
            
            separator.top == loginLabel.top
            separator.width == view.width
            separator.height == 0.5
        }
        
        constrain(nextButton, agreementLabel, agreementButton, view) { (nextButton, agreementLabel, agreementButton, view) in
            
            agreementLabel.top == nextButton.bottom + 10
            agreementLabel.centerX == view.centerX
            
            agreementButton.top == agreementLabel.bottom + 5
            agreementButton.centerX == agreementLabel.centerX
        }
    }
    
    @objc func nextStep() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        let email = emailTextField.text!
        let phone = "+\(self.phoneExtension)\(phoneTextField.text!)"
        let password = passwordField.text!
        let vc = PhoneVerification()
        self.data.append(phone)
        self.data.append(email)
        self.data.append(password)
        vc.data = self.data
        
        if isValidEmail(testStr: email) {
            AuthService.instance.verifyPhone(phone) { (success, error) in
                if !success {
                    print("ERROR::" ,error!.localizedDescription )
                    activityIndicator.stopAnimating()
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                    activityIndicator.stopAnimating()
                }
            }
        } else {
            self.alert("Invalide email address. Please verify you email and try again.")
            activityIndicator.stopAnimating()
        }
    }
    


    @objc func login() {
        let vc = LoginVC()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func alert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showAgreement() {
        
    }
}

extension EmailPhoneVC {
    
    @objc func presentCountryList() {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    
    func selectedCountry(country: Country) {
        self.country = country.name
        self.phoneExtension = country.phoneExtension
        countryButton.setTitle("\(country.countryCode) +\(country.phoneExtension)", for: .normal)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc func textChanged(_ textField: UITextField) {
        if phoneTextField.hasText && emailTextField.hasText && passwordField.hasText  {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
}

