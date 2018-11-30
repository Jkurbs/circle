//
//  Insight.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import IGListKit

final class Insight {

    var id: String?
    var totalAmount: Int?
    var weeklyAmount: Int?
    var daysTotal: Int?
    var daysLeft: Int?
    var round: Int?
    
    init(key: String, data: [String: Any]) {
        
        self.id = key

        if let totalAmount = data["totalAmount"] as? Int {
            self.totalAmount = totalAmount
        }
        
        if let weeklyAmount = data["weeklyAmount"] as? Int {
            self.weeklyAmount = weeklyAmount
        }
        
        if let daysTotal = data["daysTotal"] as? Int {
            self.daysTotal = daysTotal
        }      
        
        if let daysLeft = data["daysLeft"] as? Int {
            self.daysLeft = daysLeft
        }
        
        if let round = data["round"] as? Int {
            self.round = round
        }
    }
}



extension Insight: Equatable {
    
    static public func ==(rhs: Insight, lhs: Insight) -> Bool {
        return  rhs.id == lhs.id
    }
}

extension Insight: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Insight else { return false }
        return self.id == object.id
      }
}
