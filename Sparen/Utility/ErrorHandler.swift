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
        if let errCode = AuthErrorCode(rawValue: error!._code) {
            switch errCode {
            case .invalidEmail:
                _ = handleError("The email you entered is invalid.")
            case .emailAlreadyInUse:
                _ = handleError("The email you entered is already in user by another user.")
            case .wrongPassword:
                _ = handleError("Wrong password")
            default:
                _ = handleError("An unknown error occured")
            }
        }
    }
    
   private func handleError(_ errorMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    func internetError() -> UIAlertController  {
        let alert = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    func showMessage(_ vc: UIViewController, _ text: String, _ type: GSMessageType ) {

        vc.showMessage(text, type: type, options: [
            .animation(.slide),
            .animationDuration(0.3),
            .autoHide(true),
            .autoHideDelay(3.0),
            .cornerRadius(0.0),
            .height(44.0),
            .hideOnTap(true),
            .margin(.zero),
            .padding(.init(top: 10, left: 30, bottom: 10, right: 30)),
            .position(.top),
            .textAlignment(.center),
            .textColor(.white),
            .textNumberOfLines(1),
        ])
    }
}
