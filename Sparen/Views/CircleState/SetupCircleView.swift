//
//  SetupCircleView.swift
//  Sparen
//
//  Created by Kerby Jean on 8/14/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Cartography

class SetupCircleView: UIView {
    
    var label = UILabel()
    var button = UIButton()
    var descLabel = UILabel()
    var textField: UITextField!
    var circle: Circle!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)
       
        self.addSubview(button)
        self.addSubview(descLabel)
        
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        label.textColor = color
        label.font = font
        label.numberOfLines = 4
        
        button.setTitle("Activate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.sparenColor, for: .normal)
        button.addTarget(self, action: #selector(activateCircle), for: .touchUpInside)
        
        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            label.text = firstName + "" + ", activate the circle whenever you feel ready."
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        constrain(label, descLabel, button, self) { (label, descLabel, button, view) in
            
            label.top == view.top
            label.height == 60
            label.leading == view.leading + 20
            label.trailing == view.trailing - 20
            
            button.top == label.bottom + 30
            button.centerX == view.centerX
            button.height == 45
            button.width == 100
        }
        
        descLabel.numberOfLines = 2
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.gray

    }

    
    @objc func activateCircle() {
        guard let circleId  = circle.id ?? UserDefaults.standard.string(forKey: "circleId") else {return}
        
        let ref =  DataService.call.REF_CIRCLES.document(circleId)
        let usersRef = ref.collection("users")
        
        usersRef.getDocuments { (snapshot, error) in
            guard let snap = snapshot else {return}
            let count = snap.count
            if count < 3 {
                self.alert(title: "Not enought people", message: "Your Circle must have at least 3 people.")
                return
            } else {
                for document in snap.documents {
                    if document.exists {
                        let data = document.data()
                        guard let position = data["position"] as? Int else {return}
                        let days_left = position * 7
                        let daysData = ["days_left": days_left]
                        document.reference.setData(daysData, merge: true)
                        document.reference.collection("insights").document("activities").setData(daysData, merge: true)
                    }
                }
                
                let totalAmount = Int(self.circle.amount!) ?? 0
                let weeklyAmount = totalAmount / count
                
                let days_total = count * 7
                let days_left = days_total - 1
                
                let data = ["days_total": days_total, "days_left": days_left, "weekly_amount": weeklyAmount, "total_amount" : totalAmount, "date": FieldValue.serverTimestamp()] as [String : Any]
                ref.updateData(["activated": true])
                ref.collection("insights").document("activities").setData(data, merge: true)
                
            }
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let action2 = UIAlertAction(title: "Invite", style: .default) { (action) in
        }
        alert.addAction(action)
        alert.addAction(action2)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
}
