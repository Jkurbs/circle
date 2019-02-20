//
//  Contact.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//



import Foundation

struct SelectedContact {
    var selected: Bool
    var names: [UserContact]
    
}

struct UserContact {
    
    var identifier: String
    var givenName: String
    var namePrefix: String
    var familyName: String
    var emailAddress: String
    var phoneNumber: String
    var imageData: Data
}

