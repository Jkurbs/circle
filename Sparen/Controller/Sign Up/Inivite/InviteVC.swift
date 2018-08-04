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



final class InviteVC: UIViewController {
    
    let textCellIdentifier = "InviteCell"
    
    var contacts = [UserContact]()
    
    var viewModel = ViewModel()

    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
        view.backgroundColor = .white
        view.allowsMultipleSelection = true
        view.allowsMultipleSelection = true
        view.separatorStyle = .none
        return view
    }()
    
    let impact = UIImpactFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    let notification = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invite"

        let inviteButton = UIBarButtonItem(title: "Invite", style: .done, target: self, action: #selector(invite))
        self.navigationItem.rightBarButtonItem = inviteButton

         tableView.register(ContactCell.self, forCellReuseIdentifier: textCellIdentifier)
         self.view.addSubview(tableView)
         tableView.dataSource = viewModel
         tableView.delegate = viewModel
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            //inviteButton.isEnabled = hasSelection
            self?.tableView.reloadData()
        }
    }
    
    
    
    private func fetchContacts() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("error fetching contacts", error.localizedDescription)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        print("contact given Name", contact.givenName)
                        self.viewModel.contacts.append(UserContact(contact: contact, selected: false))
                        dispatch.async {
                            self.tableView.reloadData()
                        }
                    })
                } catch let err {
                    print("Failed to get contacts", err)
                }
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    @objc func invite() {
        print(viewModel.selectedItems.map { $0.contact })
        tableView.reloadData()
    }
    
    
    @objc func back() {
        let vc = CircleVC()
        let nav = UINavigationController(rootViewController: vc)

        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(nav, animated: false, completion: nil)
    }
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0 , width: view.frame.width, height: view.frame.height)
    }
}


