//
//  ProcessingView.swift
//  Circle
//
//  Created by Kerby Jean on 3/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProcessingView: UIView {
    
    
    var parentView: UserDashboardView! 
    var user: User!
    var amount: String!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    func send(user: User, amount: String) {
        MoneyService.instance.sendMoney(user.userId!,"\(amount)", user.accountId!, user.firstName!, user.lastName!) { (success, error)  in
            if !success {
                self.parentView.hideShow(hideView: self, showView: self.parentView.errorView)
            } else {
                self.parentView.hideShow(hideView: self, showView: self.parentView.successView)
                self.parentView.successView.configure(message: "Money sent succesfully")
            }
        }
    }
    
    func request(user: User, amount: String) {
        let data: [String: Any] = ["amount": amount, "to": user.userId!, "from": Auth.auth().currentUser!.uid, "first_name": user.firstName ?? "", "last_name": user.lastName ?? "", "type": "request"]
        MoneyService.instance.requestMoney(user, data: data) { (success, error) in
            if !success {
                print("error requesting money::", error!)
            } else {
                self.parentView.hideShow(hideView: self, showView: self.parentView.successView)
                self.parentView.successView.configure(message: "Money requested succesfully")
            }
        }
    }
}
