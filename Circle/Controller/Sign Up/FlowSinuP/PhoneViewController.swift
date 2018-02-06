//
//  PhoneViewController.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import CountryList

class PhoneViewController: UIViewController, UITextFieldDelegate, CountryListDelegate {

    var countryList = CountryList()
    var phoneTextField = BackgroundTextField()
    
    let headline                = Headline()
    let subhead                 = Subhead()
    let footnote                = Footnote()
    
    let nextButton              = LogButton()
    var countryButton           = UIButton()
    
    var country: String!
    var phoneExtension = "1"

    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 25
        let width = self.view.bounds.width - (padding * 2)  - 20
        let y = (self.navigationController?.navigationBar.frame.height)! + 40
        let centerX = view.center.x
        
        headline.frame = CGRect(x: 0, y: y , width: width, height: 60)
        headline.center.x = centerX
        
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 60)
        subhead.center.x = centerX
        
        phoneTextField.frame = CGRect(x: 0, y: subhead.layer.position.y + 40, width: width, height: 50)
        phoneTextField.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: phoneTextField.layer.position.y + 50, width: width, height: 50)
        nextButton.center.x = centerX
        
        footnote.frame = CGRect(x: 0, y: nextButton.layer.position.y + 20, width: width, height: 50)
        footnote.center.x = centerX
    }
    
    
    
    func setupView() {

        view.addSubview(headline)
        headline.text = "Add your phone number"
        
        view.addSubview(subhead)
        subhead.text = "You'll use your phone number when you login"

        view.addSubview(footnote)
        footnote.text = "You may receive SMS updates from Circle and can opt out at any time."

        view.addSubview(phoneTextField)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "Phone number"
        countryButton = phoneTextField.button("US +1")
        countryButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        countryButton.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.setTitle("Next", for: .normal)
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
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
    
    
    @objc func nextStep() {
        nextButton.showLoading()
        let vc = VericationPhoneVC()
        vc.phoneNumber = phoneTextField.text!
        vc.country = self.country
        vc.phoneExtension = self.phoneExtension
        let phoneNumber = "+\(self.phoneExtension)\(phoneTextField.text!)"
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
                    self.nextButton.hideLoading()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}












