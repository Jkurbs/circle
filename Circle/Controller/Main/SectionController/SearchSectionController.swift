//
//  SearchSectionController.swift
//  Circle
//
//  Created by Kerby Jean on 1/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Contacts
import IGListKit
import MessageUI

class ContactListSectionController: ListSectionController, MFMessageComposeViewControllerDelegate {
    
    var contact: Contact?
    static var phoneNumbers = [String]()
    static var insiders = [Contact]()
    var childRef: String?
    var shortLink = ""

    
    fileprivate let button: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.setTitle("Invite", for: .normal)
        view.backgroundColor = UIColor.blueColor
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        view.setTitleColor(UIColor.white, for: .normal)
        return view
    }()
    
    
    override init() {
        super.init()
        
        let window = UIApplication.shared.keyWindow!
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let height = self.viewController?.view.frame.size.height
        button.frame = CGRect(x: 0, y: height! - 50, width: (self.viewController?.view.frame.width)!, height: 50)
        button.addTarget(self, action: #selector(sendSms), for: .touchUpInside)
        window.addSubview(button)
        
       
    }
    
    deinit {
        button.removeFromSuperview()
    }
    
    
    override func didUpdate(to object: Any) {
        contact = object as? Contact
    }
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext?.containerSize.width)!
        return CGSize(width: width, height: 64)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {

        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "ContactCell", bundle: nil, for: self, at: index) as? ContactCell else {
            fatalError()
        }
        cell.configure(contact!)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        button.isHidden = false
        if let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? ContactCell {
            cell.selectImageView.layer.borderWidth = 0.0
            cell.selectImageView.image = #imageLiteral(resourceName: "Checkmark-18")
            let contact = cell.contact
            ContactListSectionController.insiders.insert(contact!, at: index)
            if let phoneNumber = contact?.phoneNumber {
                ContactListSectionController.phoneNumbers.insert(phoneNumber, at: index)
            }
            print("PHONE NUMBERS:", ContactListSectionController.phoneNumbers)
        }
    }
    
    
    override func didDeselectItem(at index: Int) {
        let cell = collectionContext?.cellForItem(at: index, sectionController: self) as! ContactCell
        collectionContext?.deselectItem(at: index, sectionController: self, animated: true)
        cell.selectImageView.image = UIImage()
        cell.selectImageView.layer.borderWidth = 1.0
        ContactListSectionController.insiders.remove(at: index)
        ContactListSectionController.phoneNumbers.remove(at: index)
        if ContactListSectionController.phoneNumbers.count == 0 {
            button.isHidden = true
        }
        print("REMOVE PHONE NUMBERS:", ContactListSectionController.phoneNumbers)
        
    }
    
    @objc func sendSms() {
        
        let ref = DataService.instance.REF_CIRCLES
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        
        childRef = ref.document().documentID
        
        UserDefaults.standard.set(childRef, forKey: "circleID")
        
        //https://fk4hq.app.goo.gl/?link=https://example.com/demo&isi=389801252&ibi=com.Kurbs.Circle
       let link = "https://fk4hq.app.goo.gl/?link=https://example.com/\(childRef!)/demo&isi=389801252&ibi=com.Kurbs.Circle"
       self.shortLink = link
        
        DataService.instance.createDynamicLink(link: link) { (success, error, url) in
            if !success {
                
            } else {
                    if MFMessageComposeViewController.canSendText() {
                    messageComposeVC.title = "Save money with your loved ones"
                    messageComposeVC.body = "Hey join me on Circle and let's start earning and saving 💰. \(link)"
                    messageComposeVC.recipients = ContactListSectionController.phoneNumbers
                    dispatch.async {
                    self.viewController?.present(messageComposeVC, animated: true, completion: {
                    print("COMPLETION")
                    })
                }
            }
        }
    }
}

        
        
//        if insiders.count < 5 || insiders.count > 10 {
//            let alert = Alert()
//            alert.showPromptMessage(self.viewController!, title: "", message: "The minimum is 5 and the maximum is 10")
//            return
//        } else {
//
//        }
    
    
    
    func showPromptMessage(name: String) {
        let alert = UIAlertController(title: "SMS", message:"You will be prompt to send a Sms message, \(name) will be added to your Circle if the invitation is accepted" , preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionTwo = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        self.viewController?.present(alert, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            break
        case .failed:
            print("FAILED")
            break
        case .sent:
            saveInsider()
            break
        default:
            print("Default")
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func saveInsider() {
        let insiders = ContactListSectionController.insiders
        DataService.instance.createCircle(id: childRef!, self.shortLink, insiders) { (success, error) in
            if !success {
                print(error?.localizedDescription ?? "")
            } else {
                self.button.removeFromSuperview()
                let circleVC = PendingInvitesVC() 
                self.viewController?.navigationController?.setNavigationBarHidden(true, animated: false)
                self.viewController?.navigationController?.pushViewController(circleVC, animated: true)
            }
        }
    }
}





