//
//  PageThreeVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Contacts
import FirebaseMessaging
import UserNotifications

class PageThreeVC: UIViewController {
    
    var headline = Headline()
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(headline)
        headline.numberOfLines = 3
        headline.font = UIFont.systemFont(ofSize: 20, weight: .light)
        headline.text = "Get started by enable notification"
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let padding: CGFloat = 25
        let width = self.view.bounds.width - (padding * 2)  - 20
        let centerX = view.center.x
        headline.frame = CGRect(x: 0, y: 50 , width: width, height: 60)
        headline.center.x = centerX
        
        
        button = UIButton(frame: CGRect(x: 0, y: headline.layer.position.y + 100, width: 200, height: 50))
        button.center.x = centerX
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.setTitleColor(UIColor.red, for: .normal)
        button.layer.cornerRadius = 25
        
        button.setTitle("Allow access", for: .normal)
        button.addTarget(self, action: #selector(notificationAccess), for: .touchUpInside)
        view.addSubview(button)
    }
    
    
    @objc func notificationAccess() {
        AuthService.instance.appDel.userNotification()
        
        if let circleId = UserDefaults.standard.string(forKey: "circleId") as? String {
            if circleId != nil {
                DispatchQueue.main.async {
                    let vc = PhoneVCTwo()
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.present(navigationController, animated: true, completion: nil)
                }
            } else {
                
                DispatchQueue.main.async {
                    let vc = ContactInfoVC()
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
}
