//
//  EmailVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase

class EmailVC: UITableViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func done() {
        AuthService.instance.signUp(name: userName, email: emailField.text!, password: passwordField.text!) { (success, error) in
            if !success! {
                print("Error creating user")
            } else {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = CircleVC()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
