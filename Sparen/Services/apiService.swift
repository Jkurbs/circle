//
//  DataService.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseDynamicLinks
import FirebaseMessaging



typealias Completion = (_ success: Bool, _ error: Error?, _ data: Any?) -> Void

class DataService: DataProtocol {
    
    
    private static let _call = DataService()
    
    static var call: DataService {
        return _call
    }
    
    var RefBase: DatabaseReference {
        return Database.database().reference()
    }
    
    var RefUsers: DatabaseReference {
        return Database.database().reference().child("users")
    }
    
    var RefCurrentUserInfo: DatabaseReference {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else {
            fatalError()
        }
        return Database.database().reference().child("userInfo").child(uid)
    }
    
    var RefCurrentUser: DatabaseReference {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else {
            fatalError()
        }
        return RefUsers.child(uid)
    }
    
    var refUserInsights: DatabaseReference {
        return RefBase.child("usersInsights")
    }
    
    var RefCircles: DatabaseReference {
        return RefBase.child("circles")
    }
    
    var RefRequests: DatabaseReference {
        return RefBase.child("requests")
    }
    
    
    var RefCircleMembers: DatabaseReference {
        return RefBase.child("members")
    }
    
    var RefCircleInsights: DatabaseReference {
        return RefBase.child("insights")
    }
    
    var RefTokens: DatabaseReference {
        return RefBase.child("tokens")
    }
    
    var RefCards: DatabaseReference {
        return RefBase.child("cards")
    }
    
    var REF_STORAGE: StorageReference {
        return Storage.storage().reference()
    }
    
    
    var currentUserHandle: DatabaseHandle!
    var currentUserActHandle: DatabaseHandle!
    var circleHandle: DatabaseHandle!
    var circleInsightHandle: DatabaseHandle!
    var circleMembersHandle: DatabaseHandle!
    var requestHandle: DatabaseHandle!

    
    private var handle: AuthStateDidChangeListenerHandle!

    
   let DYNAMIC_LINK_DOMAIN = "fk4hq.app.goo.gl"
   var shortLink: URL?
   var fileUrl: String?
    
   var insights = [Insight]()
   var circles = [Circle]()
    
    
    
    // MARK: Protocols
    
    // MARK: Get Current User
    
    func fetchCurrentUser(complete: @escaping (Bool, Error?, User) -> ()) {
                
      if let string = UserDefaults.standard.string(forKey: "userId"), !string.isEmpty {
      DataService.call.RefUsers.child(string).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else {return}
            let postDict = value as? [String : AnyObject] ?? [:]
            let key = snapshot.key
            let user = User(key: key, data: postDict)
        
            let circleId =  user.circle ?? ""
        
            UserDefaults.standard.set(circleId, forKey: "circleId")
            UserDefaults.standard.synchronize()
            complete(true, nil, user)
        })
    }
}

    
    // MARK: User Activities
    
    func fetchUserInsights(_ userId: String, complete: @escaping (Bool, Error?, Int, Int, Int) -> ()) {
        refUserInsights.child(userId).observe(.value, with: { (snapshot) in
            guard let value = snapshot.value, let postDict = value as? [String : AnyObject]  else {return}
            
            if let daysTotal = postDict["daysTotal"] as? Int, let  daysLeft =  postDict["daysLeft"] as? Int, let position = postDict["position"] as? Int {
                complete(true, nil, daysTotal, daysLeft, position)
            }
        })
    }

    
    
    
    // MARK: Create Circle
    
    func createCircle(_ amount: Int ,complete: @escaping (Bool, Error?) -> ()) {
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let data: [String: Any] = ["activated": false, "admin": userID, "amount": amount, "members": 0, "round": 0]
        
        RefCircles.childByAutoId().setValue(data) { (error, ref) in
            if let err = error {
                complete(false, err)
                return
            } else {
                
                guard let key = ref.key else {return}
                
                UserDefaults.standard.set(key, forKey: "circleId")

                self.createLink(circleID: key, completion: { (success, error, link) in
                    if !success {
                        complete(false, error)
                    } else {
                        ref.updateChildValues(["link": link])
                        self.RefCircleMembers.child(key).setValue([userID: true])
                        
//                        self.post(ref.key, endDate: myString)
                        Messaging.messaging().subscribe(toTopic: key)
                        complete(true, nil)
                    }
                })
//            let timeref =  DataService.call.RefBase.child("timer").child(ref.key)
//
//            timeref.setValue(["start": ServerValue.timestamp()])
//
//            timeref.observeSingleEvent(of: .value, with: { (snapshot) in
//                    guard let value = snapshot.value else {return}
//
//                    let postDict = value as? [String : AnyObject] ?? [:]
//
//                    let created = postDict["start"] as! TimeInterval
//
//                    let date = Date(timeIntervalSince1970: created/1000)
//
//                    let futureTime = date.dateAt(.tomorrow)
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    let myString = formatter.string(from: futureTime)
//
//                    timeref.updateChildValues(["end_date": myString])
//
//
//                })
            }
        }
    }
    
    lazy var functions = Functions.functions()

    
    func retrieveBalance(complete: @escaping (_ success: Bool, _ error: Error?, _ balance: Int) -> ()) {
        
        functions.httpsCallable("RetrieveBalance").call(["userId": Auth.auth().currentUser?.uid]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            if let text = (result?.data as? [String: Any])?["amount"] as? Int {
                complete(true, nil, text/100)
            }
        }
    }
    
    
    
    
    func post(_ circleId: String, endDate: String) {
        let parameters = ["circleId": circleId, "endDate": endDate]
        guard let url = URL(string: "https://us-central1-sparen-1d39d.cloudfunctions.net/SetTimer") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let res = response {
                print(res)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    

    // MARK: Current User Circle
    
    func fetchCurrentUserCircle(_ circleId: String?, complete: @escaping (Bool, Error?, Circle) -> ()) {
        guard let circleId = circleId else {return}
        
        self.circleHandle = RefCircles.child(circleId).observe(.value, with: { (snapshot) in
            guard let value = snapshot.value, let postDict = value as? [String : AnyObject]  else {return}

            let key = snapshot.key
            let circle = Circle(key: key, data: postDict)
            UserDefaults.standard.set( circle.link ?? "", forKey: "link")
            UserDefaults.standard.set( circle.adminId ?? "", forKey: "admin")
            UserDefaults.standard.set(circle.created, forKey: "time")
            complete(true, nil, circle)
        })
    }

    
    // MARK: Circle Insights
    
    func fetchCircleInsights(_ circleId: String?, complete: @escaping (Bool, Error?, Insight) -> ()) {
        
        guard let circleId = circleId else {return}
        
         RefCircleInsights.child(circleId).observe(.value, with: { (snapshot) in
            guard let value = snapshot.value else {return}
            guard let postDict = value as? [String : AnyObject] else {
                return
            }
            let key = snapshot.key
            let insight = Insight(key: key, data: postDict)
            complete(true, nil, insight)
        })
    }
    

    
    // MARK: Circle Members
    
    func fetchMembers(complete: @escaping (Bool, Error?, User) -> ()) {
        
        guard let circleId  = UserDefaults.standard.string(forKey: "circleId") else {return}
        
        circleMembersHandle = RefCircleMembers.child(circleId).observe( .value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let key = rest.key
                self.RefUsers.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value, let postDict = value as? [String : AnyObject] else {return}
                    let key = snapshot.key
                    let user = User(key: key, data: postDict)
                    complete(true, nil, user)
                })
            }
        }
    }
    

    
    
    // MARK: Find Circles
    
    func findCircles(complete: @escaping (Bool, Error?, Circle?) -> ()) {
        
        RefCircles.queryOrdered(byChild: "activated").queryEqual(toValue: false).observe(.value, with: { (snapshot) in
            
            guard snapshot.exists() else { return }

                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let key = rest.key
                    let data = rest.value as?  [String : AnyObject]
                    let circle = Circle(key: key, data: data!)
                    if circle.adminId == Auth.auth().currentUser?.uid {
                        return
                    }
                    complete(true, nil, circle)
                }
        })
    }
    
    
     // MARK: Find Circles members
    func findCircleMembers(_ circleId: String, complete: @escaping (Bool, Error?, User, Int) -> ()) {
        RefCircleMembers.child(circleId).queryLimited(toLast: 3).observeSingleEvent(of: .value) { (snapshot) in
            
            let enumerator = snapshot.children

            let count = enumerator.allObjects.count
            
            guard let value = snapshot.value else {return}
            guard let postDict = value as? [String : AnyObject] else {
                return
            }
            
            for key in postDict.keys {
                self.RefUsers.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value, let postDict = value as? [String : AnyObject] else {return}
                    let key = snapshot.key
                    let user = User(key: key, data: postDict)
                    complete(true, nil, user, count)
                })
            }
        }
    }
    
    func positionRequest(users: [User], _ first: Int, _ second: Int, complete: @escaping (Bool, Error?) -> ()) {
        
        guard let circleId = UserDefaults.standard.string(forKey: "circleId") else { return }
        
        let from = Auth.auth().currentUser?.uid
        let name = Auth.auth().currentUser?.displayName
        let to = users[first].userId
        
        let values = ["from": from ?? "", "name": name ?? "", "position": first,  "forPosition": second, "seen": false,  "time": ServerValue.timestamp()] as [String : Any]

        if to == from && from == Auth.auth().currentUser!.uid {
            complete(false, nil)
            return
        }
        
        
        DataService.call.RefRequests.child(circleId).child(to!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let postDict = rest.value as! [String : AnyObject]
                    let forPosition = postDict["forPosition"] as! Int
                    let from  = postDict["from"] as! String
                    
                    if forPosition == second , from == Auth.auth().currentUser!.uid {
                        print("EQUAL")
                        complete(false, nil)
                        return
                    }
                }
                
                self.sendPositionRequest(circleId, to!, values, complete: { (success, error) in
                    if !success {
                        complete(false, error)
                    } else {
                        complete(true, nil)
                    }
                })
            } else {
                self.sendPositionRequest(circleId, to!, values, complete: { (success, error) in
                    if !success {
                        complete(false, error)
                    } else {
                        complete(true, nil)
                    }
                })
            }
        }
    }
    
    func sendPositionRequest(_ circleId: String, _ to: String, _ values: [String: Any], complete: @escaping (Bool, Error?) -> ()) {
        
        DataService.call.RefBase.child("requests").child(circleId).child(to).childByAutoId().setValue(values) { (error, ref) in
            if error != nil {
                complete(false, error)
            } else {
                complete(true, error)
            }
        }
    }
    
    
    
    
    // MARK: Add Payment Token
    
    func addPayment(_ accountToken: String, _ sourceToken: String, _ type: String, _ expirationDate: String, _ last4: String, _ prefix: String, complete: @escaping (Bool, Error?) -> ()) {
        
        self.RefCards.child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["accountToken": accountToken, "sourceToken": sourceToken,  "type": type, "expDate": expirationDate, "last4": last4, "prefix": prefix], withCompletionBlock: { (error, ref) in
            if let err = error {
                complete(false, err)
                return
            }
            complete(true, nil)
        })

    }


func addPayment(_ token: String, _ last4: String, _ data: Data, complete: @escaping (Bool, Error?) -> ()) {
    
    let storageItem = Storage.storage().reference().child("cards").child(token)
    
    self.saveImageData(storageItem, data) { (url, success, error) in
        if !success {
            print("error:", error!.localizedDescription)
        } else {
            self.RefCards.child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["token": token, "last4": last4, "image_url": url ?? ""], withCompletionBlock: { (error, ref) in
                if let err = error {
                    complete(false, err)
                    return
                }
                complete(true, nil)
            })
        }
    }
}
    
    
    
    
    
    
    
    // MARK: Tokens
    
    func saveToken(_ state: Bool, _ token: String, _ circleId: String, complete: @escaping (Bool, Error?) -> ()) {
        
        
        if state {
            RefTokens.child(Auth.auth().currentUser!.uid).setValue(["device_token": token]) { (error, ref) in
                if let err = error {
                    print("error:", err.localizedDescription)
                    complete(false, err)
                    return
                }
                
                Messaging.messaging().subscribe(toTopic: circleId) { (error) in
                    if let error = error {
                        print("error:", error.localizedDescription)
                        return
                    }
                    complete(true, nil)
                }
            }
        } else {
            RefTokens.child(Auth.auth().currentUser!.uid).removeValue()
            Messaging.messaging().unsubscribe(fromTopic: circleId)
        }
    }
    
    
    // MARK: Join/Leave Circle
    
    func joinCircle(_ circleId: String?, complete: @escaping (_ success: Bool, _ error :Error?) -> ()) {
        
        guard let userID = Auth.auth().currentUser?.uid, let circleId = circleId else {return}
        self.RefCircleMembers.child(circleId).updateChildValues([userID: ServerValue.timestamp()]) { (error, ref) in

            if let err = error {
                print("error:", err)
                complete(false, err)
                return
            } else {
                complete(true, nil)
            }
    }
}
    
    func leaveCircle(_ circle: Circle, _ position: Int, complete: @escaping (Bool, Error?) -> ()) {
        
        guard let userID = Auth.auth().currentUser?.uid, let circleId = circle.id else {return}
        self.RefCircleMembers.child(circleId).child(userID).removeValue { (error, ref) in
            if let err = error {
                print("error:", err)
                return
            } else {
                self.RefUsers.child(userID).child("daysLeft").removeValue()
                self.RefUsers.child(userID).child("daysTotal").removeValue()
                self.RefUsers.child(userID).child("circleId").removeValue()
                
                DataService.call.RefCircles.child(circleId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value else {return}
                    let members = value as! Int
                    DataService.call.RefCircles.child(circleId).updateChildValues(["members": members - 1])
                 })
                
                Messaging.messaging().unsubscribe(fromTopic: circleId)
                UserDefaults.standard.removeObject(forKey: "circleId")
                UserDefaults.standard.synchronize()
                complete(true, nil)
            }
        }
        updateUsersPositions(circle.id!, position)
    }
    
    
    func updateUsersPositions(_ circleId: String, _ positionLeft: Int) {

        DataService.call.RefCircleMembers.child(circleId).observeSingleEvent(of: .value) { (snapshot) in

            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let key = rest.key

                DataService.call.RefUsers.child(key).child("position").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value else {return}
                    let position = value as! Int
                    if position > positionLeft {
                        DataService.call.RefUsers.child(key).updateChildValues(["position": position - 1])
                    }
                })
            }
        }
    }

    
    
    // MARK: Activate Circle
    
    func activateCircle(_ circle: Circle, complete: @escaping (Bool, Error?) -> ()) {
        var members = [User]()
        
        self.fetchMembers { (success, error, member) in
            if !success {
                complete(false, error)
            } else {
                members.append(member)
                let count = members.count
                print("count:::", count)
                if members.count < 1 {
                    // Not enought members
                    print("NOT ENOUGH MEMBERS")
                    return
                } else {
                    // Calculation for User
                    guard let position = member.position else {return}
                    let days_total = position * 7
                    
                    print("days_total::", days_total)
                    
                    // Calculation for Circle
                    if let totalAmount = circle.amount {
                        let weeklyAmount = Double(totalAmount) / Double(count)
                        let circleDaysTotal = count * 7
                        let circleDaysLeft = circleDaysTotal - 1
                        
                        let userData: [String: Any] = ["days_total": days_total, "days_left": days_total - 1]
                        
                        let circleData = ["days_total": circleDaysTotal, "days_left": circleDaysLeft, "weekly_amount": weeklyAmount, "total_amount" : totalAmount] as [String : Any]
                        
                        self.RefUsers.child(member.userId!).updateChildValues(userData)
                        self.RefCircles.child(circle.id!).updateChildValues(["activated": true])
                        self.RefCircleInsights.child(circle.id!).updateChildValues(circleData)
                    
                    }
                }
            }
        }
    }
    
    
    // MARK: Save User Data
    
    func saveUserData(_ userId: String, _ data: [String : Any], complete: @escaping (Bool, Error?) -> ()) {
        RefUsers.child(userId).setValue(data) { (error, ref) in
            if let err = error {
                print("ERROR::", err.localizedDescription)
                complete(false, err)
            } else {
                complete(true, nil)
            }
        }
    }
    
    
    // MARK: Save User Data
    
    func updateUserData(_ username: String, _ fullname: [String], _ email: String, _ phone: String, _ image: UIImage, complete: @escaping (Bool, Error?) -> ()) {
        
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            guard fullname.count > 1 else {return}
            let firstName = fullname.first ?? ""
            let lastName = fullname.last ?? ""
            
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                
                if let user = user {
                    guard let password = UserDefaults.standard.string(forKey: "password") else {return}
                    
                    let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
                    
                    user.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
                        if let error = error {
                            complete(false, error)
                        } else {
                            print("AUTHENTICATE")
                            let storageItem = DataService.call.REF_STORAGE.child("profile_images").child(user.uid)
                            
                            self.saveImageData(storageItem, imageData, { (url, success, error) in
                                if !success {
                                    complete(false, error)
                                } else {
                                    print("SAVE IMAGE")
                                    if let url = url {
                                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        changeRequest?.displayName = firstName
                                        changeRequest?.photoURL = URL(string: url)
                                        changeRequest?.commitChanges { (error) in
                                            
                                            if let err = error  {
                                                complete(false, err)
                                            }
                                            
                                            let data = ["image_url": url, "user_name": username, "first_name": firstName, "last_name": lastName, "email": email] as [String : Any]
                                            self.RefUsers.child(user.uid).updateChildValues(data, withCompletionBlock: { (error, ref) in
                                                
                                                if let error = error {
                                                    complete(false, error)
                                                } else {
                                                    complete(true, nil)
                                                }
                                            })
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    
    
    
    
    func saveImageData(_ ref: StorageReference, _ data: Data, _ completion: @escaping (_ url: String?, _ success: Bool, _ error: Error?) -> ()) {
        let imgUID = NSUUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        ref.putData(data, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Couldn't Upload Image")
            } else {
                print("Uploaded")
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if url != nil {
                        completion(url!.absoluteString, true, nil)
                    }
                })
            }
        }
    }
    
    
    func createLink(circleID: String, completion: @escaping ( _ success: Bool, _ error: Error?, _ link: String)->() ) {
        
        
        guard let link = URL(string: "https://www.sparenapp.com/?id=\(circleID)") else { return }
        let dynamicLinksDomainURIPrefix = "https://sparen.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.Kurbs.Sparen")
        
        
        
        
        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink.absoluteString)")
        
        completion(true, nil,longDynamicLink.absoluteString)

        
        
//        guard let link = URL(string: "https://www.sparenapp.com/id:\(circleID)") else { return}
//        let dynamicLinksDomain = "sparen.page.link"
//
//        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomain)
//
//
//        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.Kurbs.Sparen")
//        linkBuilder?.iOSParameters?.appStoreID = "389801252"
//
//        linkBuilder?.options = DynamicLinkComponentsOptions()
//        linkBuilder?.options?.pathLength = .default
//
//        guard let longDynamicLink = linkBuilder.url else { return }
//
//
////        linkBuilder.shorten { (url, warnings, error) in
////            if let error = error {
////                print("ERROR SHORTEN LINK:", error.localizedDescription)
////                return
////            }
////            guard let url = url else {return}
////            print("The short URL is: \(url)")
////        }
//
//        completion(true, nil,(linkBuilder?.link.absoluteString)!)

    }

    
    var users = [User]()
    var nextPayoutUsers = [User]()

    

    
    func saveCurrentUserInfo(name: String, email: String, data: Data) {
        let user = Auth.auth().currentUser!
        let filePath = "\(String(describing: user.uid))/\(Int(NSDate.timeIntervalSinceReferenceDate))"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        
        
        REF_STORAGE.child(filePath).putData(data, metadata: metaData) { (metadata, error) in
            if let err = error {
                print("ERROR SAVE PROFILE IMAGE: \(err.localizedDescription)")
            }

        }
        
        
        
        
        REF_STORAGE.child(filePath).putData(data, metadata: metaData) { (metadata, error) in
            if let err = error {
                print("ERROR SAVE PROFILE IMAGE: \(err.localizedDescription)")
            }

//            if !metadata!.downloadURLs![0].absoluteString.isEmpty {
//                self.fileUrl = metadata!.downloadURLs![0].absoluteString
//            }
            
            let changeRequestProfile = user.createProfileChangeRequest()
            changeRequestProfile.photoURL = URL(string: self.fileUrl!)
            changeRequestProfile.displayName = name
            changeRequestProfile.commitChanges(completion: { (error) in
                if let error = error {
                    print("Error to commit photo change: \(error.localizedDescription)")
                } else {
                    
                }
            })
            
            user.updateEmail(to: email, completion: { (error) in
                if let error = error {
                    print("ERROR SAVING EMAIL: \(error.localizedDescription)")
                }
            })
            
            let userInfo : [String: Any] = ["email": email, "name": name, "photoUrl": self.fileUrl!]
           //let userRef = DataService.instance.REF_USERS.document(user.uid)
           // userRef.updateData(userInfo)
        }
    }
    
    

    
    //MARK: Sign up Data Flow
//
//    func saveNamePassword(firstName: String, lastName: String, email: String, password: String, dobDay: String, dobMonth: String, dobYear: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
//
//         let data: [String: Any] = ["first_name": firstName, "last_name": lastName,"dob_day": dobDay, "dob_month": dobMonth, "dob_year": dobYear]
//
//         RefUsers
//
////
////        updateData(data, completion: { (error) in
////            if let error = error {
////                print("ERROR:", error.localizedDescription)
////                completion(false, error)
////            } else {
////                Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
////                    if let error = error {
////                        completion(false, error)
////                        print("ERROR SAVING PASSWORD:", error.localizedDescription)
////                    } else {
////                        completion(true, nil)
////                    }
////                })
////
////                if let user = Auth.auth().currentUser {
////                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
////                    user.link(with: credential, completion: { (user, error) in
////                        if let error = error {
////                            completion(false, error)
////                            print("ERROR LINKING USER: \(error.localizedDescription)")
////                        } else {
////                            completion(true, nil)
////                        }
////                    })
////                }
////            }
////        })
//    }
    
    
//    func saveBankInformation(email: String, plaid: [String: Any], completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
//        let ref =  REF_USERS.document(Auth.auth().currentUser!.uid)
//        let circleId = UserDefaults.standard.string(forKey: "circleId") ?? ""
//        ref.updateData(["email_address": email, "circle": circleId]) { (error) in
//            if let error = error {
//                completion(false, error)
//            } else {
//                ref.collection("plaid").addDocument(data: plaid)
//                ref.getDocument(completion: { (document, error) in
//                    if let error = error {
//                        print("ERROR:", error.localizedDescription)
//                    } else {
//                        if let data = document?.data() {
//                            DataService.call.REF_CIRCLES.document(circleId).collection("insiders").addDocument(data: data, completion: { (error) in
//                                if let error = error {
//                                    print("ERROR:", error.localizedDescription)
//                                }
//                            })
//                        }
//                    }
//                })
//                completion(true, nil)
//            }
//        }
//    }
    

    func getIP() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
         
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }


    
    func createDynamicLink(link: String?, _ completion: @escaping (_ success: Bool, _ error: Error?, _ link: String?) -> ()) {
        // general link params
        guard let linkString = link else {
            completion(false, nil, nil)
            return
        }
        
        let link = URL(string: linkString)
        
        let components = DynamicLinkComponents(link: link!, domain: self.DYNAMIC_LINK_DOMAIN)
        
        let options = DynamicLinkComponentsOptions()
        options.pathLength = .short
        components.options = options
        
        components.shorten { (shortURL, warnings, error) in
            // Handle shortURL.
            if let error = error {
                print(error.localizedDescription)
                completion(false, error, nil)
                return
            }
            self.shortLink = shortURL
            completion(true, nil, shortURL?.absoluteString)
        }
    }
    
    
    func getUrlId(id: String) -> String? {
        return URLComponents(string: id)?.queryItems?.first(where: { $0.name == "c" })?.value
    }
}




extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}


func timeAgoSinceDate(date: Date, numericDates:Bool) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now as Date
    let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
    
    if (components.year! >= 2) {
        return "\(components.year!) y"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1y"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)w"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1w"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!)d"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1d"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!)h"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1h"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!)m"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1m"
        } else {
            return "A min ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
}


func convertDate(postDate: Int) -> String {
    let date = postDate / 1000
    let foo: TimeInterval = TimeInterval(date)
    let theDate = NSDate(timeIntervalSince1970: foo)
    let time = timeAgoSinceDate(date: theDate as Date, numericDates: true)
    return time.lowercased()
    
}


extension Date {
    
    func offsetFrom() -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}

