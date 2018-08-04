////
////  BankAccountVC.swift
////  Circle
////
////  Created by Kerby Jean on 1/16/18.
////  Copyright © 2018 Kerby Jean. All rights reserved.
////
//
//import UIKit
//import Stripe
//import FirebaseAuth
//
//class BankAccountVC: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate {
//    
//    let headline                = Headline()
//    let subhead                 = Subhead()
//    let emailTextField          = BackgroundTextField()
//    let bankButton              = LogButton()
//
//    let nextButton              = LogButton()
//    let footnote                = Footnote()
//    
//    var password: String!
//    var name: [String]!
//    
//    var circleId: String?
//    var pendingInsiders: Int?
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor    = UIColor.white
//
//        setupView()
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
//
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        
//        headline.frame = CGRect(x: 0, y: 45 , width: width, height: 40)
//        headline.center.x = centerX
//
//        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 50)
//        subhead.center.x = centerX
//        
//        emailTextField.frame = CGRect(x: 0, y: subhead.layer.position.y + 40, width: width, height: 50)
//        emailTextField.center.x = centerX
//        emailTextField.placeholder = "Email address"
//        
//        bankButton.frame = CGRect(x: padding, y: emailTextField.layer.position.y + 40, width: width, height: 50)
//        bankButton.center.x = centerX
//
//        footnote.frame = CGRect(x: 0, y: bankButton.layer.position.y + 30, width: width, height: 50)
//        footnote.center.x = centerX
//        
//    }
//    
//    func setupView() {
//        
//        view.addSubview(headline)
//        headline.text = "Add a bank account"
//        
//        view.addSubview(subhead)
//        subhead.text = "You'll use your debit card to receive and make transactions"
//        
//        emailTextField.keyboardType = .emailAddress
//        emailTextField.autocapitalizationType = .none
//        emailTextField.autocorrectionType = .no
//        view.addSubview(emailTextField)
//        
//        bankButton.setTitle("Add Bank account", for: .normal)
//        bankButton.contentHorizontalAlignment = .left
//        bankButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 5)
//
//        bankButton.setTitleColor(.blueColor, for: .normal)
//        bankButton.isEnabled = true
//        bankButton.backgroundColor = .textFieldBackgroundColor
//        bankButton.addTarget(self, action: #selector(selectBank), for: .touchUpInside)
//        view.addSubview(bankButton)
//        
//        view.addSubview(footnote)
//        footnote.text = "By registering your account, you agree to our Services Agreement and the Stripe Connected Account Agreement."
//    }
//    
//    
//    @objc func selectBank() {
////        let vc = ViewController()
//        vc.email = self.emailTextField.text!
//        vc.password = self.password
//        let navController = UINavigationController(rootViewController: vc)
//        self.present(navController, animated: true, completion: nil)
//    }
//
//    
//    @objc func textChanged(sender: NSNotification) {
//        if emailTextField.hasText {
//            nextButton.isEnabled = true
//            nextButton.alpha = 1.0
//        } else {
//            nextButton.isEnabled = false
//            nextButton.alpha = 0.5
//        }
//    }
//}

