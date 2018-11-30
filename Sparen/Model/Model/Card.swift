//
//  Card.swift
//  Sparen
//
//  Created by Kerby Jean on 9/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import IGListKit

final class Card {
    
    var key: String?
    var token: String?
    var last4: String?
    var imageUrl: String?
    
    
    init(_ key: String, _ data: [String: Any]) {
        
        self.key = key
        
        if let token = data["token"] as? String {
            self.token = token
        }
        
        if let last4 = data["last4"] as? String {
            self.last4 = last4
        }
        
        if let imageUrl = data["image_url"] as? String {
            self.imageUrl = imageUrl
        }
    }
}


extension Card: Equatable {
    
    static public func ==(rhs: Card, lhs: Card) -> Bool {
        return  rhs.key == lhs.key
    }
}

extension Card: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return key! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Card else { return false }
        return self.key == object.key
    }
}
