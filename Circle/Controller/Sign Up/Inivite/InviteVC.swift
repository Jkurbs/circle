//
//  InviteVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Contacts
import IGListKit
import FirebaseAuth
import MessageUI

final class InviteVC: UIViewController, MFMessageComposeViewControllerDelegate {

    var contacts = [Contact]()
    var infoView: UIView!
    var subhead = Subhead()
    
    static var selectedContacts = [Contact]()
    static var phoneNumbers = [""]
    
    var childRef: String?
    var shortLink = ""
    
    var circleId: String?
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
        view.backgroundColor = .white
        view.allowsMultipleSelection = true
        return view
    }()
    
    
    fileprivate let button: LogButton = {
        let view = LogButton()
        view.isEnabled = true
        view.alpha = 1.0
        view.setTitle("Invite", for: .normal)
        view.backgroundColor = UIColor.blueColor
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        view.setTitleColor(UIColor.white, for: .normal)
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        subhead.text = "Invite at least 5 person to join your Circle"
        
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource  = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")

        tableView.allowsMultipleSelection = true
        GetContactAccess()
        
        button.addTarget(self, action: #selector(sendSms), for: .touchUpInside)
        
        print("CIRCLE ID", circleId)


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        infoView.backgroundColor = UIColor.textFieldBackgroundColor
        view.addSubview(infoView)
        
        subhead.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: 45)
        subhead.center.x = infoView.center.x
        infoView.addSubview(subhead)

        tableView.frame = CGRect(x: 0, y: infoView.frame.height , width: view.frame.width, height: view.frame.height - 170)
        
        button.frame = CGRect(x: 0, y: view.frame.height - 60, width: view.frame.width - 25, height: 50)
        button.center.x = (view?.center.x)!
        button.cornerRadius = 25
        
        view.addSubview(button)
    }
    
    
    private func GetContactAccess() {
        let store = CNContactStore()
        self.retrieveContactsWithStore(store)
    }
    
    
    func retrieveContactsWithStore(_ store: CNContactStore) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: [ CNContactIdentifierKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor,CNContactNamePrefixKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor])
        fetchRequest.sortOrder = .userDefault
        
        let store = CNContactStore()
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                if !contact.isKeyAvailable(CNContactPhoneNumbersKey){
                    print("CAN'T SHOW ")
                } else {
                    let cont = Contact(identifier: contact.identifier, givenName: contact.givenName, namePrefix: contact.namePrefix, familyName: contact.familyName, emailAddress: String(describing: contact.emailAddresses.first?.value ?? ""), phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "",  imageData: contact.imageData)
                    self.contacts.append(cont)
                }
                dispatch.async {
                    self.tableView.reloadData()
                }
                DispatchQueue.global(qos: .background).async {
                    //DataService.instance.saveContacts(contacts: self.contacts)
                }
            })
            return
        } catch let error as NSError {
            print(error.localizedDescription)
      }
    }
 }


// MARK: UITableView

extension InviteVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.selectionStyle = .none
        let contact = contacts[indexPath.row]
        cell.configure(contact)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ContactCell {
            if let contact = cell.contact {
                InviteVC.selectedContacts.insert(contact, at: indexPath.row)
                if let phoneNumber = contact.phoneNumber {
                InviteVC.phoneNumbers.insert(phoneNumber, at: indexPath.row)
            }
        }
    }
}
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        InviteVC.selectedContacts.remove(at: indexPath.row)
        InviteVC.phoneNumbers.remove(at:  indexPath.row)
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    @objc func sendSms() {
        
        button.showLoading()
        
        if InviteVC.phoneNumbers.count > 0 {
            let ref = DataService.instance.REF_CIRCLES
            let messageComposeVC = MFMessageComposeViewController()
            messageComposeVC.messageComposeDelegate = self
            
            childRef = ref.document().documentID
            
            UserDefaults.standard.set(childRef, forKey: "circleID")
            
            //https://fk4hq.app.goo.gl/?link=https://example.com/?id=C78u0CgA4JXe3diad1fz&isi=389801252&ibi=com.Kurbs.Circle
            
            let link = "https://fk4hq.app.goo.gl/?link=https://example.com/?id=\(childRef!)&isi=389801252&ibi=com.Kurbs.Circle"
            self.shortLink = link

            shortLink = link

            DataService.instance.createDynamicLink(link: link) { (success, error, url) in
                if !success {
                    print("ERROR:::", error!.localizedDescription)
                    self.button.hideLoading()
                } else {
                    if MFMessageComposeViewController.canSendText() {
                        messageComposeVC.title = "Save money with your loved ones"
                        messageComposeVC.body = "Hey join me on Circle and let's start earning and saving 💰. \(link)"
                        messageComposeVC.recipients = InviteVC.phoneNumbers
                        dispatch.async {
                            self.button.hideLoading()
                            self.present(messageComposeVC, animated: true, completion: {
                                
                            })
                        }
                    }
                }
            }
        } else {
            let alert = Alert()
            alert.showPromptMessage(self, title: "", message: "")
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            button.hideLoading()
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
        let contacts = InviteVC.selectedContacts
            print("NIL")
            DataService.instance.createCircle(id: childRef!, shortLink, contacts) { (success, error) in
                if !success {
                    print(error?.localizedDescription ?? "")
                } else {
                    UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: "userId")
                    self.button.removeFromSuperview()
                    let pendingVC = PendingVC()
                    self.navigationController?.setNavigationBarHidden(true, animated: false)
                    self.navigationController?.pushViewController(pendingVC, animated: true)
                }
            }
//        } else {
//            
//            DataService.instance.retrieveUser(Auth.auth().currentUser!.uid, { (success, error, user, data, card, cardData)   in
//                if !success {
//                    
//                } else {
//                 DataService.instance.REF_CIRCLES.document(self.circleId!).collection("insiders").document((user?.userId)!).setData(data!)
//                }
//            })
//        }
    }
}











