//
//  Haptics.swift
//  Circle
//
//  Created by Kerby Jean on 7/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit



class Haptic {
    
    private static let _tic = Haptic()
    static var tic: Haptic {
        return _tic
    }
    
    private let impact = UIImpactFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
    
    func occured() {
        impact.impactOccurred()
    }
}
