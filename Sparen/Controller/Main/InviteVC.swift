//
//  InviteVC.swift
//  Sparen
//
//  Created by Kerby Jean on 1/21/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


import UIKit
import Cartography
import MessageUI

class InviteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var phoneContacts = [PhoneContact]()
    var selectedContacts = [PhoneContact]()
    var filteredContacts = [PhoneContact]()
    
    var recipients = [String]()
    var filter: ContactsFilter = .none
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var array = ["0","1","2","3"]

    
    lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var button: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.sparenColor
        view.cornerRadius = 10
        view.setTitle("Send Invite", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        view.isEnabled = false
        view.alpha = 0.5
        view.addTarget(self, action: #selector(send), for: .touchUpInside)
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if currentReachabilityStatus == .notReachable {self.present(ErrorHandler.show.internetError(), animated: true, completion: nil)}
        
        self.title = "Add Friends"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.backgroundColor = .white
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.allowsMultipleSelection = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .darkText
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = .white
        tableView.tableHeaderView = searchController.searchBar
        
        self.loadContacts(filter: filter)// Calling loadContacts methods
        view.addSubview(messageView)
        messageView.addSubview(button)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(messageView, button, view) { (messageView, button, view) in
            messageView.width == view.width
            messageView.height == 100
            messageView.bottom == view.bottom
            
            button.center == messageView.center
            button.width == messageView.width - 100
            button.height == 45
        }
    }
    
    // MARK: Actions
    
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        guard let link = UserDefaults.standard.string(forKey: "link") else {return}
        let messageVC = MFMessageComposeViewController()
            messageVC.body = "Get Sparen and Save money with me on. \(link)";
            messageVC.recipients = self.recipients
            messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }
    
    
    
    fileprivate func loadContacts(filter: ContactsFilter) {
        filteredContacts.removeAll()
        phoneContacts.removeAll()
        var allContacts = [PhoneContact]()
        for contact in PhoneContacts.getContacts(filter: filter) {
            allContacts.append(PhoneContact(contact: contact))
        }
        
        var filterdArray = [PhoneContact]()
        if self.filter == .mail {
            filterdArray = allContacts.filter({ $0.email.count > 0 }) // getting all email
        } else if self.filter == .message {
            filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
        } else {
            filterdArray = allContacts
        }
        phoneContacts.append(contentsOf: filterdArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts = phoneContacts.filter({( contact : PhoneContact) -> Bool in
            return contact.name!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }
}

extension InviteVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredContacts.count
        }
        return phoneContacts.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell {
            
            var contact: PhoneContact
            
            let row = indexPath.row
            
            if !isFiltering() {
                contact = self.phoneContacts[row]
            } else {
                contact = self.filteredContacts[row]
            }
            
            // select/deselect the cell
            if !contact.setSelected {
                cell.button.setImage(UIImage(), for: .normal)
            } else {
                cell.button.setImage(UIImage(named: "check-30"), for: .normal)
            }
            
            cell.configure(contact)
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        
        var contact: PhoneContact
        
        if isFiltering() {
            contact = self.filteredContacts[indexPath.row]
            if contact.setSelected == false {
                contact.setSelected = true
                cell.button.setImage(UIImage(named: "check-30"), for: .normal)
                self.selectedContacts.insert(contact, at: 0)
                let phoneNumber = contact.phoneNumber.first
                let email = contact.email.first
                self.recipients.insert(phoneNumber ?? email ?? "", at: 0)
                self.searchController.isActive = false
                if let index = phoneContacts.index(of: contact) {
                    self.tableView.beginUpdates()
                    self.tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
                    self.phoneContacts.remove(at: index)
                    self.phoneContacts.insert(contact, at: 0)
                    self.tableView.endUpdates()
                }
            }
        } else {
            contact = self.phoneContacts[indexPath.row]
            if contact.setSelected == false {
                contact.setSelected = true
                cell.button.setImage(UIImage(named: "check-30"), for: .normal)
                self.selectedContacts.insert(contact, at: 0)
                let phoneNumber = contact.phoneNumber.first
                let email = contact.email.first
                self.recipients.insert(phoneNumber ?? email ?? "", at: 0)
            } else {
                contact.setSelected = false
                for cont in self.selectedContacts {
                    if cont == contact {
                        if let index = selectedContacts.index(of: cont) {
                            selectedContacts.remove(at: index)
                            recipients.remove(at: index)
                        }
                        cell.button.setImage(UIImage(), for: .normal)
                    }
                }
            }
        }
        
        if self.selectedContacts.count > 0 {
            button.isEnabled = true
            button.alpha = 1.0
        } else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}

extension InviteVC: UISearchBarDelegate {
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.selectedContacts.removeAll()

        if let selectedItems = tableView.indexPathsForSelectedRows {

            for item in selectedItems {
                tableView.deselectRow(at: item, animated: true)
                let cell = tableView.cellForRow(at: item) as! ContactCell
                cell.backgroundColor = .white
                tableView.reloadData()
            }
        }
    }
}

extension InviteVC: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchText = searchBar.text,
            !searchText.isEmpty {
            //                    filteredContacts.removeAll()
        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension InviteVC: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        switch (result) {
        case .cancelled:
            dismiss(animated: true, completion: nil)
        case .failed:
            dispatch.async {
                ErrorHandler.show.showMessage(self, "Message", .success)
                self.dismiss(animated: true, completion: nil)
            }
        case .sent:
            dispatch.async {
                ErrorHandler.show.showMessage(self, "Invites sent", .success)
                self.tableView.reloadData()
                self.selectedContacts.removeAll()
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}
