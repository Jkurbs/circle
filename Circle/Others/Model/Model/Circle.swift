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
    
    var circleId: String?
    var maxAmount: NSNumber?
    var insiders: [User]?
    var postDate: NSDate?
    var startDate: NSDate?
    var endDate: NSDate?
    
    init(key: String, data: [String: Any]) {
        
        self.circleId = key
        
        if let circleId = data["circleId"] as? String {
            self.circleId = circleId
        }
        
        if let maxAmount = data["maxAmount"] as? NSNumber {
            self.maxAmount = maxAmount
        }

        if let insiders = data["insiders"] as? [User] {
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
        return  rhs.circleId == lhs.circleId
    }
}

extension Circle: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return circleId! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Circle else { return false }
        return self.circleId == object.circleId
    }
}

