//
//  SettingsVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth


class SettingsVC: UITableViewController {
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "EditAccountVC") as! EditAccountVC
//            vc.user = self.user
//            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if indexPath.row == 1 {
            //Defaults.remove(.key_uid)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                DispatchQueue.main.async {
                    let board = UIStoryboard(name: "Log", bundle: nil)
                    let controller = board.instantiateViewController(withIdentifier: "WelcomeVC")
                    self.present(controller, animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
                print("SIGNOUT ERROR:\(signOutError)")
            }
        }
    }
}
