//
//  EditAccountVC.swift
//  Circle
//
//  Created by Kerby Jean on 11/6/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import IGListKit


final class EditAccountVC: UIViewController {
    
    fileprivate let viewModel = AccountViewModel()
    
    var tableView: UITableView!
    var saveBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.backgroundColor = .white
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        
        self.title = "Edit Account"
        
        saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveBarButton
    
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight), style: .plain)
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .backgroundColor
        
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        
        tableView.register(ProfileImageCell.self, forCellReuseIdentifier: ProfileImageCell.identifier)
        tableView.register(DisplayNameCell.self, forCellReuseIdentifier: DisplayNameCell.identifier)
        tableView.register(UsernameCell.self, forCellReuseIdentifier: UsernameCell.identifier)
        tableView.register(EmailCell.self, forCellReuseIdentifier: EmailCell.identifier)
        tableView.register(PhoneCell.self, forCellReuseIdentifier: PhoneCell.identifier)
        
        self.view.addSubview(tableView)
    }
    
    
    // MARK: Actions
    
   @objc func save() {
   
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    activityIndicator.activityIndicatorViewStyle = .gray
    let barButton = UIBarButtonItem(customView: activityIndicator)
    self.navigationItem.setRightBarButton(barButton, animated: true)
    activityIndicator.startAnimating()
    
    if let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileImageCell, let displayNameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? DisplayNameCell, let usernameCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? UsernameCell, let emailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EmailCell, let phoneCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? PhoneCell  {
        
        guard let image = imageCell.profileImageView.image, let username = usernameCell.textField.text, let displayname = displayNameCell.textField.text, let email = emailCell.textField.text, let phone = phoneCell.textField.text  else {
            return
        }
        
         let fullNameArr = displayname.components(separatedBy: " ")

            DataService.call.updateUserData(username, fullNameArr, email, phone, image) { (success, error) in
                if !success {
                    ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "An error has occured", .error)
                    self.navigationItem.rightBarButtonItem = self.saveBarButton
                    activityIndicator.stopAnimating()
                } else {
                    ErrorHandler.show.showMessage(self, "Profile updated", .success)
                    self.navigationItem.rightBarButtonItem = self.saveBarButton
                }
            }
        }
    }

    // MARK: Fetch Data
    
    func fetchData() {
        DataService.call.fetchCurrentUser { (success, error, user) in
            if !success {
                ErrorHandler.show.showMessage(self, "An error has occured", .error)
                print("error:", error!.localizedDescription)
            } else {
                self.viewModel.user = user
                self.tableView.reloadData()
            }
        }
    }
}
