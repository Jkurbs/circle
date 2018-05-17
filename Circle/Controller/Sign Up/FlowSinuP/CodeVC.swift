//
//  CodeVC.swift
//  Circle
//
//  Created by Kerby Jean on 5/9/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class CodeVC: UIViewController {
    
    let headline = Headline()
    
    let nextButton  = LogButton()
    
    let codeField = BackgroundTextField()
    
    var loginButton             = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headline.frame = CGRect(x: 0, y: 50 , width: width, height: 60)
        headline.center.x = centerX
        
        codeField.frame = CGRect(x: 0, y: headline.layer.position.y + 40, width: width, height: 50)
        codeField.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: 0, width: view.frame.width - 65, height: 50)
        nextButton.frame.origin = CGPoint(x: 0, y: codeField.layer.position.y + 50)
        nextButton.center.x = centerX
        
        loginButton.backgroundColor = UIColor.textFieldBackgroundColor
        loginButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        loginButton.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - loginButton.frame.size.height)
        loginButton.center.x = centerX
    }
    
    func setupView() {
        
        view.addSubview(headline)
        headline.text = "Enter your Circle code"
        
        view.addSubview(codeField)
        codeField.autocorrectionType = .no
        codeField.keyboardType = .default
        codeField.placeholder = "Enter code"
        
        view.addSubview(nextButton)
        nextButton.setTitle("Log In", for: .normal)
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        nextButton.addTarget(self, action: #selector(codeEntenred), for: .touchUpInside)
        
        view.addSubview(loginButton)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.blueColor, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    
    
    @objc func codeEntenred() {

        let circleId = codeField.text!
        DataService.instance.retrieveCircle(circleId) { (success, error, circle, user) in
            
        }
    }
    
    @objc func login() {
        let nav = UINavigationController(rootViewController: LoginVC())
        self.present(nav, animated: true, completion: nil)
    }
}
