//
//  SettingsView.swift
//  Circle
//
//  Created by Kerby Jean on 2/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI
import Cartography

class SettingsCell: UICollectionViewCell, MFMessageComposeViewControllerDelegate {
    
    var settingButton: UIButton!
    var createButton: UIButton!
    var searchButton: UIButton!
    var circleLink = ""
    var user: User!
    private var handle: AuthStateDidChangeListenerHandle!
    //var view = UIView()

    
    var label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
//        view.backgroundColor = .white
//        contentView.addSubview(view)
        
        label = UICreator.create.label(nil, 14, .darkerGray, .center, .semibold, contentView)
        
        searchButton = UICreator.create.button(nil, #imageLiteral(resourceName: "Search-20"), nil, nil, contentView)
        searchButton.addTarget(self, action: #selector(explore), for: .touchUpInside)
        settingButton = UICreator.create.button(nil, #imageLiteral(resourceName: "Menu-20"), nil, nil, contentView)
        settingButton.addTarget(self, action: #selector(settings), for: .touchUpInside)
        
        
     }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain( label, searchButton, createButton, settingButton, contentView) { label, searchButton, createButton, settingbutton, contentView in
//            view.width == contentView.width - 20
//            view.height == contentView.height
//            view.centerX == contentView.centerX
            label.edges == contentView.edges
            
            searchButton.width == 45
            searchButton.height == 45
            searchButton.left == contentView.left + 5
            
            createButton.width == 45
            createButton.height == 45
            createButton.left == searchButton.right + 5
            
            settingbutton.width == 45
            settingbutton.height == 45
            settingbutton.right == contentView.right - 5
        }
        
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = view.frame
//        rectShape.position = view.center
//        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        self.view.layer.backgroundColor = UIColor.white.cgColor
//        self.view.layer.mask = rectShape
    }
    
    
    @objc func explore() {
       let vc = FindCircleVC()
       let navigation = UINavigationController(rootViewController: vc)
        self.parentViewController().present(navigation, animated: true, completion: nil)
        
    }
    
    @objc func settings() {
        let vc = SettingsVC()
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func add() {
        
        let vc = CreateCircleVC()
        vc.user = user
        let navigation = UINavigationController(rootViewController: vc)
        self.parentViewController().present(navigation, animated: true, completion: nil)

    }
    
    
    func configure(_ user: User ,firstName: String) {
        self.user = user
        if user.circle != nil {
            createButton = UICreator.create.button(nil, #imageLiteral(resourceName: "Add-20"), nil, nil, contentView)
            createButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        }
        
        label.text = ""

        if user.userId == Auth.auth().currentUser?.uid {
            label.text = "Dashboard"
        } else {
            label.text = user.username ?? user.firstName
        }
    }
    

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case .cancelled:
                self.parentViewController().dismiss(animated: true, completion: nil)
            case .failed:
                self.parentViewController().dismiss(animated: true, completion: nil)
            case .sent:
                self.parentViewController().dismiss(animated: true, completion: nil)
        }
    }
}
