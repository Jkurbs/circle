//
//  UserActivities.swift
//  Sparen
//
//  Created by Kerby Jean on 9/6/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit


final class UserActivities {
    
    var id: String?
    var daysLeft: Int?
    var daysTotal: Int?
    var status: String?
    
    init(key: String, data: [String: Any]) {
        
        self.id = key
        
        if let daysLeft = data["days_left"] as? Int {
            self.daysLeft = daysLeft
        }
        
        if let daysTotal = data["days_total"] as? Int {
            self.daysTotal = daysTotal
        }
        
        if let status = data["status"] as? String {
            self.status = status
        }
    }
}

extension UserActivities: Equatable {
    
    static public func ==(rhs: UserActivities, lhs: UserActivities) -> Bool {
        return  rhs.id == lhs.id
    }
}

extension UserActivities: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? UserActivities else { return false }
        
        return self.id == object.id
    }
}

