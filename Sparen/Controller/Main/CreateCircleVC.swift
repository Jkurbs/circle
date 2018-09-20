//
//  CreateCircleVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth
import GSMessages
import FirebaseFirestore


class CreateCircleVC: UIViewController {

    var user: User?

    var label: UILabel!
    var descLabel: UILabel!
    var textField: UITextField!
    var button: UIButton!
    var infoButton = UIButton()
    
    var hashes = [UIButton : [Double]]()
    var buttons = [UIButton]()
    
    
    var suggestions = ["$1,000.00", "$2,500.00" , "$4,000.00"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .backgroundColor
        self.title = "Create a circle"
        
        label = UICreator.create.label("", 30, .darkText, .center, .regular, view)
        descLabel = UICreator.create.label("\(user?.firstName ?? "") How much money would you like to save?", 20, .darkText, .center, .medium, view)
        
        textField = UICreator.create.textField("Amount", .numberPad, view)
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        textField.textAlignment = .center


        infoButton.setImage(#imageLiteral(resourceName: "Info-20"), for: .normal)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.clipsToBounds = true
        infoButton.addTarget(self, action: #selector(info), for: .touchUpInside)
        
        view.addSubview(infoButton)
        
        button = UICreator.create.button("Create", nil, .sparenColor, .white, view)
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowRadius = 5.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.textField.becomeFirstResponder()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        constrain(descLabel, textField, infoButton, button, view) { (descLabel, textField, infoButton, button, view) in

            descLabel.top == view.top + 150
            descLabel.height == 100
            descLabel.width == view.width - 100
            descLabel.centerX == view.centerX

            textField.top == descLabel.bottom + 50
            textField.width == view.width - 150
            textField.height == 60
            textField.centerX == view.centerX
            
            infoButton.top == textField.top
            infoButton.left == textField.right
            infoButton.centerY == textField.centerY
            infoButton.height == textField.height
            infoButton.width == textField.height
            
            button.top == descLabel.bottom + 200
            button.width == view.width - 100
            button.height == 50
            button.centerX == view.centerX
            
        }
        button.cornerRadius = 25
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
        
        if (textField.text?.isEmpty)! {
            button.isEnabled = false
            button.alpha = 0.5
        } else {
            button.isEnabled = true
            button.alpha = 1.0
        }
    }
    
    @objc func create() {
        let amount = Int((textField.text?.replacingOccurrences(of: "$", with: ""))!)
        let userID = Auth.auth().currentUser!.uid
        let data: [String: Any] = ["activated": false, "admin": userID, "amount": amount ?? ""]
        let ref = Firestore.firestore().collection("circles").document()
        let circleID = ref.documentID
        ref.setData(data) { (error) in
            if let error = error {
                print("error creating circle:", error.localizedDescription)
                self.showMessage("An error occured. Try again", type: .error)
            } else {
                DataService.call.createLink(circleID: ref.documentID, completion: { (success, error, link) in
                    if !success {
                        self.showMessage("An error occured. Try again", type: .error)
                    } else {
                        DataService.call.REF_USERS.document(userID).setData(["circle": ref.documentID], merge: true)
                        DataService.call.REF_CIRCLES.document(circleID).setData(["link": link], merge: true)
                        DataService.call.REF_USERS.document(userID).getDocument(completion: { (snapshot, error) in
                            guard let snap = snapshot else {
                                print("error creating circle")
                                self.showMessage("An error occured. Try again", type: .error)
                                return
                            }
                            
                            if snap.exists {
                                if let data = snap.data() {
                                    DataService.call.REF_CIRCLES.document(circleID).collection("users").document(userID).setData(data)
                                    self.showMessage("Circle is successfully created", type: .success)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
     @objc func info() {
        
        textField.resignFirstResponder()
        GSMessage.infoBackgroundColor = .white
        self.showMessage("This is the total amount you and anybody who join your Circle will receive.", type: .info, options: [
            .autoHide(false),
            .height(150.0),
            .position(.bottom),
            .cornerRadius(20.0),
            .textColor(.darkText),
            .textNumberOfLines(6),
            .showShadow(true),
            .hideOnTap(true)
        ])
    }
}
