//
//  ReadyView.swift
//  Sparen
//
//  Created by Kerby Jean on 8/14/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import Cartography
import FirebaseFirestore
import Lottie

class ReadyView: UIView {
    
    var label: UILabel!
    var imageView: UIImageView!
    var button: UIButton!
    var notifyLabel: UILabel!
    
    
    private var pulseAnimation: LOTAnimationView?

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white

        
       label = UICreator.create.label("Let everyone know that you're ready.", 17, UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0), .center, .semibold, self)
    
        notifyLabel = UICreator.create.label("A notification will be sent to the admin.", 17, UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0), .center, .regular, self)
        
        button = UICreator.create.button("Ready to start", nil, .sparenColor, nil, self)
        button.addTarget(self, action: #selector(ready), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, notifyLabel, button, self) { (label, notifyLabel, button, view) in
            
            label.top == view.top + 20
            label.width == view.width
            
            notifyLabel.top == label.bottom + 5
            notifyLabel.width == view.width
            
            button.top == notifyLabel.bottom + 30
            button.width == view.width
            
        }
        
        if UserDefaults.standard.bool(forKey: "ready") {
            self.label.text = ""
            self.notifyLabel.text = "Notification sent"
            self.button.setTitle("You're ready", for: .normal)
            self.button.isEnabled = false
            self.button.alpha = 0.5
        }
    }

    
    @objc func ready() {
        DataService.call.REF_USERS.document((Auth.auth().currentUser?.uid)!).updateData(["status": "ready"], completion: { (error) in
            if let error = error {
                print("error:", error.localizedDescription)
            } else {
                UserDefaults.standard.set(true, forKey: "ready")
                self.label.text = ""
                self.notifyLabel.text = "Notification sent"
                self.button.setTitle("You're ready", for: .normal)
                self.button.isEnabled = false
                self.button.alpha = 0.5
            }
        })
    }
}
