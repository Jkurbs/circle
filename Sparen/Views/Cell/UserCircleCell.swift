//
//  UserCircleCell.swift
//  Sparen
//
//  Created by Kerby Jean on 9/4/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth

class UserCircleCell: UICollectionViewCell {


    var label: UILabel!
    var joinButton: UIButton!
    var imageView: UIImageView!
    var n:Int = 1
    var currentTag = 0
    var users = [User]()
    var badge: UIView!
    var view = UIView()
    
    var circle: Circle! {
        didSet {
            self.configure(circle)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        view.backgroundColor = .white
        contentView.addSubview(view)

        label = UICreator.create.label("", 14, .darkText, .left, .regular, view)
        label.numberOfLines = 4
        joinButton = UICreator.create.button("", nil, UIColor.sparenColor, nil, view)
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        badge = UICreator.create.badge(contentView)
        getInsiders()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(view, label, badge, contentView) { (view, label, badge, contentView) in
            
            view.width == contentView.width - 20
            view.height == contentView.height - 20
            view.center == contentView.center
            
            label.centerY == view.centerY
            label.left == view.left + 90
            label.height == view.height
            label.width == view.width - 70
        }
        
        view.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ circle: Circle) {
        
        if circle.adminId != Auth.auth().currentUser?.uid {
            
            
            let joined = UserDefaults.standard.string(forKey: "circleId")
            if joined != nil {
                joinButton.setTitle("joined", for: .normal)
                joinButton.setTitleColor(.darkGray, for: .normal)
            }
            
            
            
            let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.darkText]
            let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
            let attrs3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.darkText]
            
            let attributedString1 = NSMutableAttributedString(string:"Kerby ", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:"and ", attributes:attrs3)
            let attributedString3 = NSMutableAttributedString(string:"3 others ", attributes:attrs1)
            let attributedString4 = NSMutableAttributedString(string:"wants\nto save ", attributes:attrs3)
            let attributedString5 = NSMutableAttributedString(string:"\(circle.amount). ", attributes:attrs1)
            let attributedString6 = NSMutableAttributedString(string:"starting in 7 days", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            attributedString1.append(attributedString5)
            attributedString1.append(attributedString6)
            
            label.attributedText = attributedString1
        } else {
            label.text = "You have created a Circle of \n $\(circle.amount ?? "Undefined")"
        }
    }
    
    @objc func join() {
        
        let userID = Auth.auth().currentUser!.uid
        let ref =  DataService.call.REF_USERS.document(userID)
        let circleRef = DataService.call.REF_CIRCLES.document(circle.id!)
        
        let joined = UserDefaults.standard.string(forKey: "circleId")
        if joined != nil {
            print("leave")
            ref.updateData(["circle": ""])
            circleRef.collection("users").document(userID).delete { (error) in
                if let error = error {
                    print("Error:", error.localizedDescription)
                } else {
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
                                        } else {
                                            self.joinButton.setTitle("Leave", for: .normal)
                                            self.joinButton.setTitleColor(.darkGray, for: .normal)
                                            //self.parentViewController().showMessage("Congradulation 🎉, You successfully joined this circle", type: .success)
                                            self.parentViewController().present(DashboardVC(), animated: true, completion: nil)
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

extension UserCircleCell {
    
    func getInsiders() {
       // let circleId = UserDefaults.standard.string(forKey: "circleId")
        DataService.call.REF_CIRCLES.document("xQvn5eB1rbl2eRG53B7X").collection("insiders").limit(to: 3).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documents.forEach { diff in
                let data = diff.data()
                let id = diff.documentID
                let count = snapshot.documents.count
                let user = User(key: id, data: data)
                self.users.append(user)
                self.addImages(user, count)
            }
        }
    }
    
    
    func addImages(_ user: User, _ count: Int) {
        imageView = UIImageView()
        imageView.hero.id = "\(user.position ?? 0)"
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.borderColor = UIColor.white
        imageView.borderWidth = 2.0
        imageView.sd_setImage(with: URL(string: user.imageUrl ?? ""), completed: nil)
        imageView.tag = currentTag
        currentTag += 1
        imageView.cornerRadius = imageView.frame.height/2
        view.addSubview(imageView)
        imageView.frame = CGRect(x: Int(12 * (Double(currentTag) / 0.7)), y: 0, width: 30, height: 30)
        imageView.center.y = label.center.y
        imageView.cornerRadius = imageView.frame.height/2
        self.label.text = "\(user.firstName ?? "") and \(count - 1) others would like\nto save $\(circle.amount ?? "Undefined") with you."
        
    }
}
