//
//  Circle.swift
//  Circle
//
//  Created by Kerby Jean on 11/8/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import IGListKit
import FirebaseFirestore


final class Circle {
    
    var id: String?
    var activated: Bool?
    var users: User?
    
    var maxAmount: Int?
    var weeklyAmount: Int?
    var weeks: Int?
    var insiders: [String]?
    var postDate: NSDate?
    var startDate: NSDate?
    var endDate: NSDate?

    
    init(key: String, data: [String: Any], users: User) {
        
        self.id = key
        
        self.users = users
        
        if let id = data["id"] as? String {
            self.id = id
        }
        
        if let activated = data["activated"] as? Bool {
            self.activated = activated
        }
        
        if let maxAmount = data["max_amount"] as? Int {
            self.maxAmount = maxAmount
        }
        
        if let weeklyAmount = data["weekly_amount"] as? Int {
            self.weeklyAmount = weeklyAmount
        }
        
        if let weeks = data["weeks"] as? Int {
            self.weeks = weeks
        }

        if let insiders = data["insiders"] as? [String] {
            self.insiders = insiders
        }
        
        if let postDate = data["postDate"] as? NSDate {
            self.postDate = postDate
        }
        
        if let startDate = data["startDate"] as? NSDate {
            self.startDate = startDate
        }
        
        if let endDate = data["endDate"] as? NSDate {
            self.endDate = endDate
        }
    }
}


extension Circle: Equatable {
    
    static public func ==(rhs: Circle, lhs: Circle) -> Bool {
        return  rhs.id == lhs.id
    }
}

extension Circle: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Circle else { return false }
        return self.id == object.id
    }
}

