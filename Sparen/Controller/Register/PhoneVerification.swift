//
//  PhoneVerification.swift
//  Sparen
//
//  Created by Kerby Jean on 8/31/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import LTMorphingLabel

class PhoneVerification: UIViewController, LTMorphingLabelDelegate {

    var label = LTMorphingLabel()
    var secondLabel = LTMorphingLabel()
    var textField = UITextField()
    var nextButton: UIBarButtonItem!
    var data = [String]()
    
    var position: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(label)
        
        let font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        secondLabel.font = font
        label.hero.id = "label"
        label.text = "I've sent you a verification"
        label.morphingDuration = 1.0
        
        label.delegate = self
        
        view.addSubview(label)
        view.addSubview(secondLabel)
        
        textField = UICreator.create.textField("Verification number", .numberPad , self.view)
        textField.addTarget(self, action: #selector(edited), for: .editingChanged)
        
        textField.alpha = 0.0
        
        nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextStep))
        nextButton.isEnabled = false
        navigationItem.rightBarButtonItem = nextButton
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(label, secondLabel, textField, view) { (label, secondLabel, textField, view) in
            label.top == view.top + 200
            label.width == view.width - 100
            label.left == view.left + 50
            
            secondLabel.top == label.bottom + 10
            secondLabel.width == view.width - 100
            secondLabel.left == view.left + 50
            
            textField.top == secondLabel.bottom + 40
            textField.width == view.width - 50
            textField.left == view.left + 50
        }
    }
    
    @objc func edited(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
            
        }
    }
    
    @objc func nextStep() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        let firstName = data[0]
        let lastName = data[1]
        let email = data[2]
        let phoneNumber = data[3]
        let password = data[4]
        let code = textField.text!
        let isAdmin = true
        
        AuthService.instance.createAccount(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password, code: code, position: position ?? 1, isAdmin: isAdmin) { (success, error) in
            if !success {
                self.nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextStep))
                self.navigationItem.rightBarButtonItem = self.nextButton
                activityIndicator.stopAnimating()
                self.alert("Invalide verification number. Please try again.")
                return 
            } else {
                self.nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextStep))
                self.navigationItem.rightBarButtonItem = self.nextButton
                activityIndicator.stopAnimating()
                let vc = DashboardVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        self.secondLabel.text = "number at \(self.data[3])"
        UIView.animate(withDuration: 0.5) {
            self.textField.alpha = 1.0
            self.textField.becomeFirstResponder()
        }
    }
    
    func alert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
