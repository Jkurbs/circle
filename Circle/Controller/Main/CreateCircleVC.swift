//
//  CreateCircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CreateCircleVC: UIViewController {
    
//    @IBOutlet weak var calendar: FSCalendar!
//    @IBOutlet weak var amountLabel: UILabel!
//
//    var startDate: Date!
//    var endDate: Date!
//    var user: User?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Create Circle"
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        navigationItem.leftBarButtonItem = cancelButton
//        navigationItem.rightBarButtonItem = doneButton
//    }
//
//    @objc func cancel() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc func done() {
//
//        let endDate = calendar.selectedDate
//        let postDate = calendar.minimumDate
//        let amount = amountLabel.text!
//
//        let docData: [String: Any] = [
//            "endDate": endDate ?? "",
//            "postDate": postDate,
//            "amount": amount
//        ]
//
//        DataService.instance.createCircle(docData) { (success, error) in
//            if !success {
//                print("ERROR CREATING CIRCLE", error.debugDescription)
//            } else {
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//
//
//
//
//
//
//    @IBAction func sliderValue(_ sender: UISlider) {
//        if sender.tag == 0 {
//            self.amountLabel.text = "\(Int(sender.value)) $"
//        } else {
//            //self.timeLabel.text = "\(Int(sender.value)) days"
//        }
//    }
//
//
//    @IBAction func addAction(_ sender: Any) {
//        if let invite = Invites.inviteDialog() {
//            invite.setInviteDelegate(self)
//
//            // NOTE: You must have the App Store ID set in your developer console project
//            // in order for invitations to successfully be sent.
//
//            // A message hint for the dialog. Note this manifests differently depending on the
//            // received invitation type. For example, in an email invite this appears as the subject.
//            invite.setMessage("Try this out!")
//            //-\(GIDSignIn.sharedInstance().currentUser.profile.name)
//            // Title for the dialog, this is what the user sees before sending the invites.
//            invite.setTitle("Invites Circle")
//            invite.setDeepLink("https://yqg97.app.goo.gl/Zi7X")
//            invite.setCallToActionText("Install!")
//            //invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
//            invite.open()
//        }
//    }
//
//
//    fileprivate let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        return formatter
//    }()
//}
//
//extension CreateCircleVC {
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.endDate = date
//    }
}




