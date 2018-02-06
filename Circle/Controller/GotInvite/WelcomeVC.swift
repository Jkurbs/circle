//
//  WelcomeVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    var link: String?
    
    let headline                = Headline()
    let subhead                 = Subhead()
    let footnote                = Footnote()
    let learnButton             = LogButton()
    let indicator               = ActivityIndicator()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        retrieve()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding: CGFloat = 25
        let width: CGFloat = self.view.bounds.width - (padding * 2)  - 20
        let y: CGFloat = 60
        let centerX = view.center.x
        
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = view.center
        
        headline.frame = CGRect(x: 0, y: y , width: width, height: CGFloat(60))
        headline.center.x = centerX

        subhead.frame = CGRect(x: 0, y: headline.layer.position.y + 10 , width: width, height: 60)
        subhead.center.x = centerX
        
        learnButton.frame = CGRect(x: 0, y: subhead.layer.position.y + 50, width: width, height: 50)
        learnButton.center.x = centerX

    }
    
    func setup() {
         view.addSubview(indicator)
         view.addSubview(headline)
         view.addSubview(subhead)
        
         learnButton.isEnabled = true
         learnButton.alpha = 1.0
         learnButton.setTitle("Learn more", for: .normal)
         view.addSubview(learnButton)
    }
    
    func retrieve() {
        indicator.startAnimating()
        DataService.instance.retrieveDynamicLinkCircle(link!) { (success, error, user) in
            if !success {
               self.indicator.stopAnimating()
            } else {
                self.headline.text = "Welcome"
                if let user = user {
                    self.subhead.text = "Join \(user.firstName!) \(user.lastName!) and others on circle"
                    self.indicator.stopAnimating()
                }
            }
        }
    }
}
