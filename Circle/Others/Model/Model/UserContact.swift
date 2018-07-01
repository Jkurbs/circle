//
//  Contact.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//



import Foundation
import Contacts

struct SelectedContact {
    var selected: Bool
    var name: [UserContact]
    
}

struct UserContact {
    
    var contact: CNContact
    var selected: Bool
}

