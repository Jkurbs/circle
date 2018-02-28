//
//  ForgotPasswordVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    
    var textField  = BackgroundTextField()
    let sendButton = LogButton()
    
    let headline                = Headline()
    let subhead                 = Subhead()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 25
        let width = self.view.bounds.width - (padding * 2)  - 20
        let y = (self.navigationController?.navigationBar.frame.height)! + 40
        let centerX = view.center.x
        
        headline.frame = CGRect(x: 0, y: y , width: width + 20, height: 60)
        headline.center.x = centerX
        
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 60)
        subhead.center.x = centerX
        
        textField.frame = CGRect(x: 0, y: subhead.layer.position.y + 40, width: width, height: 50)
        textField.center.x = centerX
        
        sendButton.frame = CGRect(x: 0, y: textField.layer.position.y + 50, width: width, height: 50)
        sendButton.center.x = centerX
        
    }
    
    
    func setupView() {
        
        view.addSubview(headline)
        headline.text = "Forgot password"
        
        view.addSubview(subhead)
        subhead.text = "An email to reset your password will be sent to you"
        
        view.addSubview(textField)
        textField.placeholder = "Email address"
        textField.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        view.addSubview(sendButton)
        sendButton.setTitle("Send email", for: .normal)
        sendButton.isEnabled = true
        sendButton.alpha = 1.0
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    @objc func send() {
        
    }
    
}
