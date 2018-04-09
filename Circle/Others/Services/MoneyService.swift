//
//  MoneyService.swift
//  Circle
//
//  Created by Kerby Jean on 2/26/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import Firebase

class MoneyService {
    
    private static let _instance = MoneyService()
    
    static var instance: MoneyService {
        return _instance
    }
    
    
    func requestMoney() {
        
    }
    
    var listener: ListenerRegistration!

    func sendMoney(_ recipient_id: String, _ amount: String, _ destination: String, _ first_name: String, _ last_name: String, _ completion: @escaping (_ success: Bool, _ error: String?) -> ()) {
        let data: [String: Any] = ["amount": amount, "to": recipient_id, "destination": destination, "first_name": first_name, "last_name": last_name, "type": "send"]
        let ref = DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("charges").document()
        ref.setData(data, options: SetOptions.merge()) { (error) in
            if let error = error {
                print("ERROR SENDING TRANSACTION", error.localizedDescription)
                return
            } else {
                self.listener = ref.addSnapshotListener { document, error in
                    if let error = error {
                        print("ERROR GETTING TRANSACTION", error.localizedDescription)
                    } else {
                        if (document?.exists)! {
                            let data = document!.data()
                            if let success = data["success"] as? Bool  {
                                if success == false {
                                    let error = data["error"] as? String
                                    completion(success, error)
                                    ref.delete()
                                    self.listener.remove()
                                } else {
                                DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("events").document().setData(data)
                                    completion(true, nil)
                                    completion(success, nil)
                                    self.listener.remove()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func requestMoney(_ user: User, data: [String: Any], completion: @escaping (_ success: Bool, _ error: String?) -> ()) {
        let ref = DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("requests").document()
        ref.setData(data, options: SetOptions.merge()) { (error) in
            if let error = error {
                print("ERROR SENDING TRANSACTION", error.localizedDescription)
                completion(false, nil)
                return
            } else {
                DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("events").document().setData(data)
                completion(true, nil)
            }
        }
    }
    
    
    func retrieveBalance(_ userId: String, completion: @escaping (_ balance: Balance) -> ()) {
        DataService.instance.REF_USERS.document(userId).collection("balance").getDocuments(completion: { (documents, error) in
            if let error = error {
                print("Error getting source", error.localizedDescription)
            } else {
                for document in (documents?.documents)! {
                    let data = document.data()
                    print("DATA:::", data)
                }
            }
        })
    }
}

