//
//  Contacts.swift
//  Sparen
//
//  Created by Kerby Jean on 1/24/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import ContactsUI

class PhoneContact: NSObject {
    
    var key: Int? 
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var setSelected: Bool = false
    var isInvited = false

    
    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        avatarData  = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    
    override init() {
        super.init()
    }
}


