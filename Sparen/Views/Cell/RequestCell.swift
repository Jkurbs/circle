//
//  RequestCell.swift
//  Sparen
//
//  Created by Kerby Jean on 2/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth
import SwipeCellKit

class RequestCell: UICollectionViewCell {

    var imageView: UIImageView!
    var label: UILabel!
    var timeLabel: UILabel!
    var button: UIButton!
    var request: Request!
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    public weak var delegate: SwipeCollectionViewCellDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UICreator.create.imageView(nil, contentView)
        label = UICreator.create.label("", 13, .darkText, .left, .regular, contentView)
        label.sizeToFit()
        timeLabel = UICreator.create.label("", 16, .lightGray, .natural, .light, contentView)
    
        button = UICreator.create.button(nil, nil, .white, .sparenColor, contentView)
        button.addTarget(self, action: #selector(accept), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.cornerRadius = 5
        
//        contentView.layer.addSublayer(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(imageView, label, timeLabel, button, contentView) { (imageView, label, timeLabel, button, contentView) in
            
            imageView.left == contentView.left + 15
            imageView.centerY == contentView.centerY
            imageView.width == 40
            imageView.height == 40
            
            label.left == imageView.right + 15
            label.centerY == contentView.centerY
            
            timeLabel.left == label.right + 5
            
            button.right == contentView.right - 15
            button.centerY == contentView.centerY
            button.height == 25
            button.width == 90
            label.right == button.left + 20
        }
        
        dispatch.async {
            self.imageView.cornerRadius = self.imageView.frame.height/2
        }
    }
    
    @objc func accept() {
        
        button.setTitle("Accepted", for: .normal)
        button.backgroundColor = .white
        
        let ref = DataService.call.RefUsers.child(Auth.auth().currentUser!.uid)
        let requestRef = DataService.call.RefRequests
        let toRef = DataService.call.RefUsers.child(self.request.from!)
        
        let circleId = UserDefaults.standard.string(forKey: "circleId")
        
        requestRef.child(circleId!).child(Auth.auth().currentUser!.uid).child(request.key!).updateChildValues(["accepted": true])
        ref.updateChildValues(["position": request.position ?? 0]) { (error, ref) in
            toRef.updateChildValues(["position": self.request.forPosition ?? 0])
        }
        
        let positions = ["position": request.position ?? 0, "forPosition": request.forPosition ?? 0] as [String: Any]
        NotificationCenter.default.post(name: .reloadPosition, object: nil, userInfo: ["positions": positions])

    }
    
    func configure(_ request: Request) {
        
        self.request = request
        
        if request.accepted == true {
            button.setTitle("Accepted", for: .normal)
            button.backgroundColor = .white
        } else {
            button.setTitle("Accept", for: .normal)
            button.backgroundColor = .sparenColor
        }

        fetchImage(request.from!)
        imageView.image = UIImage(named: "three")

        let name = request.name
        
        let position = request.position! + 1
        
        let time = convertDate(postDate: request.time ?? 0)
        
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.darkText]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: name ?? "", attributes: attrs)
        
        let attributedString1 = NSMutableAttributedString(string:" request position \(position)\nfor your position. ", attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string: time, attributes: attrs2)
        
        myMutableString.append(attributedString1)
        myMutableString.append(attributedString2)


        label.attributedText = myMutableString
    
    
    }
    
    func fetchImage(_ userId: String)  {
        DataService.call.RefUsers.child(userId).child("image_url").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else {return}
            let url = value as! String
            self.imageView.sd_setImage(with: URL(string: url), completed: nil)
            
        })
    }
}


