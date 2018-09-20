//
//  NameVC.swift
//  Sparen
//
//  Created by Kerby Jean on 8/29/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import Hero
import LTMorphingLabel

class NameVC: UIViewController, LTMorphingLabelDelegate {
    
    var label = LTMorphingLabel()
    var secondLabel = LTMorphingLabel()
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        firstNameField = UICreator.create.textField("First name", .default, self.view)
        firstNameField.addTarget(self, action: #selector(edited(_:)), for: .editingChanged)
        
        lastNameField = UICreator.create.textField("Last name", .default, self.view)
        lastNameField.addTarget(self, action: #selector(edited(_:)), for: .editingChanged)
        
        firstNameField.alpha = 0.0
        lastNameField.alpha = 0.0
        
        let font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        label.hero.id = "label"
        label.text = "Hi, I'm Sparen"
        label.morphingDuration = 1.0

        label.delegate = self
        
        view.addSubview(label)
        view.addSubview(secondLabel)
        
        nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextStep))
        nextButton.isEnabled = false
        navigationItem.rightBarButtonItem = nextButton

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(label, secondLabel ,firstNameField, lastNameField,  view) { (label, secondLabel, firstNameField, lastNameField, view) in
            label.top == view.top + 200
            label.width == view.width - 100
            label.left == view.left + 50
            
            secondLabel.top == label.bottom + 20
            secondLabel.width == view.width - 100
            secondLabel.left == view.left + 50

            firstNameField.top == secondLabel.bottom + 40
            firstNameField.width == view.width - 50
            firstNameField.left == view.left + 50
            
            lastNameField.top == firstNameField.bottom + 20
            lastNameField.width == view.width - 50
            lastNameField.left == view.left + 50
        }
    }
    
    @objc func nextStep() {
        let vc = EmailPhoneVC()
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        vc.data.append(firstName)
        vc.data.append(lastName)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func edited(_ textField: UITextField) {
        if (textField.text?.isEmpty)! && (lastNameField.text?.isEmpty)! {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        self.secondLabel.text = "What's your name?"
        UIView.animate(withDuration: 0.5) {
            self.firstNameField.alpha = 1.0
            self.lastNameField.alpha = 1.0
            self.firstNameField.becomeFirstResponder()
        }
    }
}

