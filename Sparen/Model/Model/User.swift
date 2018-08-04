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
    var imageUrl: String?
    var email: String?
    var userName: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var status: String?
    var signupDate: Date?
    var activated: Bool?
    var payed: Bool?
    var position: Int?
    var daysLeft: Int?
    
    
    init(key: String? , data: [String: Any]?) {
        
        if let key = key, let data = data {
            self.userId = key
            
            if let accountId = data["account_id"] as? String {
                self.accountId = accountId
            }
            
            if let circle = data["circle"] as? String {
                self.circle = circle
            }
            
            if let userName = data["user_name"] as? String {
                self.userName = userName
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
                self.imageUrl = photoUrl
            }
            
            if let status = data["status"] as? String {
                self.status = status
            }
            
            if let activated = data["activated"] as? Bool {
                self.activated = activated
            }
            
            if let payed = data["payed"] as? Bool {
                self.payed = payed
            }
            
            if let position = data["position"] as? Int {
                self.position = position
            }
            
            if let daysLeft = data["days_left"] as? Int {
                self.daysLeft = daysLeft
            }
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
