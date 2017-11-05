//
//  Services.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import Firebase
import SwiftyUserDefaults

typealias Completion = (_ success: Bool?, _ error: Error?) -> Void

class AuthService {
    private static let _instance = AuthService()
    static var instance: AuthService {
        return _instance
    }
    
    
    func signIn(email: String, password: String, completion: @escaping Completion){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                completion(false, error)
            } else {
                completion(true, nil)
                //Successfully logged in
                Analytics.setUserID(user?.uid)
                Defaults[.key_uid] = user?.uid
                Defaults[.email] = email
                DispatchQueue.main.async {
                    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logInUser()
                }
            }
        })
    }
    
    
    // Sign Up
    func signUp (name: String, email: String, password: String, completion: @escaping Completion) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("ERROR:\(String(describing: error?.localizedDescription))")
                completion(false, error)
            } else {
                let userInfo = ["name": name, "email": email, "uid": user!.uid]
                self.completeSignIn(id: user!.uid, userData: userInfo)
                completion(true, nil)
            }
        })
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.instance.createFirebaseDBUser(id, userData: userData)
        Defaults[.key_uid] = id
    }
}


