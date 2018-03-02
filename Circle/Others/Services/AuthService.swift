//
//  Services.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import FirebaseAuth


typealias Completion = (_ success: Bool?, _ error: Error?) -> Void

class AuthService {
    private static let _instance = AuthService()
    static var instance: AuthService {
        return _instance
    }
    
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func signIn(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?, _ circleId: String?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                completion(false, error, nil)
            } else {
                UserDefaults.standard.set(user!.uid, forKey: "userId")
                DispatchQueue.background(delay: 0.0, background: {
                    DataService.instance.REF_USERS.document(user!.uid).getDocument { (document, error) in
                        if let error = error {
                            print("ERROR:::", error.localizedDescription)
                            return
                        }
                        let data = document?.data()
                        let circleId = data!["circle"] as! String
                        UserDefaults.standard.set(circleId, forKey: "circleId")
                        completion(true, nil, circleId)
                    }
                }, completion: nil)
            }
        })
    }

    
    
   func phoneAuth(phoneNumber: String, viewController: UIViewController, completion: @escaping Completion) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(false, error)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            print("VERIFICATION ID:", verificationID)
            completion(true, nil)
        }
    }
    
    func phoneVerification(phoneNumber: String, verificationCode: String, completion: @escaping Completion) {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                completion(false, error)
            } else {
                let ip = DataService.instance.getIP()[1]
                DataService.instance.saveDeviceInfo(phoneNumber: phoneNumber, ipAddress: ip)
                    completion(true, nil)
            }
        }
    }
    
    func resendVerificationCode() {
 
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
    }
}


