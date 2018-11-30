//
//  EmailPhoneVC.swift
//  Sparen
//
//  Created by Kerby Jean on 8/30/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Hero
import Cartography
import LTMorphingLabel

class EmailPhoneVC: UIViewController, LTMorphingLabelDelegate, CountryListDelegate {
    
    var label = LTMorphingLabel()
    var secondLabel = LTMorphingLabel()
    var emailTextField = UITextField()
    var phoneTextField = BackgroundTextField()
    var passwordTextField = UITextField()
    var nextButton: UIBarButtonItem!
    
    var countryList = CountryList()
    
    var country: String!
    var phoneExtension = "1"
    
    var countryButton = UIButton()

    var data = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(label)
        
        countryList.delegate = self
        
        label.hero.id = "label"
        let font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        secondLabel.font = font
        label.hero.id = "label"
        label.text = "\(data.first ?? "") lets create you"
        label.morphingDuration = 1.0
        
        label.delegate = self
        
        view.addSubview(label)
        view.addSubview(secondLabel)
        
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setTitle("US", for: .normal)
        button.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)

        emailTextField = UICreator.create.textField("Email Address", .emailAddress , self.view)
        
        view.addSubview(phoneTextField)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "Phone number"
        countryButton = phoneTextField.button("US +1")
        countryButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        countryButton.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)

        passwordTextField = UICreator.create.textField("Password", .default , self.view)
        passwordTextField.isSecureTextEntry = true

        emailTextField.addTarget(self, action: #selector(edited), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(edited), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(edited), for: .editingChanged)

        emailTextField.alpha = 0.0
        phoneTextField.alpha = 0.0
        passwordTextField.alpha = 0.0

        nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextStep))
        nextButton.isEnabled = false
        navigationItem.rightBarButtonItem = nextButton

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(label, secondLabel, emailTextField, phoneTextField, passwordTextField, view) { (label, secondLabel, emailTextField, phoneTextField, passwordTextField, view) in
            label.top == view.top + 150
            label.width == view.width - 100
            label.left == view.left + 50
            
            secondLabel.top == label.bottom + 10
            secondLabel.width == view.width - 100
            secondLabel.left == view.left + 50
            
            emailTextField.top == secondLabel.bottom + 40
            emailTextField.width == view.width - 50
            emailTextField.left == view.left + 50
            
            phoneTextField.top == emailTextField.bottom + 40
            phoneTextField.width == view.width - 50
            phoneTextField.left == view.left + 45
            
            passwordTextField.top == phoneTextField.bottom + 40
            passwordTextField.width == view.width - 50
            passwordTextField.left == view.left + 50
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
        let pass = passwordTextField.text!
        let vc = PhoneVerification()
        self.data.append(email)
        self.data.append(phone)
        self.data.append(pass)
        vc.data = self.data
        
        if isValidEmail(testStr: email) {
            AuthService.instance.verifyPhone(phone) { (success, error) in
                if !success {
                    print("ERROR::" ,error!.localizedDescription )
//                    self.alert("\(error!.localizedDescription)")
                    self.nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextStep))
                    self.navigationItem.rightBarButtonItem = self.nextButton
                    activityIndicator.stopAnimating()
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextStep))
                    self.navigationItem.rightBarButtonItem = self.nextButton
                    activityIndicator.stopAnimating()
                }
            }
        } else {
            self.alert("Invalide email address. Please verify you email and try again.")
            self.nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextStep))
            self.navigationItem.rightBarButtonItem = self.nextButton
            activityIndicator.stopAnimating()
        }
    }
    
    
    @objc func edited(_ textField: UITextField) {
        if (textField.text?.isEmpty)! && (phoneTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)!  {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        self.secondLabel.text = "an account"
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.alpha = 1.0
            self.phoneTextField.alpha = 1.0
            self.passwordTextField.alpha = 1.0
            self.emailTextField.becomeFirstResponder()
        }
    }

    
    func alert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
}

