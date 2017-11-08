//
//  SettingsVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults

class SettingsVC: UITableViewController {

    
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditAccountVC") as! EditAccountVC
            vc.user = self.user
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if indexPath.row == 1 {
            Defaults.remove(.key_uid)
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
