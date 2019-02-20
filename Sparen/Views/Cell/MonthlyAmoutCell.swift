//
//  MonthlyAmoutCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Cartography


class CircleStateCell: UICollectionViewCell {
    
    var slider = UISlider()
    var label = UILabel()
    var sliderLabel = UILabel()
    var button = UIButton()
    var descLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        contentView.addSubview(slider)
        contentView.addSubview(sliderLabel)
        contentView.addSubview(button)
        contentView.addSubview(descLabel)
        
        slider.maximumValue = 5000
        slider.minimumValue = 1000
        
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)

        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        label.textColor = color
        label.font = font
        label.numberOfLines = 4
        
        sliderLabel.font = UIFont.systemFont(ofSize: 13)
        sliderLabel.adjustsFontSizeToFitWidth = true
        sliderLabel.textColor = color
        sliderLabel.text = "$1000"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        contentView.backgroundColor = UIColor.backgroundColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        slider.tintColor = UIColor(white: 0.5, alpha: 1.0)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)) , for: .valueChanged)
        
        constrain(label, slider, sliderLabel, descLabel, button, contentView) { (label, slider, sliderLabel, descLabel, button, contentView) in
            
            label.top == contentView.top + 20
            label.leading == contentView.leading + 30
            label.trailing == contentView.trailing + 20
            
            slider.top == label.bottom + 10
            slider.leading == label.leading
            slider.trailing == contentView.trailing - 100
            
            sliderLabel.top == label.bottom + 10
            sliderLabel.right == slider.right + 60
            sliderLabel.centerY == slider.centerY
            
            descLabel.top == slider.bottom + 10
            descLabel.leading == contentView.leading + 30
            descLabel.right == contentView.right - 20
            
            button.top == contentView.bottom - 60
            button.centerX == contentView.centerX
            button.width == contentView.width - 20
            button.height == 45
        }
        
        descLabel.numberOfLines = 2
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.gray
        descLabel.text = "Set the goal you and each member would like to spare"

        button.setTitle("Activate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(red: 232.0/255.0, green:  126.0/255.0, blue:  4.0/255.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(activateCircle), for: .touchUpInside)
        
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        self.layer.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
        self.layer.mask = rectShape
    }
    
    
    @objc func activateCircle() {
        let circleId  = UserDefaults.standard.string(forKey: "circleId") ?? ""
        let ref =  DataService.call.REF_CIRCLES.document(circleId)

        let insidersRef = ref.collection("insiders")
        insidersRef.getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("error:", error)
            } else {
                let count = snapshot!.count
                if count < 3 {
                    self.alert(title: "Not enought people", message: "Your Circle must have at least 3 trusted ones")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        let position = data["position"] as! Int
                        
                        let ref = document.reference
                        self.simpleTransaction(ref: ref, position: position)
                    }
                    
                    let totalAmount = Int(self.slider.value)
                    let weeklyAmount = totalAmount / count

                    
                    let days_total = count * 7
                    let days_left = days_total - 1
                    
                    let data = ["days_total": days_total, "days_left": days_left, "weekly_amount": weeklyAmount, "total_amount" : totalAmount, "date": FieldValue.serverTimestamp()] as [String : Any]
                    
                    ref.collection("insight").addDocument(data: data, completion: { (error) in
                        if let error = error {
                            print("error", error.localizedDescription)
                        } else {
                            ref.setData(["activated": true], merge: true) { (error) in
                                if let error = error {
                                    print("Error:", error.localizedDescription)
                                } else {
                                    print("SUCCESS")
                                }
                            }
                            print("SUCCESS")
                        }
                    })
                }
            }
        })
    }
    
    
    private func simpleTransaction(ref : DocumentReference, position: Int) {
        // [START simple_transaction]
        
        let db = Firestore.firestore()
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(ref)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            transaction.updateData(["days_left": 7 * position], forDocument: ref)
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
        // [END simple_transaction]
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
    
    
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        sliderLabel.text = "$\(Int(slider.value))"
    }

    
    func configure(_ text: String, _ circle: Circle) {

        if circle.activated! == false && circle.adminId! == Auth.auth().currentUser?.uid {
            
        }

        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            label.text = firstName + "" + ", how much money would you like\nto spare?"
        }
    }
}


class LearnMoreCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.backgroundColor

        contentView.addSubview(label)
        
        let font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        label.textColor = contentView.tintColor
        label.font = font
        label.numberOfLines = 4
        label.textAlignment = .center
        label.text = "Learn more"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, contentView) { (label, contentView) in
            label.edges == contentView.edges
        }
    }
}