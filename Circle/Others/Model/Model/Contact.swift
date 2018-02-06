//
//  Contact.swift
//  Circle
//
//  Created by Kerby Jean on 1/13/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import Contacts
import IGListKit

class Contact {
    
    var identifier: String?
    var givenName: String?
    var namePrefix: String?
    var familyName: String?
    var emailAddress: String?
    var phoneNumber: String?
    var imageData: Data?
    
    init(identifier: String?, givenName: String, namePrefix: String, familyName: String, emailAddress: String, phoneNumber: String, imageData: Data?) {
        self.identifier = identifier
        self.givenName = givenName
        self.namePrefix = namePrefix
        self.familyName = familyName
        self.emailAddress = emailAddress
        self.imageData = imageData
        self.phoneNumber = phoneNumber
    }
}

extension Contact: Equatable {
    
    static public func ==(rhs: Contact, lhs: Contact) -> Bool {
        return  rhs.identifier == lhs.identifier
    }
}

extension Contact: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return identifier! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Contact else { return false }
        
        return self.identifier == object.identifier
    }
}


