//
//  Services.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import FirebaseAuth


typealias Completion = (_ success: Bool, _ error: Error?) -> Void

class AuthService {
    private static let _instance = AuthService()
    static var instance: AuthService {
        return _instance
    }
    
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func signIn(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?, _ circleId: String?) -> ()) {
        UserDefaults.standard.set(password, forKey: "password")
        Auth.auth().signIn(withEmail: email, password: password, completion: { (currentUser, error) in
            if error != nil {
                completion(false, error, nil)
            } else {
                UserDefaults.standard.set(currentUser!.user.uid, forKey: "userId")
                    DataService.call.REF_USERS.document(currentUser!.user.uid).getDocument { (document, error) in
                        guard let doc = document else {return}
                        let key = doc.documentID
                        let data = doc.data()
                        let user = User(key: key, data: data)
                        
                        if UIApplication.shared.isRegisteredForRemoteNotifications {
                            if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
                                DataService.call.REF_USERS.document(currentUser!.user.uid).updateData(["device_token": deviceToken])
                            }
                        }
                        
                        guard let circleId = user.circle else {
                             completion(true, nil, nil)
                            return
                        }
                        UserDefaults.standard.set(circleId, forKey: "circleId")
                        completion(true, nil, circleId)
                    }
                }
        })
    }

    
    
   func verifyPhone(phoneNumber: String, viewController: UIViewController, completion: @escaping Completion) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(false, error)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(true, nil)
        }
    }
    
    
    func createAccount(firstName: String, lastName: String, email: String, phoneNumber: String, password: String, code: String, position: Int, isAdmin: Bool, completion: @escaping Completion) {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let error = error {
                completion(false, error)
            } else {
                if let user = result?.user {
                       user.linkAndRetrieveData(with: emailCredential, completion: { (result, error) in
                        if let error = error {
                            print("ERROR LINK ACCOUNT:", error.localizedDescription)
                            completion(false, error)
                        } else {
                            //let ip = DataService.call.getIP()[1]
                            //DataService.call.saveDeviceInfo(phoneNumber, ip)
                            let ref =  DataService.call.REF_CIRCLES.document()
                            UserDefaults.standard.set(ref.documentID, forKey: "circleId")
                            UserDefaults.standard.set(password, forKey: "password")
                            DataService.call.createLink(circleID: ref.documentID, completion: { (success, error, link) in
                                if let error = error {
                                    print("error creating link:", error.localizedDescription)
                                    completion(false, error)
                                    return
                                } else {
                                    let data: [String: Any] = ["id": user.uid, "circle": ref.documentID,"first_name": firstName, "last_name": lastName, "email_address": email, "phone_number": phoneNumber, "position": position, "is_admin": isAdmin]
                                    DataService.call.createCircle(userID: user.uid, link: link, data: data, complete: { (success, error) in
                                        if let error = error {
                                            print("error creation circle:", error.localizedDescription)
                                            completion(false, error)
                                        } else {
                                           completion(true, nil)
                                        }
                                    })
                                }
                            })
                        }
                    })
                }
            }
        }
    }

    
    
    // Sign Up
    func signUp (name: String, email: String, phoneNumber: String, password: String, completion: @escaping Completion) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("ERROR:\(String(describing: error?.localizedDescription))")
                completion(false, error)
            } else {
                let userInfo = ["name": name, "email": email, "uid": user!.user.uid]
                self.completeSignIn(id: user!.user.uid, userData: userInfo)
                completion(true, nil)
            }
        })
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
    }
}


