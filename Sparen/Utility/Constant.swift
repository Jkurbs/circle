//
//  Constant.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//



import Foundation
import UIKit
import Dispatch

let padding: CGFloat = 25
let width = UIScreen.main.bounds.width - (padding * 2)  - 20
let centerX = UIScreen.main.bounds.size.width * 0.5



let dispatch = DispatchQueue.main

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

var contentLayerName = "shadowLayer"

extension Notification.Name {
    
    static let newUser = Notification.Name("newUser")
    static let userLeft = Notification.Name("userLeft")
    
    static let activation = Notification.Name("activation")
    
    static let leave = Notification.Name("leave")
    static let invite = Notification.Name("invite")
    static let reloadPosition = Notification.Name("reloadPosition")
    static let pulse = Notification.Name("pulse")
    static let isAdmin = Notification.Name("isAdmin")
    static let fetchUsers = Notification.Name("fetchUsers")
    static let insertNewUser = Notification.Name("insertNewUser")
    static let newImageUrl = Notification.Name("newImageUrl")



    
    
    
    
}





