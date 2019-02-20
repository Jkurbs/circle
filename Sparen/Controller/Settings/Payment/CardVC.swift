//
//  CardVC.swift
//  Sparen
//
//  Created by Kerby Jean on 2/6/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import FirebaseDatabase

class CardVC: UIViewController {
    
    var tableView: UITableView!
    
    let textCellIdentifier = "PaymentCell"
    let currentPaymentId = "SettingPaymentCell"
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: SetupView
    
    func setupView() {
        self.title = "Card"
        view.backgroundColor = .white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight))
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        tableView.register(SettingPaymentCell.self, forCellReuseIdentifier: currentPaymentId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "descCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buttonCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
    }
}

//MARK: Tableview Delegate/Datasource

extension CardVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cards.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: currentPaymentId, for: indexPath) as! SettingPaymentCell
            cell.selectionStyle = .none
            let card = self.cards[indexPath.row]
            cell.configure(card)
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descCell", for: indexPath) as UITableViewCell
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                cell.textLabel?.textColor = UIColor(white: 0.6, alpha: 1.0)
                cell.textLabel?.text = "This card is saved for future purchases."
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as UITableViewCell
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                cell.textLabel?.textColor = UIColor.red
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "Remove"
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70.0
        }
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            removeAlert()
        }
    }
    
    @objc func addCard() {
        navigationController?.pushViewController(AddCardVC(), animated: true)
    }
    
    func removeAlert() {
        let alert = UIAlertController(title: "Remove Card", message: "Are you sure you want to remove this card? You'll need to re-enter your card information for future payments", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let remove = UIAlertAction(title: "Remove", style: .destructive) { (action) in
    
    
        DataService.call.RefCards.child(Auth.auth().currentUser!.uid).child(self.cards[0].key!).removeValue(completionBlock: { (error, ref) in
                ErrorHandler.show.showMessage(self, "Card removed", .success)
                self.navigationController?.popViewController(animated: true)
            })
        }
        alert.addAction(cancel)
        alert.addAction(remove)
        self.present(alert, animated: true, completion: nil)
    }
}










