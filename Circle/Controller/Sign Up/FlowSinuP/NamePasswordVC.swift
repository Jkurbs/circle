//
//  NamePasswordVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth


class NamePasswordVC: UIViewController, UITextFieldDelegate {
    
    var phoneNumber: String!
    var country: String!
    var emailAddress: String!
    
    var circleId: String?
    var pendingInsiders: Int?
    
    var upperView                 = IntroView()
    let footnote                  = Footnote()
    
    let nextButton                = LogButton()
    var verifiedButton            = UIButton()
    var datePicker                = UIDatePicker()
    
    
    var legalNameField            = BackgroundTextField()
    var selectDobField            = BackgroundTextField()
    var passwordTextField         = BackgroundTextField()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        nextButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        print("CIRCLE ID NamePasswordVC", circleId)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upperView = IntroView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 100))
        upperView.center.x = centerX
        upperView.setText("Name and Password", "Your name will help you be recognized")
        view.addSubview(upperView)
        
        legalNameField.frame = CGRect(x: padding + 10, y: upperView.layer.position.y + 60, width:  (width / 2) - padding, height: 50)
        
        selectDobField.frame = CGRect(x: self.legalNameField.frame.maxX + padding, y: upperView.layer.position.y + 60, width: width / 2, height: 50)
        
        
        passwordTextField.frame = CGRect(x: 0, y: selectDobField.layer.position.y + 40, width: width, height: 50)
        passwordTextField.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: passwordTextField.layer.position.y + 40, width: width, height: 50)
        nextButton.center.x = centerX
    }

    
    func setupView() {
        
        view.addSubview(legalNameField)
        legalNameField.keyboardType = .default
        legalNameField.autocorrectionType = .no
        legalNameField.autocapitalizationType = .words
        legalNameField.placeholder = "First name, last name"
        
        view.addSubview(selectDobField)
        selectDobField.placeholder = "Select date of birth"
        selectDobField.delegate = self
        
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        verifiedButton = passwordTextField.button(iconName: "")
        verifiedButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        view.addSubview(nextButton)
        nextButton.setTitle("Continue", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
    }

    
    
    // MARK: Textfield delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectDobField {
            showDatePicker()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ifPasswordValid(textField.text!) == true {
            verifiedButton.setImage(#imageLiteral(resourceName: "Valide-20"), for: .normal)
        } else {
            verifiedButton.setImage(#imageLiteral(resourceName: "Invalide-20"), for: .normal)
       }
        return true
    }
    
    @objc func nextStep() {
        self.nextButton.showLoading()
        let legalName = legalNameField.text!
        
        var nameArr = legalName.components(separatedBy: " ")
        let firstName = nameArr[0]
        let lastName = nameArr[1]
        let password = passwordTextField.text!
        let vc = ChooseBankVC()
        vc.emailAddress = emailAddress
        let dob =  selectDobField.text!.components(separatedBy: "/")
        let dobMonth = dob.first!
        let dobDay = dob[1]
        let dobYear = dob[2]
        
        DataService.instance.saveNamePassword(firstName: firstName, lastName: lastName, email: emailAddress, password: password, dobDay: dobDay, dobMonth: dobMonth, dobYear: dobYear) { (success, error) in
            if !success {
                let alert = Alert()
                dispatch.async {
                    self.nextButton.hideLoading()
                    alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                }
            } else {
                self.nextButton.hideLoading()
                dispatch.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    func ifPasswordValid(_ password: String) -> Bool {
        let passwordValidated = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordValidated.evaluate(with: password)
    }
    
    @objc func textChanged(sender: NSNotification) {
        if legalNameField.hasText && !selectDobField.text!.isEmpty {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
}

extension NamePasswordVC {
    @objc  func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        doneButton.tintColor = UIColor.blueColor
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = UIColor.blueColor
        toolbar.setItems([cancelButton,spaceButton, doneButton], animated: false)
        
        // add toolbar to textField
        selectDobField.inputAccessoryView = toolbar
        // add datepicker to textField
        selectDobField.inputView = datePicker
    }
    
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        selectDobField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

