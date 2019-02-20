//
//  AccountViewModel.swift
//  Sparen
//
//  Created by Kerby Jean on 1/31/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit

enum AccountModelItemType {
    case general
    case personal
}

protocol AccountModelItem {
    var type: AccountModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}


class AccountViewModel: NSObject {
    
    var items = [AccountModelItem]()
    
    var tableView: UITableView!
    
    var picker = UIPickerView()
    var gender = ["Unspecify", "Male", "Female"]

    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            
            if let firstName = user.firstName, let lastName = user.lastName {
                let url = user.imageUrl ?? ""
                let username = user.username ?? ""
                let name = firstName + " " + lastName
                let profileItem = AccountViewModelGeneralItem(pictureUrl: url, name: name, username: username)
                self.items.append(profileItem)
            }
            
            if let email = user.email, let phone = user.phoneNumber {
                let gender = user.gender ?? ""
                let emailItem = AccountViewModelPersonalItem(email: email, phone: phone, gender: gender, opened: false)
                self.items.append(emailItem)
            }
        }
    }

    
    
    override init() {
        super.init()
    }

}

extension AccountViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .general:
            switch indexPath.row {
                case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifier, for: indexPath) as? ProfileImageCell {
                    cell.item = item
                    return cell
                }
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: DisplayNameCell.identifier, for: indexPath) as? DisplayNameCell {
                        cell.item = item
                        return cell
                     }
                case 2:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: UsernameCell.identifier, for: indexPath) as? UsernameCell {
                        cell.item = item
                        return cell
                }
            default:
               print("DEFAULT")
            }
        case .personal:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
                    cell.item = item
                    return cell
                }
            } else  {
                if let cell = tableView.dequeueReusableCell(withIdentifier: PhoneCell.identifier, for: indexPath) as? PhoneCell {
                    cell.item = item
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 120.0
        }
        
        return 50.0
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.items[indexPath.row]
        
        if item.type == .personal && item.rowCount == 2 {
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 60.0))
        if section == 0 {
            headerView.backgroundColor = .backgroundColor
        } else {
            headerView.backgroundColor = .white
        }
        let label = UILabel(frame: headerView.frame)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.darkText
        label.text = self.items[section].sectionTitle
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
        }
        
        
        
        
        return 60.0
    }
}



class AccountViewModelGeneralItem: AccountModelItem {
    var type: AccountModelItemType {
        return .general
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 3
    }
    
    var pictureUrl: String
    var name: String
    var username: String
    
    init( pictureUrl: String, name: String, username: String) {
        self.pictureUrl = pictureUrl
        self.name = name
        self.username = username
    }
}


class AccountViewModelPersonalItem: AccountModelItem {
    var type: AccountModelItemType {
        return .personal
    }
    
    var sectionTitle: String {
        return "Private Information"
    }
    
    var rowCount: Int {
        return 2
    }
    
    var email: String
    var phone: String
    var gender: String
    var opened: Bool

    
    init(email: String, phone: String, gender: String, opened: Bool) {
        self.email = email
        self.phone = phone
        self.gender = gender
        self.opened = opened
    }
}


