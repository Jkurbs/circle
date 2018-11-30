//
//  SetupCell.swift
//  Sparen
//
//  Created by Kerby Jean on 9/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import SDWebImage
import CountdownLabel
import FirebaseDatabase

class SetupCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var label: UILabel!
    
    var countdownLabel = CountdownLabel()    
    
    var pulsator = Pulsator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = .backgroundColor
        
        label = UICreator.create.label("", 16, .darkText, .left, .regular, contentView)
        label.textAlignment = .center
       
        contentView.addSubview(countdownLabel)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, countdownLabel, contentView) { (label, countdownLabel, contentView)  in
            label.top == contentView.bottom - 60
            label.height == 60
            label.centerX == contentView.centerX
        }
    }
    
    
    func configure(_ count: Int) {
        let circleID = UserDefaults.standard.string(forKey: "circleId")
        pulse()

        self.countdownLabel.text = ""
        if count < 5 {
            let difference = 5 - count
            if difference > 1 {
                label.text = "Waiting for \(difference) more users to join."
            } else {
                label.text = "Waiting for \(difference) more user to join."
            }
        } else {
                label.text = "Activating..."
//            DataService.call.RefCircles.child(circleID!).observeSingleEvent(of: .value) { (snapshot) in
//                guard let value = snapshot.value else {return}
//                let key = snapshot.key
//                let postDict = value as? [String : AnyObject] ?? [:]
//
//                let circle = Circle(key: key, data: postDict)
//
////                DataService.call.activateCircle(circle) { (success, error) in
////                    if !success {
////                        print("error:", error!.localizedDescription)
////                    } else {
////                        print("success")
////                    }
////                }
//            }

//            let circleID = UserDefaults.standard.string(forKey: "circleId")
//
//            titleLabel.text = "Time before activation"
//            contentView.addSubview(countdownLabel)
//
//            let ref = DataService.call.RefBase.child("timer").child(circleID!)
//            ref.keepSynced(true)
//
//            let refCircle = DataService.call.RefCircles.child(circleID!).child("activated")
//            //refCircle.keepSynced(true)
//
//            ref.updateChildValues(["start": ServerValue.timestamp()]) { (error, ref) in
//                if let err = error {
//                    print("error:", err.localizedDescription)
//                } else {
//                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                        guard let value = snapshot.value  else {return}
//
//                        let postDict = value as? [String : AnyObject] ?? [:]
//                        let start = postDict["start"] as! TimeInterval
//
//                        guard let endDateString = postDict["end_date"] as? String else {return}
//
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        let endDate = formatter.date(from: endDateString)
//
//                        let date = Date(timeIntervalSince1970: start/1000)
//
//                        let timeInterval = endDate?.timeIntervalSince(date)
//
//                        self.countdownLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//                        self.countdownLabel.addTime(time: timeInterval!)
//                        self.countdownLabel.start()
//
//
//                        if self.countdownLabel.isFinished {
//                           print("DONE")
//                        }
//                    })
//                }
//            }
//            label.text = ""
//        }
        }
    }

    
    func pulse() {
        pulsator.numPulse = 2
        pulsator.radius = 30.0
        pulsator.backgroundColor = UIColor.sparenColor.cgColor
        pulsator.start()
        pulsator.position = CGPoint(x: contentView.center.x, y: contentView.center.y)
        contentView.layer.addSublayer(pulsator)
    }
}

