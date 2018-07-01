//
//  SettingsVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth


class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var settings = ["Edit account", "Log Out"]
    
    let textCellIdentifier = "MyCell"
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
         self.title = "Settings"

        view.backgroundColor = .white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cell.textLabel?.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        cell.textLabel?.text = settings[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = EditAccountVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if indexPath.row == 1 {
            UserDefaults.standard.removeObject(forKey: "circleId")
            UserDefaults.standard.removeObject(forKey: "userId")
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
