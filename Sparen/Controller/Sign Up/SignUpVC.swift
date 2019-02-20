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
    var countryCode: String!
    var verificationTextField   = BackgroundTextField()
    
    let headline                = Headline()
    let subhead                 = Subhead()
    let cardField               = CardField()
    let footnote                = Footnote()
    
    let nextButton              = LogButton()
    var resendButton            = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        nextButton.isEnabled = false
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
        let vc = NamePasswordVC()
        nextButton.showLoading()
        self.navigationController?.pushViewController(vc, animated: true)


        
        //AuthService.instance.phoneVerification(verificationCode: verificationTextField.text!) { (success, error) in
//            if !success! {
//                let alert = Alert()
//                dispatch.async {
//                    self.nextButton.hideLoading()
//                    alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
//                }
//            } else {
//                dispatch.async {
//                    self.nextButton.hideLoading()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        }
    }
    
    @objc func resendCode() {
        
    }
    
    @objc func textChanged(sender: NSNotification) {
        if verificationTextField.hasText {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}
