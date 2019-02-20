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
    
    private var handle: AuthStateDidChangeListenerHandle!
    
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
    
    


    func createAccount(_ firstName: String, _ lastName: String, _ email: String, _ phoneNumber: String, _ password: String, _ code: String, _ isAdmin: Bool, _ dateOfBirth: [String?], complete: @escaping (Bool, Error?) -> ()) {
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
                            UserDefaults.standard.synchronize()
                            user.linkAndRetrieveData(with: credential, completion: { (result, error) in
                                if let error = error {
                                    print("ERROR:", error.localizedDescription)
                                    complete(false, error)
                                    return
                                } else {
                                    let changeRequest = result?.user.createProfileChangeRequest()
                                    changeRequest?.displayName = firstName
                                    changeRequest?.commitChanges { (error) in
                                        print("ERROR:", error?.localizedDescription)
                                        let data: [String: Any] = ["first_name": firstName, "last_name": lastName, "email": email, "phoneNumber": phoneNumber]
                                        DataService.call.saveUserData(user.uid, data, complete: { (success, error) in
                                            if !success {
                                                print("ERROR SAVING:", error!.localizedDescription)
                                                complete(false, error)
                                            } else {
                                                self.addDateOfBird(userId: user.uid, dateOfBirth: dateOfBirth)
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
    }
    
    func addDateOfBird(userId: String, dateOfBirth: [String?]) {
        
        
        guard let day = Int(dateOfBirth[0]!), let month = dateOfBirth[1], let year = Int(dateOfBirth[2]!) else {return}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let aDate: Date? = formatter.date(from: month)
        var components: DateComponents? = nil
        if let aDate = aDate {
            components = Calendar.current.dateComponents(in: .current, from: aDate)
        }
        
        DataService.call.RefUsers.child(userId).child("dateOfBirth").updateChildValues(["day": day, "month": components!.month, "year": year])
    }
    
    
    func authUserEmail(_ email: String) {
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            
            if let error = error {
                  print("error updating email", error.localizedDescription)
                } else {
            }
        }
    }
    
    func updatePassword(_ currentPassword: String, _ newPassword: String, complete: @escaping (Bool, Error?) -> ()) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
                user.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
                    if error != nil {
                        complete(false, error)
                        return
                    } else {
                        user.updatePassword(to: newPassword, completion: { (error) in
                            if error != nil {
                                complete(false, error)
                                return
                            } else {
                                complete(true, nil)
                            }
                        })
                    }
                })
            }
        }
    }
}



