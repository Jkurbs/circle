//
//  MonthlyAmoutCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import FirebaseFirestore


class MonthlyAmoutCell: UICollectionViewCell {
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.width
        
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let color = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        label.textColor = color
        label.font = font
        label.numberOfLines = 4
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive=true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive=true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive=true

        
        slider.tintColor = UIColor(white: 0.5, alpha: 1.0)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)) , for: .valueChanged)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive=true
        slider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive=true
        slider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive=true
        slider.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)

        
        
        sliderLabel.center.y = slider.center.y
        sliderLabel.font = UIFont.systemFont(ofSize: 13)
        sliderLabel.adjustsFontSizeToFitWidth = true
        sliderLabel.textColor = color
        sliderLabel.text = "1000 dollars"
        
        descLabel.frame = CGRect(x: 25, y: slider.frame.maxY + 10, width: width - 50, height: 35)
        descLabel.numberOfLines = 2
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.gray
        descLabel.text = "Set the goal you and each member of your circle would like to reach"
        
        //button.frame = CGRect(x: 0, y: descLabel.frame.maxY + 25, width: width - 50, height: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        button.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive = true
        button.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 3).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

        

        //button.center.x = self.center.x
        button.cornerRadius = 10
        button.setTitle("Activate Circle", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        //button.backgroundColor = UIColor(red: 232.0/255.0, green:  126.0/255.0, blue:  4.0/255.0, alpha: 1.0)
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
            print("INVITE")
        }
        alert.addAction(action)
        alert.addAction(action2)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        sliderLabel.text = "\(Int(slider.value)) dollars"
    }

    
    func configure(_ text: String) {
        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            label.text = firstName + "" + ", how much money would you like to spare?"
        }
    }
}
