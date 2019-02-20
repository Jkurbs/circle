//
//  PaymentsVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import FirebaseDatabase

class PaymentsVC: UIViewController {

    var tableView: UITableView!

    let textCellIdentifier = "PaymentCell"
    let currentPaymentId = "SettingPaymentCell"
    var row = 1
    var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCards()

    }
    
    
    //MARK: SetupView
    
    func setupView() {
        self.title = "Add card"
        view.backgroundColor = .white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight))
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        tableView.register(SettingPaymentCell.self, forCellReuseIdentifier: currentPaymentId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buttonCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        
        if currentReachabilityStatus == .notReachable {self.present(ErrorHandler.show.internetError(), animated: true, completion: nil)}
    }
    
    
    
    //MARK: Fetch
    
    func fetchCards() {
        
        self.cards.removeAll()
        self.tableView.reloadData()
        DataService.call.RefCards.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                guard let value = rest.value as? [String : Any] else {
                    return
                }
                let key = rest.key
                let card = Card(key, value)
                self.cards.append(card)
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: Tableview Delegate/Datasource

extension PaymentsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cards.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: currentPaymentId, for: indexPath) as! SettingPaymentCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            let card = self.cards[indexPath.row]
            cell.configure(card)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as UITableViewCell
            cell.selectionStyle = .none 
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            cell.textLabel?.textColor = UIColor(white: 0.6, alpha: 1.0)
            cell.textLabel?.text = "Add Debit Card"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80.0
        }
        return 45.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            addCard()
        } else {
            let card = self.cards[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = CardVC()
            vc.cards.append(card)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 15, y: 0, width: tableView.frame.width, height: 30.0))
//        let label = UILabel(frame: headerView.frame)
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = UIColor.darkText
//        label.text = "Payment Method"
//        headerView.addSubview(label)
//        if section == 0 {
//            headerView.backgroundColor = .white
//            return headerView
//        }
//        return UIView()
//    }
//
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
    

    @objc func addCard() {
        navigationController?.pushViewController(AddCardVC(), animated: true)
    }
}










