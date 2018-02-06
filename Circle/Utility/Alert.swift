//
//  Alert.swift
//  Circle
//
//  Created by Kerby Jean on 1/14/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

final class Alert {
    
    func showPromptMessage(_ vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(actionOne)
        vc.present(alert, animated: true, completion: nil)
    }
}
