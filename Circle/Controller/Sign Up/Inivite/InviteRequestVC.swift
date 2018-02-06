//
//  InviteRequestVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/24/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Contacts

class InviteRequestVC: UIViewController {

    let headline                = Headline()
    let subhead                 = Subhead()
    let footnote                = Footnote()
    
    let nextButton              = LogButton()
    
    
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
        
        headline.frame = CGRect(x: 0, y: y , width: width, height: 60)
        headline.center.x = centerX
        
        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 60)
        subhead.center.x = centerX
        
        nextButton.frame = CGRect(x: 0, y: subhead.layer.position.y + 50, width: width, height: 50)
        nextButton.center.x = centerX
    }
    
    
    
    func setupView() {
        
        view.addSubview(headline)
        headline.text = "Invite loved ones"
        
        view.addSubview(subhead)
        subhead.text = "Invite at least five trustworthy person from your contacts"
        
        view.addSubview(nextButton)
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        nextButton.setTitle("Access contacts", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
    
        
    }
    
    @objc func nextStep() {
        let vc = InviteVC()
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authorizationStatus {
        case.authorized :
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case .denied, .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async {
                            let message = "Please go to Settings > Circle > Contact, to allow Circle to access your contacts."
                            let alertController = UIAlertController(title: accessError?.localizedDescription, message: message, preferredStyle: UIAlertControllerStyle.alert)
                            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(dismissAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
            break
        default:
            break
        }
    }
}
