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
    
    func showMoreSheet(_ vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let actionOne = UIAlertAction(title: "Action one", style: .cancel, handler: nil)
        let actionTwo = UIAlertAction(title: "Action two", style: .cancel, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
}
