//
//  WelcomeVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/23/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import GoogleSignIn

class WelcomeVC: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var stackView: UIStackView!
    var signInButton : GIDSignInButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height))
        signInButton.style = .wide
        stackView.insertArrangedSubview(signInButton, at: 1)
    }

    
    
    @IBAction func signInAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
