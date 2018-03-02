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
    
    func sendMoney(_ amount: String, _ destination: String, _ completion: @escaping (_ status: String) -> ()) {
        let data: [String: Any] = ["amount": amount, "destination": destination]
        let ref = DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("charges").document()
        ref.setData(data, options: SetOptions.merge()) { (error) in
            if let error = error {
                print("ERROR SENDING TRANSACTION", error.localizedDescription)
                return
            } else {
                print("SEND")
                ref.addSnapshotListener { (document, error) in
                    if let error = error {
                        print("ERROR GETTING TRANSACTION", error.localizedDescription)
                    } else {
                        if (document?.exists)! {
                            let data = document?.data()
                            if let data = data {
                                if let status = data["status"] as? String {
                                    completion(status)
                                }
                            }
                        } else {
                            
                        }
                    }
                }
            }
        }
    }
}

