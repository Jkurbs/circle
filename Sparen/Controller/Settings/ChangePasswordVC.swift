//
//  ChangePasswordVC.swift
//  Sparen
//
//  Created by Kerby Jean on 8/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordVC: UITableViewController {

    var data = ["Current password", "New password", "Repeat password"]
    
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        self.title = "Change Password"
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        tableView.register(CurrentPasswordCell.self, forCellReuseIdentifier: "current")
        tableView.register(NewPasswordCell.self, forCellReuseIdentifier: "New")
        tableView.register(RepeatNewPasswordCell.self, forCellReuseIdentifier: "repeat")
        tableView.tableFooterView = UIView()
    }
    
    // MARK: Actions
    
    @objc func save() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        guard let current = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrentPasswordCell, let new = tableView.cellForRow(at:  IndexPath(row: 1, section: 0)) as? NewPasswordCell, let repeatPass = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? RepeatNewPasswordCell  else {return}
        guard let currentPassword = current.textField.text, let newPassword = new.textField.text, let repeatNewPassword = repeatPass.textField.text else {return}
        guard newPassword == repeatNewPassword else {
            ErrorHandler.show.showMessage(self, "Passwords do not match", .error)
            activityIndicator.stopAnimating()
            return
        }
        
        AuthService.instance.updatePassword(currentPassword, newPassword) { (success, error) in

            if !success {
                ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "Enable to re-authenticate", .error)
                activityIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem = self.saveButton
            } else {
                activityIndicator.stopAnimating()
                ErrorHandler.show.showMessage(self, "Password updated", .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: Tableview Delegate/Datasource

extension ChangePasswordVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "current", for: indexPath) as! CurrentPasswordCell
            return cell
        } else if indexPath.row == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "New", for: indexPath) as! NewPasswordCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repeat", for: indexPath) as! RepeatNewPasswordCell
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
