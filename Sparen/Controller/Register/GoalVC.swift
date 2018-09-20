//
//  GoalVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import LTMorphingLabel

class GoalVC: UIViewController, LTMorphingLabelDelegate {
    
    var label = LTMorphingLabel()
    var secondLabel = LTMorphingLabel()
    var amountField: UITextField!
    var doneButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white 
        
        let font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 4
        label.font = font
        label.hero.id = "label"
        label.text = "What's your saving goal?"
        label.morphingDuration = 1.0
        label.delegate = self
        
        
        amountField = UICreator.create.textField("Amount", .numberPad, view)
        amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        amountField.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        amountField.alpha = 0.0

        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        doneButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = doneButton

        view.addSubview(label)
        view.addSubview(secondLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, secondLabel, amountField, view) { (label, secondLabel, amountField, view) in
            label.top == view.top + 200
            label.width == view.width - 100
            label.left == view.left + 50
            
            secondLabel.top == label.bottom + 10
            secondLabel.width == view.width - 100
            secondLabel.left == view.left + 50
            
            amountField.top == secondLabel.bottom + 10
            amountField.width == view.width - 100
            amountField.left == view.left + 50
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
        if (textField.text?.isEmpty)! {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    @objc func done() {
        let vc = FindCircleVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        self.secondLabel.text = "Add an approximate."
        UIView.animate(withDuration: 0.5) {
            self.amountField.alpha = 1.0
            self.amountField.becomeFirstResponder()
        }
    }
}
