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

let textFieldBackgroundColor = UIColor(red: 247.0/255.0, green: 248.0/255.0, blue: 249.0/255.0, alpha: 0.5)

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
