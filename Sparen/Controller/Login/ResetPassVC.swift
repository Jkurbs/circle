//
//  ResetPassVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth

class ResetPassVC: UIViewController {
    
    var label: UILabel!
    var emailField: UITextField!
    var sendButton: UIBarButtonItem!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        label = UICreator.create.label("Reset password", 20, UIColor.darkText, .left, .medium, view)
        sendButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(send))
        navigationItem.rightBarButtonItem = sendButton
        
        emailField = UICreator.create.textField("Email address", .emailAddress, view)
        emailField.addTarget(self, action: #selector(edited(_:)), for: .editingChanged)
        emailField.text = email ?? ""
        emailField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, emailField, view) { (label, emailField, view) in
            label.top == view.top + 150
            label.left == view.left + 40
            emailField.top == label.top + 40
            emailField.left == view.left + 40
            emailField.height == 60
            emailField.width == view.width - 40
        }
    }
    
    @objc func send() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        Auth.auth().sendPasswordReset(withEmail: "kerby.jean@hotmail.fr") { (error) in
            if let error = error {
                self.showMessage(error.localizedDescription, type: .error)
                self.sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(self.send))
                self.navigationItem.rightBarButtonItem = self.sendButton
                activityIndicator.stopAnimating()
            } else {
                self.showMessage("Password successfully reset", type: .success)
                self.sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(self.send))
                self.navigationItem.rightBarButtonItem = self.sendButton
                activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func edited(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}












