//
//  DataServ.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SwiftyUserDefaults

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var REF_CIRCLES: CollectionReference {
        return Firestore.firestore().collection("circles")
    }
    
    var REF_USERS: CollectionReference {
        return Firestore.firestore().collection("users")
    }
    
    var REF_USER_CURRENT: DocumentReference{
        let uid = Defaults[.key_uid]
        return Firestore.firestore().document(uid!)
    }
    
    var REF_STORAGE: StorageReference {
        return Storage.storage().reference()
    }

    
    func createFirebaseDBUser(_ uid: String, userData: Dictionary<String, String>) {
         DataService.instance.REF_USERS.document(uid).setData(userData)
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
            let userRef = DataService.instance.REF_USERS.document(user.uid)
            userRef.updateData(userInfo)
        }
    }
    
    
    func createCircle(_ data: Dictionary<String, String>, _ completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let ref = DataService.instance.REF_CIRCLES
        let childRef = ref.document().documentID

        ref.document(childRef).setData(data, completion: { (error) in
            if let error = error {
                completion(false, error)
            } else {
                DataService.instance.REF_CIRCLES.document(childRef).collection("insiders").addDocument(data: [(Auth.auth().currentUser?.uid)!: true])
                completion(true, nil)
            }
        })
    }

    
    
    func retrieveCircle(_ completion: @escaping (_ success: Bool, _ error: Error?, _ user: Circle?) -> ()) {
        let ref = DataService.instance.REF_CIRCLES
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, error, nil)
            } else {
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let key = document.documentID
                    let circle = Circle(key: key, data: data)
                    completion(true, nil, circle)
                }
            }
        }
    }
    
    func retrieveUsers(_ completion: @escaping (_ success: Bool, _ error: Error?, _ user: User?) -> ()) {
        let ref = DataService.instance.REF_USERS
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, error, nil)
            } else {
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let key = document.documentID
                    let user = User(key: key, data: data)
                    completion(true, nil, user)
                }
            }
        }
    }
}



