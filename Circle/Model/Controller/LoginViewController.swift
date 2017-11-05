//
//  LoginViewController.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-05.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SwiftyUserDefaults


class LoginViewController {
    
    func signIn(_ email: String, _ password: String, _ completionBlock: @escaping ( _ success: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if  err != nil {
                completionBlock(false, err)
            } else {
                completionBlock(true, err)
                Defaults[.key_uid] = user?.uid
                Defaults[.key_uid] = user?.displayName
            }
        }
    }
    
    
    func retrieveUserInfo(_ userUID: String?, completionBlock: @escaping (_ success: Bool, _ error: Error?, _ user: User) -> ()) {
        let ref = DataService.instance.REF_USERS
        ref.document(userUID!).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("ERROR RETRIEVING USER INFO")
            }
            
            print(snapshot)

        }
        
        
        
//        ref.child(userUID!).observe(.value) { (snapshot: DataSnapshot) in
//            if  let postDict = snapshot.value as? Dictionary<String, AnyObject> {
//                let key = snapshot.key
//                let user = User(key: key, data: postDict)
//                completionBlock(true, nil, user)
//            }
//        }
    }
}


