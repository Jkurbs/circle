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



final class Circle {
    
    var id: String?
    var activated: Bool?
    var adminId: String?
    var totalAmount: Int?
    var weeklyAmount: Int?
    var insiders: [String]?
    var daysTotal: Int?
    var daysLeft: Int?
    var link: String?
    var amount: Int?
    var members: Int?
    var created: TimeInterval?
    

    
    init(key: String, data: [String: Any]) {
        
        self.id = key
        
        if let activated = data["activated"] as? Bool {
            self.activated = activated
        }
        
        if let adminId = data["admin"] as? String {
            self.adminId = adminId
        }
        
        if let weeklyAmount = data["weekly_amount"] as? Int {
            self.weeklyAmount = weeklyAmount
        }
        
        if let daysTotal = data["days_total"] as? Int {
            self.daysTotal = daysTotal
        }

        if let insiders = data["insiders"] as? [String] {
            self.insiders = insiders
        }
        
        if let daysLeft = data["days_left"] as? Int {
            self.daysLeft = daysLeft
        }
        
        if let link = data["link"] as? String {
            self.link = link
        }
        
        if let amount = data["amount"] as? Int {
            self.amount = amount
        }
        
        if let members = data["members"] as? Int {
            self.members = members
        }
        
        if let created = data["created"] as? TimeInterval {
            self.created = created
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
        guard self !== object else { return true }
        guard let object = object as? Circle else { return false }
        return self.id == object.id
    }
}

