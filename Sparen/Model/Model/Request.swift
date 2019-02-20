//
//  Request.swift
//  Sparen
//
//  Created by Kerby Jean on 2/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import IGListKit

class Request {
    
    var key: String?
    var from: String?
    var name: String?
    var position: Int?
    var forPosition: Int?
    var time: Int?
    var accepted: Bool?

    
    
    init(_ key: String, _ data: [String: Any]) {
        
        self.key = key
        
        if let name = data ["name"] as? String {
            self.name = name
        }
        
        if let from = data ["from"] as? String {
            self.from = from
        }
        
        if let position = data ["position"] as? Int {
            self.position = position
        }
        
        if let accepted = data["accepted"] as? Bool {
            self.accepted = accepted
        }
        
        if let forPosition = data["forPosition"] as? Int {
            self.forPosition = forPosition
        }
        
        if let time = data ["time"] as? Int {
            self.time = time
        }
    }
}


extension Request: Equatable {
    
    static public func ==(rhs: Request, lhs: Request) -> Bool {
        return  rhs.key == lhs.key
    }
}

extension Request: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return key! as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Request else { return false }
        return self.key == object.key
    }
}
