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
    var productId: String?
    var activated: Bool?
    var adminId: String?
    var users: User?
    var totalAmount: Int?
    var weeklyAmount: Int?
    var weeks: Int?
    var insiders: [String]?
    var postDate: Date?
    var startDate: Date?
    var endDate: Date?
    var daysTotal: Int? 
    var daysLeft: Int?
    

    
    init(key: String, data: [String: Any], users: User?) {
        
        self.id = key
        
        self.users = users
        
        
        if let productId = data["product_id"] as? String {
            self.productId = productId
        }
        
        if let activated = data["activated"] as? Bool {
            self.activated = activated
        }
        
        if let adminId = data["admin"] as? String {
            self.adminId = adminId
        }
        
        if let totalAmount = data["total_amount"] as? Int {
            self.totalAmount = totalAmount
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
        
        if let postDate = data["postDate"] as? Date {
            self.postDate = postDate
        }
        
        if let startDate = data["start_date"] as? Date {
            self.startDate = startDate
        }
        
        if let endDate = data["end_date"] as? Date {
            self.endDate = endDate
        }
        
        if let daysLeft = data["days_left"] as? Int {
            self.daysLeft = daysLeft
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

