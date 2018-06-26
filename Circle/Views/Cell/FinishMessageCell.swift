//
//  FinishMessageCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/21/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Lottie
import MessageUI
import FirebaseFirestore


class  FinishMessageCell: UICollectionViewCell, MFMailComposeViewControllerDelegate {
    
    var label = UILabel()
    var button = UIButton()
    var restartButton = UIButton()
    
    private var animation: LOTAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animation = LOTAnimationView(name: "firework")
        animation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animation!.contentMode = .scaleAspectFill
        animation!.frame = self.contentView.bounds
        contentView.addSubview(animation!)
        contentView.addSubview(label)
        
        animation?.loopAnimation = true
        animation?.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 15, width: contentView.frame.width, height: 50)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Congratulation \n You finished your first Circle"
        label.numberOfLines = 3
        
        button.frame = CGRect(x: 0, y: label.frame.maxY + 30, width: contentView.frame.width, height: 50)
        button.center.x = contentView.center.x
        button.setTitleColor(contentView.tintColor, for: .normal)
        button.setTitle("Leave feedback", for: .normal)
        button.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        
        restartButton.frame = CGRect(x: 0, y: button.frame.maxY + 40, width: contentView.frame.width, height: 50)
        restartButton.center.x = contentView.center.x
        restartButton.setTitleColor(contentView.tintColor, for: .normal)
        restartButton.setImage(#imageLiteral(resourceName: "Restart-40"), for: .normal)
        restartButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        
        
        contentView.addSubview(button)
        //contentView.addSubview(restartButton)


        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        self.layer.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
        self.layer.mask = rectShape
    }
    
    func configure() {

    }
    
    
    
    
    
    
    
    @objc func sendFeedback() {
        let emailTitle = "Feedback"
        let messageBody = "Feature request or bug report?"
        let toRecipents = ["kerby.jean@hotmail.fr"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.parentViewController().present(mc, animated: true, completion: nil)
    }
    
    
    @objc func restart() {
        
    }
    
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            case .cancelled:
                print("Mail cancelled")
                self.parentViewController().dismiss(animated: true, completion: nil)
            case .saved:
                print("Mail saved")
                self.parentViewController().dismiss(animated: true, completion: nil)

            case .sent:
                print("Mail sent")
                self.parentViewController().dismiss(animated: true, completion: nil)

            case .failed:
                self.parentViewController().dismiss(animated: true, completion: nil)

                print("Mail sent failure: \(error?.localizedDescription)")
        }
    }
}
    

