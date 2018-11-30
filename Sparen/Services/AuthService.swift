//
//  Services.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import FirebaseAuth


//
//  Services.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import FirebaseAuth

class AuthService: AuthProtocol {
    
    private static let _instance = AuthService()
    static var instance: AuthService {
        return _instance
    }
    
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func verifyPhone(_ phoneNumber: String, complete: @escaping (Bool, Error?) -> ()) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                complete(false, error)
                return
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                complete(true, nil)
            }
        }
    }
    
    
    func signIn(_ email: String, _ password: String, complete: @escaping (Bool, Error?, String?) -> ()) {
        UserDefaults.standard.set(password, forKey: "password")
        Auth.auth().signIn(withEmail: email, password: password, completion: { (currentUser, error) in
            if error != nil {
                complete(false, error, nil)
            } else {
                UserDefaults.standard.set(currentUser!.user.uid, forKey: "userId")
                
                DataService.call.RefUsers.child(currentUser!.user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else {return}
                    let circleId = value["circleId"] as? String ?? ""
                    
                    if UIApplication.shared.isRegisteredForRemoteNotifications {
                        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
                            DataService.call.RefTokens.child((currentUser?.user.uid)!).setValue(["device_token": deviceToken])
                        }
                    }
                    
                    UserDefaults.standard.set(circleId, forKey: "circleId")
                    complete(true, nil, circleId)
                })
            }
        })
    }
    
    


    func createAccount(_ firstName: String, _ lastName: String, _ email: String, _ phoneNumber: String, _ password: String, _ code: String, _ position: Int, _ isAdmin: Bool, complete: @escaping (Bool, Error?) -> ()) {
        let defaults = UserDefaults.standard
        
    
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error {
                complete(false, err)
                return
            } else {
                
                let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
                
                let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
                
                Auth.auth().signInAndRetrieveData(with: emailCredential, completion: { (result, error) in
                    if let err = error  {
                        complete(false, err)
                        return
                    } else {
                        if let user = result?.user {
                            UserDefaults.standard.set(user.uid, forKey: "userId")
                            user.linkAndRetrieveData(with: credential, completion: { (result, error) in
                                if let error = error {
                                    complete(false, error)
                                    return
                                } else {
                                    let changeRequest = result?.user.createProfileChangeRequest()
                                    changeRequest?.displayName = firstName
                                    changeRequest?.commitChanges { (error) in
                                        let data: [String: Any] = ["first_name": firstName, "last_name": lastName, "email": email, "phoneNumber": phoneNumber]
                                        DataService.call.saveUserData(user.uid, data, complete: { (success, error) in
                                            if !success {
                                                complete(false, error)
                                            } else {
                                                //let ip = DataService.call.getIP()[1]
                                                UserDefaults.standard.set(password, forKey: "password")
                                                complete(true, nil)
                                            }
                                        })
                                    }
                                }
                            })
                        }
                    }
                })
            }
        }
        
        
//        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
//
//        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
//
//
//        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
//            if let error = error {
//                complete(false, error)
//                return
//            } else {
//
//                if let user = result?.user {
//                    UserDefaults.standard.set(user.uid, forKey: "userId")
//                    user.linkAndRetrieveData(with: emailCredential, completion: { (result, error) in
//                        if let error = error {
//                            complete(false, error)
//                            return
//                        } else {
//                            let changeRequest = result?.user.createProfileChangeRequest()
//                            changeRequest?.displayName = firstName
//                            changeRequest?.commitChanges { (error) in
//                                let data: [String: Any] = ["first_name": firstName, "last_name": lastName, "email": email, "phoneNumber": phoneNumber, "position": position, "is_admin": isAdmin]
//                                DataService.call.saveUserData(user.uid, data, complete: { (success, error) in
//                                    if !success {
//                                        complete(false, error)
//                                    } else {
//                                        //let ip = DataService.call.getIP()[1]
//                                        UserDefaults.standard.set(password, forKey: "password")
//                                        complete(true, nil)
//                                    }
//                                })
//                            }
//                        }
//                    })
//                }
//            }
//        }
    }
    
    
    func authUserEmail(_ email: String) {
        
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            
            if let error = error {
                  print("error updating email", error.localizedDescription)
                } else {
            }
        }
    }
}



