//
//  DataServ.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-04.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import SwiftyUserDefaults

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var REF_USERS: CollectionReference {
        return Firestore.firestore().collection("users")
    }
    
    var REF_USER_CURRENT: DocumentReference{
        let uid = Defaults[.key_uid]
        return Firestore.firestore().document(uid!)
    }

    
    func createFirebaseDBUser(_ uid: String, userData: Dictionary<String, String>) {
         DataService.instance.REF_USERS.document(uid).setData(userData)
    }
}



