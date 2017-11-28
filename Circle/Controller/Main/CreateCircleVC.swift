//
//  CreateCircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseInvites

class CreateCircleVC: UIViewController, InviteDelegate {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Circle"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        
        let amount = amountLabel.text!
        let time = timeLabel.text!

        let data = ["amount": amount, "time": time]
        
        DataService.instance.createCircle(data) { (success, error) in
            if !success {
                print("ERROR CREATING CIRCLE", error.debugDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func sliderValue(_ sender: UISlider) {
        if sender.tag == 0 {
            self.amountLabel.text = "\(Int(sender.value)) $"
        } else {
            self.timeLabel.text = "\(Int(sender.value)) days"
        }
    }
    

    @IBAction func addAction(_ sender: Any) {
        if let invite = Invites.inviteDialog() {
            invite.setInviteDelegate(self)
            
            // NOTE: You must have the App Store ID set in your developer console project
            // in order for invitations to successfully be sent.
            
            // A message hint for the dialog. Note this manifests differently depending on the
            // received invitation type. For example, in an email invite this appears as the subject.
            invite.setMessage("Try this out!")
            //-\(GIDSignIn.sharedInstance().currentUser.profile.name)
            // Title for the dialog, this is what the user sees before sending the invites.
            invite.setTitle("Invites Circle")
            invite.setDeepLink("https://yqg97.app.goo.gl/Zi7X")
            invite.setCallToActionText("Install!")
            //invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
            invite.open()
        }
    }
}



