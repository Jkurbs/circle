//
//  User.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import IGListKit

final class User {
    
    var userId: String?
    var accountId: String?
    var circle: String?
    var photoUrl: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var status: String?
    var activated: Bool?
    var card: Card?

    
    
    init(key: String, data: [String: Any], card: Card?) {
        
        self.userId = key
        
        if let accountId = data["account_id"] as? String {
            self.accountId = accountId
        }
        
        if let circle = data["circle"] as? String {
            self.circle = circle
        }
        
        if let firstName = data["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = data["last_name"] as? String {
            self.lastName = lastName
        }
        
        if let email = data["email_address"] as? String {
            self.email = email
        }
        
        if let photoUrl = data["image_url"] as? String {
            self.photoUrl = photoUrl
        }
        
        if let status = data["status"] as? String {
            self.status = status
        }
        
        if let activated = data["activated"] as? Bool {
            self.activated = activated
        }
        if let card = card {
            self.card = card
            print("card in user", card.imageUrl)
        }
    }
}


extension User: Equatable {
    
    static public func ==(rhs: User, lhs: User) -> Bool {
        return  rhs.userId == lhs.userId
    }
}

extension User: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return userId! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? User else { return false }
        
        return self.userId == object.userId
    }
}
