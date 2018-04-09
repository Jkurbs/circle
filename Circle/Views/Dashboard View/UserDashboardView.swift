//
//  UserDashboardView.swift
//  Circle
//
//  Created by Kerby Jean on 2/23/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import Stripe
import FirebaseAuth


class UserDashboardView: UIView {

    @IBOutlet weak var userView: UserView!
    @IBOutlet weak var moreLabel: UILabel!
    var expanded: Bool = false
    
    let transactionView = Bundle.main.loadNibNamed("TransactionView", owner: self, options: nil)![0] as! TransactionView
    let confirmationView = Bundle.main.loadNibNamed("ConfirmationView", owner: self, options: nil)![0] as! ConfirmationView
    let processingView = Bundle.main.loadNibNamed("ProcessingView", owner: self, options: nil)![0] as! ProcessingView
    let successView = Bundle.main.loadNibNamed("SuccessView", owner: self, options: nil)![0] as! SuccessView
    let errorView = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)![0] as! ErrorView
    var user: User?
 
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.textFieldBackgroundColor
    }
    
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        transactionView.parentView = self
        confirmationView.parentView = self
        processingView.parentView = self
        successView.parentView = self
        errorView.parentView = self
        confirmationView.user = user
        
        let views = [transactionView, confirmationView, processingView, errorView, successView]

        for view in views {
            view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: view.frame.height)
            view.alpha = 0.0
            self.addSubview(view)
        }
    }


    func configure(_ user: User?) {
        self.user = user
        self.userView.get(user!)
    }
    
 
    @IBAction func userAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
             self.transactionView.mode = "Request"
             showTransactionView()
        case 2:
             expand(sender)
        case 3:
            self.transactionView.mode = "Send"
            showTransactionView()
        default:
            print("")
        }
    }
}



extension UserDashboardView: UITextFieldDelegate {
    
    func hideShow(hideView: UIView, showView: UIView) {
        UIView.animate(withDuration: 0.3) {
            hideView.alpha = 0.0
            showView.alpha = 1.0
        }
    }

    func showTransactionView() {
        hideShow(hideView: userView, showView: transactionView)
        self.transactionView.configure(user!)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.transactionView.amountTextField.becomeFirstResponder()
        }
    }
    
 
    func expand(_ sender: UIButton) {
         let height = (self.viewController?.view.frame.height)! - 65
        self.expanded = !self.expanded
        if expanded {
            UIView.animate(withDuration: 0.3) {
                self.userView.frame.size.height = height
                self.frame.size.height = height
                self.layoutIfNeeded()
                self.userView.layoutIfNeeded()
                self.userView.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.userView.frame.height - 100)
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                //self.moreLabel.text = "Show less"
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.userView.frame.size.height = 236
                self.frame.size.height = 236
                self.layoutIfNeeded()
                self.userView.layoutIfNeeded()
                self.userView.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 150)
                self.userView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                // self.moreLabel.text = "Show more"
            }
        }
    }

    
    func resize(toFitSubviews view: UIView) {
        var w: Float = 0
        var h: Float = 0
        for v: UIView in view.subviews {
            let fw: Float = Float(v.frame.origin.x + v.frame.size.width)
            let fh: Float = Float(v.frame.origin.y + v.frame.size.height)
            w = max(fw, w)
            h = max(fh, h)
        }
        self.frame = CGRect(x: self.frame.origin.x, y:  self.frame.origin.y, width: self.frame.width, height: CGFloat(h))
        self.center.x = UIScreen.main.bounds.width * 0.5
    }
}



