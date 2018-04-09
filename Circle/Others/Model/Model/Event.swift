//
//  Event.swift
//  Circle
//
//  Created by Kerby Jean on 3/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class Event {
    
    var id: String?
    var amount: String?
    var from: String?
    var to: String?
    var chargeId: String?
    var firstName: String?
    var lastName: String?
    var date: Date?
    var status: String?
    var type: String!

    
    init(key: String, data: [String: Any]) {
        
        self.id = key
        
        if let amount = data["amount"] as? String {
            self.amount = amount
        }
        
        if let from = data["from"] as? String {
            self.from = from
        }
        
        if let chargeId = data["chargeId"] as? String {
            self.chargeId = chargeId
        }
        
        if let firstName = data["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = data["last_name"] as? String {
            self.lastName = lastName
        }
        
        if let status = data["status"] as? String {
            self.status = status
        }
        
        if let date = data["date"] as? Date {
            self.date = date
        }
        
        if let type = data["type"] as? String {
            self.type = type
        }
    }
}

extension Event: Equatable {
    
    static public func ==(rhs: Event, lhs: Event) -> Bool {
        return  rhs.id == lhs.id
    }
}

extension Event: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Event else { return false }
        
        return self.id == object.id
    }
}



