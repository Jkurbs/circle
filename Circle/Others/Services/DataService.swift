//
//  DataService.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
import SwiftyUserDefaults

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
            
            if !metadata!.downloadURLs![0].absoluteString.isEmpty {
                self.fileUrl = metadata!.downloadURLs![0].absoluteString
            }
            
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
    
    
    func retrieveUser(_ completion: @escaping (_ success: Bool, _ error: Error?, _ user: User?) -> ()) {
        print("RETRIEVE USERS")
        //let ref = DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid)
//        ref.getDocument { (document, error) in
//            if let error = error {
//                completion(false, error, nil)
//            } else {
//                if let document = document {
//                    let data = document.data()
//                    let key = document.documentID
//                    let user = User(key: key, data: data)
//                    completion(true, nil, user)
//                    print("Document data: \(document.data())")
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
    }
    
    private var insider: String?
    
    func retrieveCircle(_ id: String?, completion: @escaping (_ success: Bool, _ error: Error?, _ circle: Circle?, _ insiders: User?) -> ()) {
//        if id != nil {
//            let ref = DataService.instance.REF_CIRCLES.document(id!)
//            ref.getDocument { (document, error) in
//                if let document = document {
//                    let data = document.data()
//                    let key = document.documentID
//                    let circle = Circle(key: key, data: data)
//                    if let insiders = circle.insiders {
//                        for insider in insiders {
//                            self.insider = insider
//                            let ref = DataService.instance.REF_USERS
//                            ref.document(insider).getDocument { (document, error) in
//                                if let document = document {
//                                    print("RETRIVED USRES: \(document.data())")
//                                    let data = document.data()
//                                    let key = document.documentID
//                                    let user = User(key: key, data: data)
//                                    completion(true, nil, circle, user)
//
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    print("Document does not exist")
//                    completion(false, error, nil, nil)
//                }
//            }
//        }
    }
    
    func retrieveInsiders(_ insider: String?, completion: @escaping (_ success: Bool, _ error: Error?, _ users: User?) -> ()) {
//        let ref = DataService.instance.REF_USERS
//        ref.document(insider!).getDocument { (document, error) in
//            if let document = document {
//                let data = document.data()
//                let key = document.documentID
//                let user = User(key: key, data: data)
//                completion(true, nil, user)
//            }
//        }
    }
    
    //MARK: Sign up Data Flow
    
    func saveNamePassword(firstName: String, lastName: String, password: String, dobDay: String, dobMonth: String, dobYear: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        print("SAVING")
         let data: [String: Any] = ["first_name": firstName, "last_name": lastName,"dob_day": dobDay, "dob_month": dobMonth, "dob_year": dobYear]
        
        REF_USER_CURRENT.updateData(data, completion: { (error) in
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
                
                print("SAVING....")

            }
        })
    }
    
    
    func saveBankInformation(email: String, password: String, tokenId: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
        REF_USER_CURRENT.updateData(["email_address": email]) { (error) in
            if let error = error {
                completion(false, error)
            } else {
                self.REF_USER_CURRENT.collection("sources").addDocument(data: ["token": tokenId])
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
    
    
    
func saveDeviceInfo(phoneNumber: String, ipAddress: String) {
    let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
    let data: [String: Any] = ["ip_address": ipAddress, "device_token": deviceToken, "phone_number": phoneNumber]

    REF_USERS.document(Auth.auth().currentUser!.uid).setData(data, options: SetOptions.merge(), completion: { (error) in
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
    
   // data: Dictionary<String, Any>
    
    //https://xyz.app.goo.gl/?link=http://example.com/my-payload-here&isi=12345&ibi=com.example.MyApp
    
    func createCircle(id: String, _ link: String, _ insiders: [Contact], _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
            self.REF_CIRCLES.document(id).setData(["admin": Auth.auth().currentUser!.uid, "activated": false, "link": link], options: SetOptions.merge()) { (error) in
                if let error = error {
                    print("ERROR:", error.localizedDescription)
                    completion(false, error)
                } else {
                    self.REF_USERS.document(Auth.auth().currentUser!.uid).setData(["circle": id], options: SetOptions.merge())
                    for insider in insiders {
                        //let image = UIImage(data: insider.imageData!)
                        let data: [String: Any] = ["phone_number": insider.phoneNumber ?? "", "first_name": insider.givenName ?? "", "last_name": insider.familyName ?? "", "email_address": insider.emailAddress ?? "", "image_data": insider.imageData ?? ""]
                        self.REF_CIRCLES.document(id).collection("pendingInsiders").addDocument(data: data, completion: { (error) in
                            if let error = error {
                                print("ERROR SAVING INSIDERS", error.localizedDescription)
                                completion(false, error)
                            } else {
                            self.REF_USERS.document(Auth.auth().currentUser!.uid).collection("pendingInsiders").addDocument(data: data)
                                completion(true, error)
                        }
                    })
                }
            }
        }
    }
    

    
    func createDynamicLink(link: String?, _ completion: @escaping (_ success: Bool, _ error: Error?, _ link: String?) -> ()) {
        // general link params
        guard let linkString = link else {
            completion(false, nil, nil)
            return
        }

        guard let link = URL(string: linkString) else { fatalError()  }
        let components = DynamicLinkComponents(link: link, domain: self.DYNAMIC_LINK_DOMAIN)
        
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
            print("URL:", self.shortLink?.absoluteString ?? "")
            completion(true, nil, shortURL?.absoluteString)
        }
    }
    
    
    func retrieveDynamicLinkCircle(_ link: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ user: User?) -> ()) {
        print("RETRIVE")
        DataService.instance.REF_CIRCLES.whereField("link", isGreaterThanOrEqualTo: link).getDocuments { (documents, error) in
            if let error = error {
                print("ERROR:::", error.localizedDescription)
                completion(false, error, nil)
                return
            }

            for document in (documents?.documents)! {
                let data = document.data()
                if let admin = data["admin"] as? String {
                    
                    let ref = DataService.instance.REF_USERS.document(admin)
                            ref.getDocument { (document, error) in
                                if let error = error {
                                    completion(false, error, nil)
                                } else {
                                    if let document = document {
                                        let data = document.data()
                                        let key = document.documentID
                                        let user = User(key: key, data: data)
                                        completion(true, error, user)
                                 } else {
                                        
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func retrievePossibleInsider( _ completion: @escaping (_ success: Bool, _ error: Error?, _ user: User?) -> ()) {
        DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("pendingInsiders").getDocuments { (documents, error) in
            if let error = error {
                print("ERROR:::", error.localizedDescription)
                completion(false, error, nil)
                return
            }
            
            for document in (documents?.documents)! {
                let data = document.data()
                let key = document.documentID
                let user = User(key: key, data: data)
                completion(true, error, user)
            }
        }
    }
}



