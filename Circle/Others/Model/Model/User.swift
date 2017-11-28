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
    
    var photoUrl: String?
    var email: String?
    var name: String?
    var phoneNumber: String?
    var userId: String?
    
    init(key: String, data: [String: Any]) {
        
        self.userId = key
        
        if let userId = data["uid"] as? String {
            self.userId = userId
        }
        
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let email = data["email"] as? String {
            self.email = email
        }
        
        if let photoUrl = data["photoUrl"] as? String {
            self.photoUrl = photoUrl
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
