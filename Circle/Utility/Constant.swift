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

