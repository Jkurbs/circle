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

class FindCircleCell: UICollectionViewCell {
    
    var label: UILabel!
    var joinButton: UIButton!
    var imageView: UIImageView!
    var n:Int = 1
    var currentTag = 0
    var users = [User]()
    
    var circle: Circle! {
        didSet {
            self.configure(circle)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        label = UICreator.create.label("", 14, .darkText, .left, .regular, contentView)
        joinButton = UICreator.create.button("Join", nil, UIColor.sparenColor, nil, contentView)
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(label, joinButton, contentView) { (label, joinButton, contentView) in
            label.centerY == contentView.centerY
            label.left == contentView.left + 90
            joinButton.right == contentView.right - 15
            joinButton.centerY == contentView.centerY
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func join() {
        
        let userID = Auth.auth().currentUser!.uid
        let ref =  DataService.call.REF_USERS.document(userID)
        let circleRef = DataService.call.REF_CIRCLES.document(circle.id!)
        
        let joined = UserDefaults.standard.string(forKey: "circleId")
        if joined == circle.id {
            ref.updateData(["circle": ""])
            circleRef.collection("users").document(userID).delete { (error) in
                if let error = error {
                    print("Error:", error.localizedDescription)
                } else {
                    Messaging.messaging().unsubscribe(fromTopic: self.circle.id!)
                    UserDefaults.standard.removeObject(forKey: "circleId")
                    self.parentViewController().showMessage("You successfully left the circle", type: .success)
                    self.joinButton.setTitle("Join", for: .normal)
                    self.joinButton.setTitleColor(.sparenColor, for: .normal)
                }
            }
        } else {
            UserDefaults.standard.set(circle.id, forKey: "circleId")
            ref.setData(["circle": circle.id ?? ""], merge: true) { (error) in
                if let error = error {
                    print("error:", error.localizedDescription)
                } else {
                    ref.getDocument(completion: { (snapshot, error) in
                        if let error = error {
                            print("error:", error.localizedDescription)
                        } else {
                            if let snap = snapshot {
                                if let data = snap.data() {
                                    circleRef.collection("users").document(userID).setData(data, merge: true, completion: { (error) in
                                        if let error = error {
                                            print("error:", error.localizedDescription)
                                            return
                                        } else {
                                        Messaging.messaging().subscribe(toTopic: self.circle.id!) { error in
                                        if let error = error  {
                                                print("error:", error.localizedDescription)
                                                return
                                            }
                                        }
                                            
                                        self.joinButton.setTitle("Leave", for: .normal)
                                        self.joinButton.setTitleColor(.darkGray, for: .normal)
                                        self.parentViewController().navigationController?.pushViewController(DashboardVC(), animated: true)
                                        }
                                    })
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}

extension FindCircleCell {
    
    func configure(_ circle: Circle) {
        
        let joined = UserDefaults.standard.string(forKey: "circleId")
        if joined == circle.id {
            joinButton.setTitle("joined", for: .normal)
            joinButton.setTitleColor(.darkGray, for: .normal)
        }
        
        
        DataService.call.REF_CIRCLES.document(circle.id!).collection("users").limit(to: 3).getDocuments { (snapshot, error) in
            
            guard let snap = snapshot else {
                return
            }
            
            for doc in snap.documents {
                if doc.exists {
                    let key = doc.documentID
                    let data = doc.data()
                    let user = User(key: key, data: data)
                    self.users.append(user)
                    self.addImages(user, snap.documents.count, circle)
                    
                }
            }
        }
    }
    
    
    func addImages(_ user: User, _ count: Int, _ circle: Circle) {
        self.imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        self.imageView.sd_setImage(with: URL(string: user.imageUrl ?? ""), completed: nil)
        self.imageView.tag = self.currentTag
        self.currentTag += 1
        self.imageView.frame = CGRect(x: Int(12 * (Double(self.currentTag) / 0.7)), y: 0, width: 30, height: 30)
        self.imageView.center.y = self.contentView.center.y
        self.imageView.clipsToBounds = true
        self.imageView.cornerRadius = self.imageView.frame.height/2
        self.imageView.borderColor = UIColor.white
        self.imageView.borderWidth = 2.0
        self.contentView.addSubview(self.imageView)
        
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        let attrs3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
        let attributedString1 = NSMutableAttributedString(string:"\(user.firstName ?? "") ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"and ", attributes:attrs3)
        var attributedString3 = NSMutableAttributedString()
        
        if count > 2 {
             attributedString3 = NSMutableAttributedString(string:"\(count - 1) others ", attributes:attrs1)
        } else {
             attributedString3 = NSMutableAttributedString(string:"\(count - 1) other ", attributes:attrs1)
        }
        
        let attributedString4 = NSMutableAttributedString(string:"wants\nto save ", attributes:attrs3)
        let attributedString5 = NSMutableAttributedString(string:"$1000. ", attributes:attrs1)
        let attributedString6 = NSMutableAttributedString(string:"starting in 7 days", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
        attributedString1.append(attributedString5)
        attributedString1.append(attributedString6)
        
        label.attributedText = attributedString1
    }
    
    func alert() {
        let alert = UIAlertController(title: "Add payment method", message: "A payment method must be added before you can join a Circle.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            let settingsVC = SettingsVC()
            self.parentViewController().navigationController?.pushViewController(settingsVC, animated: true)
        }
        alert.addAction(action)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
}
