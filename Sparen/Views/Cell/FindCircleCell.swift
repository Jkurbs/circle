//
//  FindCircleCell.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth
import FirebaseMessaging
import SDWebImage
import Cartography

//class FindCircleCell: UICollectionViewCell {
//
//    var label: UILabel!
//    var joinButton = LoadingButton()
//    var imageView: UIImageView!
//    var indicator: UIActivityIndicatorView!
//    var n:Int = 1
//    var currentTag = 0
//    var users = [User]()
//
//    var circle: Circle! {
//        didSet {
//            self.configure(circle)
//        }
//    }
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        contentView.backgroundColor = .white
//        label = UICreator.create.label("", 14, .darkText, .left, .regular, contentView)
//        label.sizeToFit()
//        joinButton.setTitle("Join", for: .normal)
//        joinButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
//        joinButton.setTitleColor(UIColor.sparenColor, for: .normal)
//        contentView.addSubview(joinButton)
//
//        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
//        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        joinButton.cornerRadius = 5
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    @objc func join() {
//
//
//        joinButton.showLoading()
//
//        let joined = UserDefaults.standard.string(forKey: "circleId")
//        if joined == circle.id {
//            DataService.call.leaveCircle(circle) { (success, error) in
//                if !success {
//                    print("error:", error!.localizedDescription)
//                    self.joinButton.hideLoading()
//                } else {
//                    self.joinButton.setTitle("Join", for: .normal)
//                    self.joinButton.setTitleColor(.sparenColor, for: .normal)
//                    self.joinButton.hideLoading()
//                }
//            }
//        } else {
//            DataService.call.joinCircle(circle) { (success, error) in
//                if !success {
//                    print("error:", error!.localizedDescription)
//                    self.joinButton.hideLoading()
//                } else {
//                    self.joinButton.setTitle("Joined", for: .normal)
//                    self.joinButton.setTitleColor(.darkGray, for: .normal)
//                    self.joinButton.hideLoading()
//                }
//            }
//        }
//    }
//}
//
//extension FindCircleCell {
//
//    func configure(_ circle: Circle) {
//        let joined = UserDefaults.standard.string(forKey: "circleId")
//        if joined == circle.id {
//            joinButton.setTitle("joined", for: .normal)
//            joinButton.setTitleColor(.darkGray, for: .normal)
//        }
//
//        self.users.removeAll()
//
//        DataService.call.findCircleMembers(circle.id!) { (success, error, user, count) in
//            if !success {
//                print("error finding members")
//            } else {
//                self.users.append(user)
//                self.addImages(user, count, circle)
//            }
//        }
//    }
//
//
//    func addImages(_ user: User, _ count: Int, _ circle: Circle) {
//        print("add:", count)
//        self.imageView = UIImageView()
//        imageView.backgroundColor = .lightGray
//        imageView.contentMode = .scaleAspectFill
//        self.imageView.sd_setImage(with: URL(string: user.imageUrl ?? ""), completed: nil)
//        self.imageView.tag = self.currentTag
//        self.currentTag += 1
//        let x = Int(12 * (Double(self.currentTag) / 0.7))
//        self.imageView.frame = CGRect(x: x, y: 0, width: 30, height: 30)
//        self.imageView.center.y = self.contentView.center.y
//        self.imageView.clipsToBounds = true
//        self.imageView.cornerRadius = self.imageView.frame.height/2
//        self.imageView.borderColor = UIColor.white
//        self.imageView.borderWidth = 2.0
//        self.contentView.addSubview(self.imageView)
//
//
//
//        constrain(joinButton, contentView) { (joinButton, view) in
//
//            joinButton.right == view.right - 15
//            joinButton.centerY == view.centerY
//            joinButton.height == 30
//            joinButton.width == 70
//        }
//
//        label.frame = CGRect(x: 70 + (currentTag * 6), y: 0, width: Int(contentView.frame.width - joinButton.frame.width ), height: 0)
//
//
//        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.darkText]
//
//        let attrs3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.darkText]
//
//
//         var attributedString1 = NSMutableAttributedString()
//         var attributedString2 = NSMutableAttributedString()
//         var attributedString3 = NSMutableAttributedString()
//
//
//        if count > 2 {
//             attributedString1 = NSMutableAttributedString(string:"\(user.firstName ?? "") ", attributes:attrs1)
//             attributedString2 = NSMutableAttributedString(string:"and ", attributes:attrs3)
//             attributedString3 = NSMutableAttributedString(string:"\(count - 1) others ", attributes:attrs1)
//
//        } else {
//             attributedString1 = NSMutableAttributedString(string:"\(user.firstName ?? "") ", attributes:attrs1)
//             attributedString3 = NSMutableAttributedString(string:"", attributes:attrs1)
//        }
//
//        let attributedString4 = NSMutableAttributedString(string:"wants to save ", attributes:attrs3)
//        let attributedString5 = NSMutableAttributedString(string:"$1000. ", attributes:attrs1)
//
//        attributedString1.append(attributedString2)
//        attributedString1.append(attributedString3)
//        attributedString1.append(attributedString4)
//        attributedString1.append(attributedString5)
//
//        label.attributedText = attributedString1
//    }
//
//    func alert() {
//        let alert = UIAlertController(title: "Add payment method", message: "A payment method must be added before you can join a Circle.", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
//            let settingsVC = SettingsVC()
//            self.parentViewController().navigationController?.pushViewController(settingsVC, animated: true)
//        }
//        alert.addAction(action)
//        self.parentViewController().present(alert, animated: true, completion: nil)
//    }
//}


//class FindCircleCell: UICollectionViewCell {
//    
//    var imageView: UIImageView!
//    var label: UILabel!
//    var timeLabel: UILabel!
//    var joinButton = LoadingButton()
//    var request: Request!
//    
//    let separator: CALayer = {
//        let layer = CALayer()
//        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
//        return layer
//    }()
//    
//    var circle: Circle! {
//        didSet {
//            self.configure(circle)
//        }
//    }
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        imageView = UICreator.create.imageView(nil, contentView)
//        label = UICreator.create.label("", 13, .darkText, .left, .regular, contentView)
//        label.sizeToFit()
//        timeLabel = UICreator.create.label("", 16, .lightGray, .natural, .light, contentView)
//        
//        joinButton.setTitle("Join", for: .normal)
//        joinButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
//        joinButton.setTitleColor(UIColor.sparenColor, for: .normal)
//        contentView.addSubview(joinButton)
//        
//        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
//        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        joinButton.cornerRadius = 5
//
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        constrain(imageView, label, timeLabel, joinButton, contentView) { (imageView, label, timeLabel, joinButton, contentView) in
//
//            imageView.left == contentView.left + 15
//            imageView.centerY == contentView.centerY
//            imageView.width == 40
//            imageView.height == 40
//            
//            label.left == imageView.right + 15
//            label.centerY == contentView.centerY
//            
//            timeLabel.left == label.right + 5
//            
//            joinButton.right == contentView.right - 15
//            joinButton.centerY == contentView.centerY
//            joinButton.height == 25
//            joinButton.width == 80
//            label.right == joinButton.left + 20
//        }
//        
//        dispatch.async {
//            self.imageView.cornerRadius = self.imageView.frame.height/2
//        }
//    }
//
//    
//    func configure(_ circle: Circle) {
//        
//        if let members = circle.members {
//            
//            let joined = UserDefaults.standard.string(forKey: "circleId")
//            if joined == circle.id {
//                joinButton.setTitle("joined", for: .normal)
//                joinButton.setTitleColor(.darkGray, for: .normal)
//            }
//            
//            fetchImage(circle.adminId!)
//            imageView.image = UIImage(named: "three")
//            
//            
//            let time = convertDate(postDate: 0)
//            
//            let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor.darkText]
//            
//            let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.darkText]
//            
//            let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
//            
//            let myMutableString = NSMutableAttributedString(string: "Kurbs", attributes: attrs)
//            
//            let attributedString1: NSMutableAttributedString!
//            
//            if members > 1 {
//                 attributedString1 = NSMutableAttributedString(string:" and \(members) others wants\nto save \(circle.amount ?? 0)$ ", attributes: attrs1)
//            } else {
//                 attributedString1 = NSMutableAttributedString(string:"wants to save\n\(circle.amount ?? 0)$ ", attributes: attrs1)
//            }
//            let attributedString2 = NSMutableAttributedString(string: time, attributes: attrs2)
//            
//            myMutableString.append(attributedString1)
//            myMutableString.append(attributedString2)
//            
//            label.attributedText = myMutableString
//        }
//    }
//    
//    func fetchImage(_ userId: String)  {
//        DataService.call.RefUsers.child(userId).child("image_url").observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let value = snapshot.value else {return}
//            let url = value as! String
//            self.imageView.sd_setImage(with: URL(string: url), completed: nil)
//            
//        })
//    }
//    
//    @objc func join() {
//        
//        joinButton.showLoading()
//        
//        let joined = UserDefaults.standard.string(forKey: "circleId")
//        
//        
////        DataService.call.joinCircle(circle) { (success, error) in
////            if !success {
////                print("error:", error!.localizedDescription)
////                self.joinButton.hideLoading()
////            } else {
////                self.joinButton.setTitle("Joined", for: .normal)
////                self.joinButton.setTitleColor(.darkGray, for: .normal)
////                self.joinButton.hideLoading()
////            }
////        }
//        
//        
//        
////        if joined == circle.id {
////            DataService.call.leaveCircle(circle) { (success, error) in
////                if !success {
////                    print("error:", error!.localizedDescription)
////                    self.joinButton.hideLoading()
////                } else {
////                    self.joinButton.setTitle("Join", for: .normal)
////                    self.joinButton.setTitleColor(.sparenColor, for: .normal)
////                    self.joinButton.hideLoading()
////                }
////            }
////        } else {
////            DataService.call.joinCircle(circle) { (success, error) in
////                if !success {
////                    print("error:", error!.localizedDescription)
////                    self.joinButton.hideLoading()
////                } else {
////                    self.joinButton.setTitle("Joined", for: .normal)
////                    self.joinButton.setTitleColor(.darkGray, for: .normal)
////                    self.joinButton.hideLoading()
////                }
////            }
////        }
//    }
//}
//
//
