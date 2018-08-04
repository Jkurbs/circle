//
//  ContactInfoVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import CountryList

class ContactInfoVC: UIViewController, UITextFieldDelegate, CountryListDelegate {

    var countryList = CountryList()
    
    let emailTextField = BackgroundTextField()
    var phoneTextField = BackgroundTextField()
    

    var upperView = IntroView()
    
    let footnote                = Footnote()
    
    let nextButton              = LogButton()
    var countryButton           = UIButton()
    var loginButton             = UIButton()
    
    var country: String!
    var phoneExtension = "1"
    
    var circleLink: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CONTACT")
        navigationController?.isNavigationBarHidden = true 
        countryList.delegate = self
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                

        upperView = IntroView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 100))
        upperView.center.x = centerX
        upperView.setText("Register with your phone number", "You'll use your phone number when you login")
        view.addSubview(upperView)
        
        emailTextField.frame = CGRect(x: 0, y: upperView.layer.position.y + 100, width: width, height: 50)
        emailTextField.center.x = centerX
        emailTextField.placeholder = "Email address"
        
        phoneTextField.frame = CGRect(x: 0, y: emailTextField.layer.position.y + 50, width: width, height: 50)
        phoneTextField.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: phoneTextField.layer.position.y + 50, width: width, height: 50)
        nextButton.center.x = centerX
        
        footnote.frame = CGRect(x: 0, y: nextButton.layer.position.y + 20, width: width, height: 50)
        footnote.center.x = centerX
        
        loginButton.backgroundColor = UIColor.textFieldBackgroundColor
        loginButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        loginButton.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - loginButton.frame.size.height)
        loginButton.center.x = centerX
    }
    
    
    
    func setupView() {

        view.addSubview(footnote)
        footnote.text = "You may receive SMS updates from Sparen and can opt out at any time."

        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        view.addSubview(emailTextField)
        
        view.addSubview(phoneTextField)
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "Phone number"
        countryButton = phoneTextField.button("US +1")
        countryButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        countryButton.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.setTitle("Continue", for: .normal)
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        //view.addSubview(loginButton)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.blueColor, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc func presentCountryList() {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    
    func selectedCountry(country: Country) {
        self.country = country.name
        self.phoneExtension = country.phoneExtension
        countryButton.setTitle("\(country.countryCode) +\(country.phoneExtension)", for: .normal)
    }
    
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if (textField == phoneTextField)  {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
                
                let decimalString = components.joined(separator: "") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
                
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11  {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    
                    return (newLength > 10) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne {
                    formattedString.append("1 ")
                    index += 1
                }
                if (length - index) > 3 {
                    let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("(%@)", areaCode)
                    index += 3
                }
                
                if length - index > 3 {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
                
                let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
                return false
            }
            else {
            return true
        }
    }
    
    
    @objc func nextStep() {
        
        nextButton.showLoading()
        let vc = VericationPhoneVC()
        
        vc.country = self.country
        vc.phoneExtension = self.phoneExtension
        let phoneNumber = "+\(self.phoneExtension)\(phoneTextField.text!)"
        let emailAddress = emailTextField.text!
        vc.emailAddress = emailAddress
        vc.phoneNumber = phoneNumber
        

        AuthService.instance.phoneAuth(phoneNumber: phoneNumber, viewController: self) { (success, error) in
            if !success! {
                self.phoneTextField.errorDetected(superView: self.view, error: "Error with phone number", frame: CGRect(x: 0, y: 0, width: self.phoneTextField.frame.width, height: 20))
                let alert = Alert()
                dispatch.async {
                    alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                }
                self.nextButton.hideLoading()
                return
            } else {
                dispatch.async {
                self.navigationController?.pushViewController(vc, animated: true)
                self.nextButton.hideLoading()
            }
        }
    }
}

    
    func phoneAuth() {
        
        
        
    }
    
    
    
    
    
    
    
    @objc func login() {
        let nav = UINavigationController(rootViewController: LoginVC())
        self.present(nav, animated: true, completion: nil)
    }
}












