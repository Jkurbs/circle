//
//  NameVC.swift
//  Sparen
//
//  Created by Kerby Jean on 8/29/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class NameVC: UIViewController, UITextFieldDelegate {
    
    var label = UILabel()
    var secondLabel = UILabel()
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var dateOfBirthField: UITextField!
    var datePicker = UIDatePicker()
    var nextButton: UIButton!
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let bagColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        
        firstNameField = UICreator.create.textField("First name", .default, self.view)
        lastNameField = UICreator.create.textField("Last name", .default, self.view)
        dateOfBirthField = UICreator.create.textField("Date of birth", .default, self.view)
        
        dateOfBirthField.delegate = self
        
        firstNameField.backgroundColor = bagColor
        lastNameField.backgroundColor = bagColor
        dateOfBirthField.backgroundColor = bagColor
        
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        dateOfBirthField.inputAccessoryView = toolbar
        // add datepicker to textField
        dateOfBirthField.inputView = datePicker
      
        
        
        let font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        label.text = "Name & Last Name"
        label.textAlignment = .center
        
        view.addSubview(label)
        view.addSubview(secondLabel)
        
        nextButton = UICreator.create.button("Done", nil, .white, .red, view)
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        nextButton.backgroundColor = UIColor.sparenColor
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateOfBirthField.text! = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(label, secondLabel ,firstNameField, lastNameField, dateOfBirthField, nextButton, view) { (label, secondLabel, firstNameField, lastNameField, dateOfBirthField, nextButton, view) in
            
            label.top == view.top + 150
            label.width == view.width
            label.centerX == view.centerX
            
            secondLabel.top == label.bottom + 20
            secondLabel.width == view.width - 100
            secondLabel.centerX == view.centerX

            firstNameField.top == secondLabel.bottom + 40
            firstNameField.width == view.width - 40
            firstNameField.height == 45
            firstNameField.centerX == view.centerX
            
            lastNameField.top == firstNameField.bottom + 10
            lastNameField.width == view.width - 40
            lastNameField.height == 45
            lastNameField.centerX == view.centerX
            
            dateOfBirthField.top == lastNameField.bottom + 10
            dateOfBirthField.width == view.width - 40
            dateOfBirthField.height == 45
            dateOfBirthField.centerX == view.centerX
            
            nextButton.top == dateOfBirthField.bottom + 60
            nextButton.centerX == view.centerX
            nextButton.height == 50
            nextButton.width == view.width - 40
        }
    }
    
    @objc func nextStep() {
        

        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let dateOfBirth  = dateOfBirthField.text?.components(separatedBy: " ")
        
        let phone = self.data[0]
        let email = self.data[1]
        let password =  self.data[2]
        let code = self.data[3]
        
        AuthService.instance.createAccount(firstName, lastName, email, phone, password, code, false, dateOfBirth!) { (success, error) in
            if !success {
                print("error", error!.localizedDescription)
                activityIndicator.stopAnimating()
            } else {
                if let string = UserDefaults.standard.string(forKey: "circleId"), !string.isEmpty {
                    DataService.call.joinCircle(string, complete: { (success, error) in
                        if !success {
                            print("Error:", error?.localizedDescription)
                        } else {
                            print("NEW")
                            dispatch.async {
                                self.navigationController?.pushViewController(AddressVC(), animated: true)
                            }
                        }
                    })
                } else {
                    print("NOT NEW")
                    self.navigationController?.pushViewController(AddressVC(), animated: true)
                    activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func textChanged(_ textField: UITextField) {
        if firstNameField.hasText && lastNameField.hasText {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
}

