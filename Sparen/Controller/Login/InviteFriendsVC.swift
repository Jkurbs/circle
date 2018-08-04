//
//  InviteFriendsVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class InviteFriendsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let width =  view.frame.width
//        let mainLabel = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 40, width: width, height: 30))
//        mainLabel.frame.origin = CGPoint(x: width / 2, y: (self.navigationController?.navigationBar.frame.height)! + 40 )
//
//        mainLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
//        mainLabel.text = "Welcome Jenny"
//        let secondLabel = UILabel(frame: CGRect(x: 0, y: mainLabel.layer.position.y + 10, width: width, height: 60))
//        secondLabel.center.x = view.center.x
//        secondLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        secondLabel.textColor = UIColor.lightGray
//        secondLabel.text = "Circle is incomplete without your loved ones."
//        
//        let button = UIButton(frame: CGRect(x: 0, y: secondLabel.layer.position.y + 40, width: width, height: 30))
//        button.center.x = view.center.x
//        button.setTitle("Invite", for: .normal)
//        
//        view.addSubview(mainLabel)
//        view.addSubview(secondLabel)
//        view.addSubview(button)
        
    }
    
    @IBAction func invite(_ sender: Any) {
        let vc = InviteVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
