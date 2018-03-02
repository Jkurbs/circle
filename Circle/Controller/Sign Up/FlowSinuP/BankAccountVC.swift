//
//  BankAccountVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Stripe
import FirebaseAuth

class BankAccountVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    let headline                = Headline()
    let subhead                 = Subhead()
    let cardField               = CardField()
    let emailTextField          = BackgroundTextField()

    let nextButton              = LogButton()
    let footnote                = Footnote()
    
    var password: String!
    var name: [String]!
    
    var circleId: String?
    var pendingInsiders: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor    = UIColor.white

        setupView()
        
        cardField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(sender:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        print("CIRCLE ID", circleId)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        headline.frame = CGRect(x: 0, y: 45 , width: width, height: 40)
        headline.center.x = centerX

        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 50)
        subhead.center.x = centerX
        
        emailTextField.frame = CGRect(x: 0, y: subhead.layer.position.y + 40, width: width, height: 50)
        emailTextField.center.x = centerX
        emailTextField.placeholder = "Email address"
        
        cardField.frame = CGRect(x: padding, y: emailTextField.layer.position.y + 40, width: width, height: 50)

        nextButton.frame = CGRect(x: 0, y: cardField.layer.position.y + 50, width: width, height: 50)
        nextButton.center.x = centerX
        
        footnote.frame = CGRect(x: 0, y: nextButton.layer.position.y + 30, width: width, height: 50)
        footnote.center.x = centerX
        
    }
    
    func setupView() {
        
        view.addSubview(headline)
        headline.text = "Add a bank account"
        
        view.addSubview(subhead)
        subhead.text = "You'll use your debit card to receive and make transactions"
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        view.addSubview(emailTextField)
        
        cardField.textColor = UIColor.darkText
        cardField.borderWidth = 0.0
        view.addSubview(cardField)

        view.addSubview(nextButton)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        view.addSubview(footnote)
        footnote.text = "By registering your account, you agree to our Services Agreement and the Stripe Connected Account Agreement."
    }
    
    
    
    
   @objc func nextStep() {
        
    nextButton.showLoading()
    let alert = Alert()
    let email = emailTextField.text!
    self.cardField.cardParams.currency = "usd"
    self.cardField.cardParams.name = "\(name[0]) \(name[1])"
    
    STPAPIClient.shared().createToken(withCard: cardField.cardParams) { (token, error) in
        if let error = error {
            dispatch.async {
                self.nextButton.hideLoading()
                alert.showPromptMessage(self, title: "Error", message: (error.localizedDescription))
            }
            return
        } else {
            
           let last4 = token?.card?.last4
           let image = token?.card?.image
           let imageData = UIImagePNGRepresentation(image!)
            
           DataService.instance.saveImageData(imageData!, { (url, success, error) in
                if !success {
                    print("Error saving imageData:", error!.localizedDescription)
                }  else {
                    let cardData: [String: Any] = ["stripe_id": token?.stripeID ?? "" , "token": token?.tokenId ?? "", "last4": last4 ?? "", "image_url": url ?? ""]
                    DataService.instance.saveBankInformation(email: email, password: self.password, cardData: cardData ) { (success, error) in
                        if !success {
                            dispatch.async {
                                self.nextButton.hideLoading()
                                alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                            }
                        } else {
                            dispatch.async {
                                self.nextButton.hideLoading()
                                let vc = InviteRequestVC()
                                vc.circleId = self.circleId ?? ""
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            })
        }
    }
}
    
    
    @objc func textChanged(sender: NSNotification) {
        if emailTextField.hasText {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
}
