//
//  VericationPhoneVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class VericationPhoneVC: UIViewController {

    var phoneNumber: String!
    var phoneExtension: String!
    var country: String!
    
    var circleId: String?
    var pendingInsiders: Int?
    
    var verificationTextField   = BackgroundTextField()
    
    let headline                = Headline()
    let subhead                 = Subhead()
    let cardField               = CardField()
    let footnote                = Footnote()
    
    let nextButton              = LogButton()
    var resendButton            = UIButton()
    
    private lazy var alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        print("VericationPhoneVC CIRCLE::::", circleId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 25
        let width = self.view.bounds.width - (padding * 2)  - 20
        let y = (self.navigationController?.navigationBar.frame.height)! + 40
        let centerX = view.center.x
        
        headline.frame = CGRect(x: 0, y: y , width: width, height: 60)
        headline.center.x = centerX
        
        verificationTextField.frame = CGRect(x: 0, y: headline.layer.position.y + 40, width: width, height: 50)
        verificationTextField.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: verificationTextField.layer.position.y + 50, width: width, height: 50)
        nextButton.center.x = centerX
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    func setupView() {
        
        view.addSubview(headline)
        headline.text = "A verification number has been \n sent to \(phoneNumber!)"
        
        view.addSubview(verificationTextField)
        verificationTextField.keyboardType = .numberPad
        verificationTextField.placeholder = "Enter verification number"
        resendButton = verificationTextField.button("Resend")
        resendButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        resendButton.addTarget(self, action: #selector(resendCode), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
    }
    
    @objc func nextStep() {
        verify()
    }
    

    @objc func resendCode() {
        let phoneNumber = "+\(self.phoneExtension)\(self.phoneNumber)"
        AuthService.instance.phoneAuth(phoneNumber: phoneNumber, viewController: self) { (success, error) in
            if !success! {
                dispatch.async {
                    self.alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                }
                return
            } else {
                dispatch.async {
                    self.alert.showPromptMessage(self, title: "Error", message: "A verification code has been resend to \(self.phoneNumber)")
                }
            }
        }
    }
    
    func verify() {
        let vc = NamePasswordVC()
        vc.country = self.country
        vc.phoneNumber = phoneNumber
        vc.circleId = circleId ?? ""
        nextButton.showLoading()
        
        AuthService.instance.phoneVerification(phoneNumber: phoneNumber, verificationCode: verificationTextField.text!) { (success, error) in
            if !success! {
                dispatch.async {
                    self.nextButton.hideLoading()
                    self.alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                }
            } else {
                dispatch.async {
                    self.nextButton.hideLoading()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    
    @objc func textChanged(sender: NSNotification) {
        if verificationTextField.hasText {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
}
