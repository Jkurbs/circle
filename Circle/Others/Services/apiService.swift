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
import FirebaseFirestore
import FirebaseDynamicLinks

protocol DataServiceProtocol {
    func fetchCurrentUser( complete: @escaping ( _ success: Bool, _ users: [User], _ error: Error? )->() )
}


class DataService: DataServiceProtocol {
    
    private static let _call = DataService()
    
    static var call: DataService {
        return _call
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

    
     var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }

    
   let DYNAMIC_LINK_DOMAIN = "fk4hq.app.goo.gl"
   var shortLink: URL?

    
    
    var fileUrl: String?
    
    
    
    func fetchCurrentUser( complete: @escaping ( _ success: Bool, _ user: [User], _ error: Error? )->()) {
        DispatchQueue.global().async {
            if let uid = Auth.auth().currentUser?.uid ?? UserDefaults.standard.value(forKey: "userId") as? String {
                self.REF_USERS.document(uid).getDocument { (snapshot, error) in
                    if let error = error {
                        print("ERROR:", error.localizedDescription)
                        return
                    } else {
                        guard let snap = snapshot else {
                            return
                        }
                        let key = snap.documentID
                        let data = snap.data()
                        let user = User(key: key, data: data!)
                        let firstName = user.firstName
                        UserDefaults.standard.set(firstName, forKey: "firstName")
                        complete(true, [user], nil)
                    }
                }
            }
        }
    }

    
    var users = [User]()
    var nextPayoutUsers = [User]()

    
    func fetchUsers(complete: @escaping ( _ success: Bool, _ users: [User]?, _ error: Error? )->()) {
        let circleId  = UserDefaults.standard.string(forKey: "circleId") ?? ""
        DataService.call.REF_CIRCLES.document(circleId).collection("insiders").order(by: "position", descending: false).addSnapshotListener { snapshot, error in
            self.users = []
            guard let snapshot = snapshot else {
                complete(false, nil, error)
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documents.forEach { diff in
                let data = diff.data()
                let id = diff.documentID
                let user = User(key: id, data: data)
                self.users.append(user)
                complete(true, self.users, nil)
            }
        }
    }
    
    
    func fetchPayoutUsers(complete: @escaping ( _ success: Bool, _ user: User?, _ error: Error? )->()) {
        let circleId  = UserDefaults.standard.string(forKey: "circleId") ?? ""
        DataService.call.REF_CIRCLES.document(circleId).collection("insiders").whereField("days_left", isGreaterThan: 0).limit(to: 3).getDocuments(completion: { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error!)")
                complete(false, nil, error)
                return
            }
            for snapshot in snapshot.documents {
                    if snapshot.exists {
                    let key = snapshot.documentID
                    let data = snapshot.data()
                    let user = User(key: key, data: data)
                    complete(true, user, nil)
                }
            }
        })
    }
    

    
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
    
    
    
    func fetchCircle(_ circleId: String?, _ completion: @escaping (_ success: Bool, _ error: Error?, _ circle: Circle?) -> ()) {
        guard let circleId = circleId else {
            return
          }
        listener = DataService.call.REF_CIRCLES.document(circleId).addSnapshotListener {( document, error) in
                if let document = document {
                    if document.exists {
                        let data = document.data()
                        let key = document.documentID
                        let circle = Circle(key: key, data: data!)
                        completion(true, nil, circle)
                }
            }
        }
    }
    
    deinit {
        listener = nil
    }
    
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
    
    
    
    
    
    
    
    
    
    private var insider: String?

    func getInsiders(_ circleId: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ insiders: User?) -> ()) {
       let ref = DataService.call.REF_CIRCLES.document(circleId).collection("insiders")
            ref.order(by: "position", descending: false).getDocuments { (documents, error) in
            if let error = error {
                completion(false, error, nil)
                return
            }
            for document in (documents?.documents)! {
                if document.exists {
                    let data = document.data()
                    let key = document.documentID
                    let insiders = User(key: key, data: data)
                    completion(true, nil, insiders)
                }
            }
        }
    }

    
    func getPendingInsiders(_ circleId: String, _ completion: @escaping (_ success: Bool, _ error: Error?, _ pendingnUsers: User?) -> ()) {
        
        DataService.call.REF_CIRCLES.document(circleId).collection("insiders").getDocuments { (documents, error) in
            if let error = error {
                print("ERROR:::", error.localizedDescription)
                completion(false, error, nil)
                return
            }
            for document in (documents?.documents)! {
                let data = document.data()
                let key = document.documentID
                let pendingInsiders = User(key: key, data: data)
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
        let circleId = UserDefaults.standard.string(forKey: "circleId") ?? ""
        ref.updateData(["email_address": email, "circle": circleId]) { (error) in
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
    
 
    var childRef: String?
    var imageUrl: String?
    
    
    
    
    func addNewInsider(_ userId: String) {
        self.REF_USERS.document(userId).getDocument { (document, error) in
            if let error = error {
                print("Error::", error.localizedDescription)
            }
            let key = document!.documentID
            let data = document!.data()
            if let circleId = UserDefaults.standard.string(forKey: "circleId") {
                let ref = self.REF_CIRCLES.document(circleId).collection("insiders")
                ref.getDocuments(completion: { (snapshot, error) in
                    if let error = error {
                        print("Error::", error.localizedDescription)
                        return
                    } else {
                        guard let count = snapshot?.count else {
                            return
                        }
                        let position = count + 1
                        let countData = ["position": position]
                        ref.document(key).setData(countData)
                        ref.document(key).setData(data!, merge: true)
                    }
                })
            }
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
        DataService.call.REF_CIRCLES.document(id).getDocument { (document, error) in
            if let error = error {
                print("ERROR", error.localizedDescription)
            } else {
                if document!.exists {
                    let data = document?.data()
                    if let admin = data!["admin"] as? String {
                        let url = data!["link"] as? String
                        UserDefaults.standard.set(url, forKey: "circleUrl")
                        let ref = DataService.call.REF_USERS.document(admin)
                        ref.getDocument { (document, error) in
                            if let error = error {
                                completion(false, error, nil, nil)
                            } else {
                                if let document = document {
                                    if document.exists {
                                        let data = document.data()
                                        let key = document.documentID
                                        print("KEY:::: =>>>", key)
                                        let admin = User(key: key, data: data!)
                                        DataService.call.REF_CIRCLES.document(id).collection("insiders").getDocuments(completion: { (documents, error) in
                                            if let error = error {
                                                print(error)
                                                return
                                            }
                                            
                                            for document in (documents?.documents)! {
                                                if document.exists {
                                                    let data = document.data()
                                                    print("DATA:::: =>>>", data)
                                                    let key = document.documentID
                                                    let insider = User(key: key, data: data)
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
        
        let ref = DataService.call.REF_CIRCLES.document(circleId).collection("insiders").whereField("phone_number", isEqualTo: phoneNumber)
        
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
                    let user = User(key: key, data: data)
                    completion(true, error, user)
                }
            }
        }
    }
    
    func setupCircle(circleId: String, maxAmount: Int, weeklyAmount: Int) {
        let data = ["max_amount": maxAmount, "weekly_amount": weeklyAmount, "activated": true] as [String : Any]
        DataService.call.REF_CIRCLES.document(circleId).setData(data, merge: true)
    }
    
    
    func updateCircle(_ circleId: String, _ maxAmount: Int) {
        let data = ["max_amount": maxAmount, "activated": true] as [String : Any]
        DataService.call.REF_CIRCLES.document(circleId).setData(data, merge: true)
    }
    
    
}




extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
