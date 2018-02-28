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
    
    
    
    
    
    func sendMoney(_ amount: String, _ destination: String) {
        
        
        
        let data: [String: Any] = ["amount": amount, "destination": destination]
        
        
        DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("charges").addDocument(data: data) { (error) in
            guard let error = error else {
                print("ERROR SEND MONEY")
                return
            }
        }        
    }
}

