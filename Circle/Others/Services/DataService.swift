//
//  DataService.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

import FirebaseDynamicLinks

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var REF_BASE: Firestore {
        return Firestore.firestore()
    }
    
    var REF_USERS: CollectionReference {
        return Firestore.firestore().collection("users")
    }
    
    var REF_USER_CURRENT: DocumentReference {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else {
            fatalError()
        }
        return REF_USERS.document(uid)
    }
    
    var REF_CIRCLES: CollectionReference {
        return Firestore.firestore().collection("circles")
    }
    
    
    
    var REF_STORAGE: StorageReference {
        return Storage.storage().reference()
    }

   let DYNAMIC_LINK_DOMAIN = "fk4hq.app.goo.gl"
   var shortLink: URL?

    
    func createFirebaseDBUser(_ uid: String, userData: Dictionary<String, Any>) {
        // DataService.instance.REF_USERS.document(uid).setData(userData)
    }
    
    
    var fileUrl: String?
    
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
    
    
    
    func retrieveUser(_ uid: String,   _ completion: @escaping (_ success: Bool, _ error: Error?, _ user: User?, _ data: [String : Any]?, _ bank: Bank?, _ bankData: [String: Any]?)  -> ()) {
        let ref = DataService.instance.REF_USERS.document(uid)
        ref.getDocument { (document, error) in
            if let error = error {
                completion(false, error, nil, nil, nil, nil)
            } else {
                if let document = document {
                    if document.exists {
                        let data = document.data()
                        let key = document.documentID
                        ref.collection("sources").getDocuments(completion: { (documents, error) in
                            if let error = error {
                                print("Error getting source", error.localizedDescription)
                            } else {
                                for document in (documents?.documents)! {
                                    let bankData = document.data()
                                    let bankKey = document.documentID
                                    let bank = Bank(bankKey, bankData)
                                    let user = User(key: key, data: data!, bank: bank, event: nil, balance: nil)
                                    completion(true, nil, user, data, bank, bankData)
                                }
                            }
                       })
                   }
            } else {
                print("Document does not exist")
            }
        }
    }
}
    
    
    var listener: ListenerRegistration!
    
    
    func retrieveCircle(_ circleId: String?, _ completion: @escaping (_ success: Bool, _ error: Error?, _ circle: Circle?) -> ()) {
    
        guard let circleId = circleId else {
            return
          }
        listener = DataService.instance.REF_CIRCLES.document(circleId).addSnapshotListener { (document, error) in
                if let document = document {
                    if document.exists {
                        let data = document.data()
                        let key = document.documentID
                        let circle = Circle(key: key, data: data!, users: nil)
                        completion(true, nil, circle)
                }
            }
        }
    }
    
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
    
    
    
    
    
    
    
    
    
    private var insider: String?

    func getInsiders(_ circleId: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ insiders: User?) -> ()) {
       let ref = DataService.instance.REF_CIRCLES.document(circleId).collection("insiders")
            ref.order(by: "position", descending: false).getDocuments { (documents, error) in
            if let error = error {
                print("ERROR:::", error.localizedDescription)
                completion(false, error, nil)
                return
            }
            for document in (documents?.documents)! {
                if document.exists {
                    let data = document.data()
                    let key = document.documentID
                        DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("sources").getDocuments(completion: { (documents, error) in
                            if let error = error {
                                print("Error getting source", error.localizedDescription)
                            } else {
                                for document in (documents?.documents)! {
                                    if document.exists {
                                        let bankData = document.data()
                                        let bankKey = document.documentID
                                        let bank = Bank(bankKey, bankData)
                                        let insiders = User(key: key, data: data, bank: bank, event: nil, balance: nil)
                                        completion(true, nil, insiders)
                                } 
                            }
                        }
                    })
                }
            }
        }
    }

    
    func getPendingInsiders(_ circleId: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ pendingnUsers: User?) -> ()) {
        
        DataService.instance.REF_CIRCLES.document(circleId).collection("insiders").getDocuments { (documents, error) in
            if let error = error {
                print("ERROR:::", error.localizedDescription)
                completion(false, error, nil)
                return
            }
            for document in (documents?.documents)! {
                let data = document.data()
                let key = document.documentID
                let pendingInsiders = User(key: key, data: data, bank: nil, event: nil, balance: nil)
                completion(true, nil, pendingInsiders)
            }
        }
    }
    
    
    
    
    
    //MARK: Sign up Data Flow
    
    func saveNamePassword(firstName: String, lastName: String, email: String, password: String, dobDay: String, dobMonth: String, dobYear: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
         let data: [String: Any] = ["first_name": firstName, "last_name": lastName,"dob_day": dobDay, "dob_month": dobMonth, "dob_year": dobYear]
        
        REF_USERS.document(Auth.auth().currentUser!.uid).updateData(data, completion: { (error) in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                completion(false, error)
            } else {
                Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
                    if let error = error {
                        completion(false, error)
                        print("ERROR SAVING PASSWORD:", error.localizedDescription)
                    } else {
                        completion(true, nil)
                    }
                })
                
                if let user = Auth.auth().currentUser {
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    user.link(with: credential, completion: { (user, error) in
                        if let error = error {
                            completion(false, error)
                            print("ERROR LINKING USER: \(error.localizedDescription)")
                        } else {
                            completion(true, nil)
                        }
                    })
                }
            }
        })
    }
    
    
    func saveBankInformation(email: String, plaid: [String: Any], completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
        let ref =  REF_USERS.document(Auth.auth().currentUser!.uid)
        
        ref.updateData(["email_address": email]) { (error) in
            if let error = error {
                completion(false, error)
            } else {
                ref.collection("plaid").addDocument(data: plaid)
                completion(true, nil)
            }
        }
    }
    

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
    
    

    
    func saveDeviceInfo(_ phoneNumber: String, _ ipAddress: String) {
    let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
    let data: [String: Any] = ["ip_address": ipAddress, "device_token": deviceToken, "phone_number": phoneNumber]

    REF_USERS.document(Auth.auth().currentUser!.uid).setData(data, merge: true, completion: { (error) in
        if let error = error {
            print("ERROR IP", error.localizedDescription)
        } else {
            print("SUCCESSFULLY SAVED IP ADDRESS")
          }
       })
    }
    
    
    func saveContacts(contacts: [Contact]) {
        print("SAVE CONTACTS")
        for contact in contacts {
            let data: [String: Any] = ["phone_number": contact.phoneNumber ?? "", "first_name": contact.givenName ?? "", "last_name": contact.familyName ?? "", "email_address": contact.emailAddress ?? ""]
            
            REF_USERS.document(Auth.auth().currentUser!.uid).collection("contacts").addDocument(data: data) { (error) in
                if let error = error {
                    print("ERROR IP", error.localizedDescription)
                } else {
                    print("SUCCESSFULLY SAVED IP ADDRESS")
                }
            }
            break
        }
    }
    
    var childRef: String?
    var imageUrl: String?
    
    
    
    
    func addNewInsider(_ userId: String) {
        self.REF_USERS.document(userId).getDocument { (document, error) in
            if let error = error {
                print("Error::", error.localizedDescription)
        }
            let data = document!.data()
            if let circleId = UserDefaults.standard.string(forKey: "circleId") {
                self.REF_CIRCLES.document(circleId).setData(data!)
            }
        }
    }
    
    
    
    
    
    
    
    func createCircle(id: String, _ link: String?, _ insiders: [Contact], _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
            self.REF_CIRCLES.document(id).setData(["admin": Auth.auth().currentUser!.uid, "activated": false, "link": link ?? ""], merge: true) { (error) in
                if let error = error {
                    print("ERROR:", error.localizedDescription)
                    completion(false, error)
                } else {
                    self.REF_USERS.document(Auth.auth().currentUser!.uid).setData(["circle": id], merge: true)
                    for insider in insiders {
                        
                        if insider.imageData != nil {
                            self.saveImageData(insider.imageData!, { (url,success,error)  in
                                if !success {
                                    
                                } else {
                                    self.imageUrl = url
                                   }
                                })
                            }
                        
                        self.retrieveUser(Auth.auth().currentUser!.uid, { (success, error, user, data, card, cardData)    in
                            if !success {
                                print("ERROR RETRIEVING CURRENT USER")
                            } else {
                               self.REF_CIRCLES.document(id).collection("insiders").document(Auth.auth().currentUser!.uid).setData(data!)
                            self.REF_CIRCLES.document(id).collection("insiders").document(Auth.auth().currentUser!.uid).collection("sources").addDocument(data: cardData!)

                            }
                        })
                            let trimmedNumber = insider.phoneNumber?.removingWhitespaces()
                            let data: [String: Any] = ["activated": false, "phone_number": trimmedNumber ?? "", "first_name": insider.givenName ?? "", "last_name": insider.familyName ?? "", "email_address": insider.emailAddress ?? "", "image_url": self.imageUrl ?? ""]
                        self.REF_CIRCLES.document(id).collection("insiders").addDocument(data: data, completion: { (error) in
                            if let error = error {
                                print("ERROR SAVING INSIDERS", error.localizedDescription)
                                completion(false, error)
                            } else {
                                completion(true, error)
                        }
                    })
                }
            }
        }
    }
    
    
    func addInsidersToCircle(id: String, _ insiders: [Contact], _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        self.REF_USERS.document(Auth.auth().currentUser!.uid).setData(["circle": id], merge: true)

        for insider in insiders {
            
            if insider.imageData != nil {
                self.saveImageData(insider.imageData!, { (url,success,error)  in
                    if !success {
                        
                    } else {
                        self.imageUrl = url
                    }
                })
            }
            
            self.retrieveUser(Auth.auth().currentUser!.uid, { (success, error, user, data, card, cardData)   in
                if !success {
                    print("ERROR RETRIEVING CURRENT USER")
                } else {
                    print("RETRIEVING")
                    self.REF_CIRCLES.document(id).collection("insiders").document(Auth.auth().currentUser!.uid).setData(data!)
                     print("FINISH RETRIEVING")
                }
            })
            let trimmedNumber = insider.phoneNumber?.removingWhitespaces()
            let data: [String: Any] = ["activated": false, "phone_number": trimmedNumber ?? "", "first_name": insider.givenName ?? "", "last_name": insider.familyName ?? "", "email_address": insider.emailAddress ?? "", "image_url": self.imageUrl ?? ""]
            print("PENDING INSIDERS")
            self.REF_CIRCLES.document(id).collection("insiders").addDocument(data: data, completion: { (error) in
                if let error = error {
                    print("ERROR SAVING INSIDERS", error.localizedDescription)
                    completion(false, error)
                } else {
                    print("FINISH INSIDERS")
                    completion(true, error)
                }
            })
        }
    }
    

    
    func saveImageData(_ data: Data, _ completion: @escaping (_ url: String?, _ success: Bool, _ error: Error?) -> ()) {
        let imgUID = NSUUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let storageItem = Storage.storage().reference().child(imgUID)
        
        storageItem.putData(data, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Couldn't Upload Image")
            } else {
                print("Uploaded")
                storageItem.downloadURL(completion: { (url, error) in
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
    
    
    func retrieveDynamicLinkCircle(_ id: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ admin: User?, _ insider: User?) -> ()) {
        print("IDDD:: \(id)")
        DataService.instance.REF_CIRCLES.document(id).getDocument { (document, error) in
            if let error = error {
                print("ERROR", error.localizedDescription)
            } else {
                if document!.exists {
                    let data = document?.data()
                    if let admin = data!["admin"] as? String {
                        let url = data!["link"] as? String
                        UserDefaults.standard.set(url, forKey: "circleUrl")
                        let ref = DataService.instance.REF_USERS.document(admin)
                        ref.getDocument { (document, error) in
                            if let error = error {
                                completion(false, error, nil, nil)
                            } else {
                                if let document = document {
                                    if document.exists {
                                        let data = document.data()
                                        let key = document.documentID
                                        print("KEY:::: =>>>", key)
                                        let admin = User(key: key, data: data!, bank: nil, event: nil, balance: nil)
                                        DataService.instance.REF_CIRCLES.document(id).collection("insiders").getDocuments(completion: { (documents, error) in
                                            if let error = error {
                                                print(error)
                                                return
                                            }
                                            
                                            for document in (documents?.documents)! {
                                                if document.exists {
                                                    let data = document.data()
                                                    print("DATA:::: =>>>", data)
                                                    let key = document.documentID
                                                    let insider = User(key: key, data: data, bank: nil, event: nil, balance: nil)
                                                    completion(true, nil, admin, insider)
                                                }
                                            }
//
//
//                                            self.retrieveUser(id, { (success, error, user, nil) in
//                                                if !success {
//                                                    print("ERROR", error!.localizedDescription)
//                                                } else {
//                                                    print("FIRSTNAME:::: =>>>", user?.firstName)
//
//                                                }
//                                            })
                                        })
                                    }
                                } else {
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func lookForPendingUser(_ circleId: String, _ phoneNumber: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ user: User?) -> ()) {
        
        let ref = DataService.instance.REF_CIRCLES.document(circleId).collection("insiders").whereField("phone_number", isEqualTo: phoneNumber)
        
            ref.getDocuments { (documents, error) in
            if let error = error {
                print("ERROR:::", error.localizedDescription)
                completion(false, error, nil)
                return
            }
            for document in (documents?.documents)! {
                if document.exists {
                    let data = document.data()
                    let key = document.documentID
                    let user = User(key: key, data: data, bank: nil, event: nil, balance: nil)
                    completion(true, error, user)
                }
            }
        }
    }
    
    func setupCircle(circleId: String, maxAmount: Int, weeklyAmount: Int) {
        let data = ["max_amount": maxAmount, "weekly_amount": weeklyAmount, "activated": true] as [String : Any]
        DataService.instance.REF_CIRCLES.document(circleId).setData(data, merge: true)
    }
    
    
    func updateCircle(_ circleId: String, _ maxAmount: Int) {
        let data = ["max_amount": maxAmount, "activated": true] as [String : Any]
        DataService.instance.REF_CIRCLES.document(circleId).setData(data, merge: true)
    }
    
    
}




extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
