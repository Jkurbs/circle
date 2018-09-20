//
//  AddPaymentVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import Stripe
import FirebaseAuth

class AddPaymentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView!
    
    let textCellIdentifier = "PaymentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add card"
        view.backgroundColor = .white
        
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewDebit))
        navigationItem.rightBarButtonItem = addButton
        
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.tableFooterView = UIView()
        tableView.register(PaymentsCell.self, forCellReuseIdentifier: textCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        
    }
    
    @objc func addNewDebit() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PaymentsCell {
            let cardParams = STPCardParams()
            cardParams.number = cell.paymentTextField.cardNumber
            cardParams.expMonth = cell.paymentTextField.expirationMonth
            cardParams.expYear = cell.paymentTextField.expirationYear
            cardParams.cvc = cell.paymentTextField.cvc
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                guard let token = token, error == nil else {
                    return
                }
                DataService.call.REF_USERS.document((Auth.auth().currentUser?.uid)!).collection("payments").addDocument(data: ["token": token.tokenId], completion: { (error) in
                    if let err = error {
                        print("error:", err.localizedDescription)
                        self.showMessage("An error occured", type: .error)
                    } else {
                        self.showMessage("You successfully added a new card", type: .error)
                    }
                })
            }
        }
    }
}

extension AddPaymentVC {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! PaymentsCell
        cell.detailTextLabel?.text = "This card will be stored securely for future transactions."
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PaymentsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}










