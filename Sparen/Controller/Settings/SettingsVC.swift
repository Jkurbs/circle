//
//  SettingsVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseMessaging


class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var settings = ["Edit account", "Password", "Push notification", "Payments", "Terms", "Log Out"]
    
    let textCellIdentifier = "MyCell"
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
         self.title = "Options"
        
         view.backgroundColor = .white
        
         let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
         let displayWidth: CGFloat = self.view.frame.width
         let displayHeight: CGFloat = self.view.frame.height
        
         tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
         tableView.register(PushNotificationCell.self, forCellReuseIdentifier: "push")
         tableView.dataSource = self
         tableView.delegate = self
         tableView.separatorStyle = .none
         tableView.backgroundColor = .white
         self.view.addSubview(tableView)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationController?.navigationBar.backgroundColor  = .white


    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
       
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        cell.textLabel?.text = settings[indexPath.row]
        
        if indexPath.row != 5 {
             cell.accessoryType = .disclosureIndicator
        }
        if indexPath.row == 2 {
            let pushSwitch = UISwitch()
            pushSwitch.isOn = UIApplication.shared.isRegisteredForRemoteNotifications
            pushSwitch.addTarget(self, action: #selector(notificationChanged), for: .valueChanged)
            cell.accessoryView = pushSwitch
            return cell
        } else {
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = EditAccountVC()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ChangePasswordVC()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = WebVC()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = PaymentsVC()
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            logoutAlert()
        default:
            print("something")
        }
    }
    

    @objc func notificationChanged(_ sender: UISwitch) {
        
        guard let circleId = UserDefaults.standard.string(forKey: "circleId"), let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") else {return}
        DataService.call.saveToken(sender.isOn, deviceToken, circleId) { (success, error) in
            if !success {
                print("error", error!.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func logoutAlert() {
        let alert = UIAlertController(title: "Log Out", message: nil, preferredStyle: .alert)
        let logOut = UIAlertAction(title: "Log Out", style: .default) { (action) in
            UserDefaults.standard.removeObject(forKey: "circleId")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.removeObject(forKey: "link")
            UserDefaults.standard.synchronize()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                DispatchQueue.main.async {
                    let vc = LoginVC()
                    let navigation = UINavigationController(rootViewController: vc)
                    self.present(navigation, animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
                print("SIGNOUT ERROR:\(signOutError)")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logOut)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
