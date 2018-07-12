//
//  ErrorHandler.swift
//  Sparen
//
//  Created by Kerby Jean on 7/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import FirebaseAuth

class ErrorHandler {
    
    private static let _show = ErrorHandler()
    
    static var show: ErrorHandler {
        return _show
}

    func authError(_ error: Error?) {
        print("SHOW")
        if let errCode = AuthErrorCode(rawValue: error!._code) {
            switch errCode {
            case .invalidEmail:
                handleError("The email you entered is invalid.")
            case .emailAlreadyInUse:
                handleError("The email you entered is already in user by another user.")
            case .wrongPassword:
                handleError("Wrong password")
            default:
                handleError("An unknown error occured")
            }
        }
    }
    
   private func handleError(_ errorMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
