//
//  Balance.swift
//  Circle
//
//  Created by Kerby Jean on 3/26/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class Balance {
    
    var id: String?
    var availableAmount: Int?
    var pendingAmount: Int?
    var status: String?
    
    init(data: [String: Any]) {
        
        if let availableAmount = data["available_amount"] as? Int {
            self.availableAmount = availableAmount
        }
        
        if let pendingAmount = data["pending_amount"] as? Int {
            self.pendingAmount = pendingAmount
        }
    }
}

//extension Balance: Equatable {
//    static func ==(lhs: Balance, rhs: Balance) -> Bool {
//        return  lhs.id == rhs.id
//    }
//}
//
//    extension Balance: ListDiffable {
//
//    public func diffIdentifier() -> NSObjectProtocol {
//            return id! as NSObjectProtocol
//        }
//
//    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
//        if self === object { return true }
//        guard let object = object as? Balance else { return false }
//        return self.id == object.id
//    }
//}
//

