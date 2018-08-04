//
//  Bank.swift
//  Circle
//
//  Created by Kerby Jean on 2/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

final class Bank {
    
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

