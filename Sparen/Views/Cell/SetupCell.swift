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
import FirebaseDatabase

class SetupCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var label: UILabel!
    
    var pulsator = Pulsator()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        label = UICreator.create.label("", 16, .darkText, .left, .regular, contentView)
        label.textAlignment = .center
       
//        contentView.addSubview(countdownLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pulse), name: .pulse, object: nil)
        
        pulse()

    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, contentView) { (label, contentView)  in
            label.top == contentView.bottom - 80
            label.height == 60
            label.centerX == contentView.centerX
        }
    }
    
    
    func configure(_ count: Int) {
//        pulse()

//        self.countdownLabel.text = ""
        if count < 5 {
            let difference = 5 - count
            if difference > 1 {
                label.text = "Waiting for \(difference) more users to join."
            } else {
                label.text = "Waiting for \(difference) more user to join."
            }
        } else {
//                label.text = "Activating..."
                label.text = "Waiting for "

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

    
    @objc func pulse() {
        pulsator.numPulse = 2
        pulsator.radius = 30.0
        pulsator.backgroundColor = UIColor.sparenColor.cgColor
        pulsator.start()
        pulsator.position = CGPoint(x: contentView.center.x, y: 50)
        contentView.layer.addSublayer(pulsator)
    }
}

// MARK: OptionCell

import FirebaseAuth

class OptionCell: UICollectionViewCell {
    
    var leaveButton: UIButton!
    var inviteButton: UIButton!
    var positionButton: UIButton!
    var view = UIView()
    var shadowView = UIView()
    var label: UILabel!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white

        let color = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        leaveButton = UICreator.create.button("Leave", nil, .gray, nil, self.shadowView)
        leaveButton.addTarget(self, action: #selector(leave), for: .touchUpInside)
        
        inviteButton = UICreator.create.button("Add Friends", nil, .sparenColor , nil, self.shadowView)
        inviteButton.addTarget(self, action: #selector(invite), for: .touchUpInside)
        
        positionButton = UICreator.create.button("Positions", nil, .gray , nil, self.shadowView)
        positionButton.addTarget(self, action: #selector(position), for: .touchUpInside)
        
        leaveButton.titleLabel?.font = font
        positionButton.titleLabel?.font = font
        inviteButton.titleLabel?.font = font
        
        view.backgroundColor = color
        
        shadowView.backgroundColor = .white
        
        shadowView.layer.cornerRadius = 10
        shadowView.shadowRadius = 5.0
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.shadowOpacity = 0.2
        
        contentView.addSubview(shadowView)
        contentView.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(shadowView, leaveButton, positionButton, inviteButton, view, contentView) { (shadowView, leaveButton, positionButton, inviteButton, view, contentView)  in
            
           shadowView.width == contentView.width - 5
           shadowView.height == contentView.height - 5
           shadowView.center == contentView.center
            
           leaveButton.height == shadowView.height
           leaveButton.width == shadowView.width/3
           leaveButton.left == shadowView.left
            
           positionButton.height == shadowView.height
           positionButton.width == leaveButton.width
           positionButton.centerX == shadowView.centerX

           inviteButton.height == shadowView.height
           inviteButton.width == leaveButton.width
           inviteButton.right == shadowView.right
           
//           view.centerX == contentView.centerX
//           view.height == contentView.height
//           view.width == 1
        }
    }

    
    @objc func leave() {
        
        DataService.call.RefUsers.child(Auth.auth().currentUser!.uid).child("position").observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as! Int
            
            let position = ["position": value]
            
            
            NotificationCenter.default.post(name: .leave, object: position)
        }
    }
    
    @objc func position() {
        let nav = UINavigationController(rootViewController: PositionVC())
        self.parentViewController().present(nav, animated: true, completion: nil)
    }
    
    @objc func invite() {
        let nav = UINavigationController(rootViewController: InviteVC())
        self.parentViewController().present(nav, animated: true, completion: nil)
    }
}

