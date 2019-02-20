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
            label.text = "You have created a Circle of \n $\(circle.amount ?? 0)"
        }
    }
    
    @objc func join() {
        
//        DataService.call.joinCircle(circle) { (success, error) in
//            if !success {
//                print("error:", error!.localizedDescription)
//            } else {
//                //self.parentViewController().showMessage("You successfully join the circle", type: .success)
//                self.joinButton.setTitle("Joined", for: .normal)
//                self.joinButton.setTitleColor(.darkGray, for: .normal)
//                
//            }
//            
//        }

//        let circleId = UserDefaults.standard.string(forKey: "circleId")
//        if circleId != nil {
//
//            DataService.call.leaveCircle(circle) { (success, error) in
//                if !success {
//                    print("error:", error!.localizedDescription)
//                } else {
//                    //self.parentViewController().showMessage("You successfully left the circle", type: .success)
//                    self.joinButton.setTitle("Join", for: .normal)
//                    self.joinButton.setTitleColor(.sparenColor, for: .normal)
//                }
//            }
//        } else {
//
//            DataService.call.joinCircle(circle) { (success, error) in
//                if !success {
//                    print("error:", error!.localizedDescription)
//                } else {
//                    //self.parentViewController().showMessage("You successfully join the circle", type: .success)
//                    self.joinButton.setTitle("Joined", for: .normal)
//                    self.joinButton.setTitleColor(.darkGray, for: .normal)
//
//                }
//
//            }
//        }
    }
}

extension UserCircleCell {
    
    func getInsiders() {
        guard let circleId = UserDefaults.standard.string(forKey: "circleId") else {return}
        
        DataService.call.RefCircleMembers.child(circleId).queryLimited(toFirst: 3).observe(.childAdded) { (snapshot) in
            
            guard let value = snapshot.value else {return}
            
            let postDict = value as? [String : AnyObject] ?? [:]
            let key = snapshot.key
            let user = User(key: key, data: postDict)
            
            
        }
        
//        
//        DataService.call.REF_CIRCLES.document("xQvn5eB1rbl2eRG53B7X").collection("insiders").limit(to: 3).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//            
//            snapshot.documents.forEach { diff in
//                let data = diff.data()
//                let id = diff.documentID
//                let count = snapshot.documents.count
//                let user = User(key: id, data: data)
//                self.users.append(user)
//                self.addImages(user, count)
//            }
//        }
    }
    
    
    func addImages(_ user: User, _ count: Int) {
        imageView = UIImageView()
//        imageView.hero.id = "\(user.position ?? 0)"
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
        self.label.text = "\(user.firstName ?? "") and \(count - 1) others would like\nto save $\(circle.amount ?? 0) with you."
        
    }
}
