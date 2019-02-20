//
//  PositionVC.swift
//  Sparen
//
//  Created by Kerby Jean on 1/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PositionVC: UIViewController {
    
    var tableView: UITableView!
    
    var users = [User]()
    var positions = [String: Int]()
    
    var doneButton: UIBarButtonItem!
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = .gray
        view.hidesWhenStopped = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initFetch()
    }
    
    
    // MARK: Setup UI
    
    func setupUI() {
        
        view.backgroundColor = .white
        self.title = "Positions"
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        
        indicator.startAnimating()
        view.addSubview(indicator)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(sendRequest))
        doneButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(PositionCell.self, forCellReuseIdentifier: PositionCell.identifier)
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        let label = UICreator.create.label("Drag yourself at the position you would\nlike to request", 15, .darkText, .center, .regular, headerView)
        label.frame = headerView.bounds
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
    }
    
    
    // MARK: Actions
    
    @objc func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func sendRequest() {
        
        print("POSITION::", self.positions)

        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        if currentReachabilityStatus == .notReachable {
            self.navigationItem.rightBarButtonItem = self.doneButton
            ErrorHandler.show.showMessage(self, "No internet connection", .error)
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let first = positions["position"] as? Int, let second = positions["forPosition"] as? Int else {
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        
        DataService.call.positionRequest(users: self.users, first, second) { (success, error) in
            if !success {
                self.navigationItem.rightBarButtonItem = self.doneButton
                self.tableView.moveRow(at: IndexPath(row: second, section: 0), to: IndexPath(row: first, section: 0))
                self.positions.removeAll()
                ErrorHandler.show.showMessage(self, "Position already requested", .warning)
            } else {
                ErrorHandler.show.showMessage(self, "Position successfully requested", .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: Fetch
    
    func initFetch() {
        
        self.users.removeAll()
        DataService.call.fetchMembers { (success, error, user) in
            if !success {
                self.indicator.stopAnimating()
                ErrorHandler.show.showMessage(self, error!.localizedDescription, .error)
            } else {
                self.users.append(user)
                self.users.sort(by: {$0.position! < $1.position!})
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
    
    deinit {
        DataService.call.RefCircles.removeObserver(withHandle: DataService.call.circleMembersHandle)
    }
}

// MARK: TableView Delegate/Datasource

extension PositionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PositionCell", for: indexPath) as? PositionCell {
            let user = self.users[indexPath.row]
            cell.configure(user)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        
        let label = UICreator.create.label("Payments will proceed in that order. Top to bottom.", 12.5, .lightGray, .center, .regular, headerView)
        label.frame = headerView.frame
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        self.positions.removeAll()
        let sourceRow = sourceIndexPath.row
        let destinationRow = destinationIndexPath.row
        
        let user = self.users[sourceRow]
        let destinationUser = self.users[destinationRow]

        self.users.remove(at: sourceRow)
        users.insert(user, at: destinationRow)
        
        self.users.remove(at: destinationRow)
        self.users.insert(destinationUser, at: sourceRow)

        if sourceRow != destinationRow {
            self.positions = ["position": sourceRow, "forPosition": destinationRow]
            self.doneButton.isEnabled = true
        }
    }
}
