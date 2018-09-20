//
//  MonthlyAmoutCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Cartography


class CircleStateCell: UICollectionViewCell {

    var viewController: UIViewController? 
    var setupCircleView = SetupCircleView()
    var readyView = ReadyView()
    var activatedView = ActivatedView()
    
    var circle: Circle! {
        didSet {
            guard let adminId = circle.adminId else { return }
            print("ADMIN:", adminId)
            if adminId == Auth.auth().currentUser?.uid {
                self.addView(view: setupCircleView)
                setupCircleView.circle = circle
            } else {
                print("NOT ADMIN")
                self.addView(view: readyView)
            }
        }
    }
    
    var insight: Insight? {
        didSet {
            activatedView.insights = []
            activatedView.insights.append(insight!)
            activatedView.circle = circle
            activatedView.adapter.reloadData(completion: nil)
            activatedView.viewController = self.viewController
            self.addView(view: self.activatedView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .backgroundColor
    }
    

    func addView(view: UIView) {
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        UIView.animate(withDuration: 0.5) {
            self.contentView.addSubview(view)
        }
        
        constrain(view, contentView) { (view, contentView) in
            view.height == contentView.height
            view.width == contentView.width - 20
            view.centerX == contentView.centerX
        }
        
        dispatch.async {
            view.cornerRadius = 10
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

