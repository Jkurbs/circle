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
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()

        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PaymentsCell {
            
            cell.paymentTextField.resignFirstResponder()
            
            let cardParams = STPCardParams()
            cardParams.number = cell.paymentTextField.cardNumber
            cardParams.expMonth = cell.paymentTextField.expirationMonth
            cardParams.expYear = cell.paymentTextField.expirationYear
            cardParams.cvc = cell.paymentTextField.cvc
            
            let image = cell.paymentTextField.brandImage
            
            
            let data = UIImageJPEGRepresentation(image!, 0.1)
            
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                guard let token = token, error == nil, let last4 = cardParams.last4() else {
                     activityIndicator.stopAnimating()
                    return
                }
                
                DataService.call.addPayment(token.tokenId, last4, data!, complete: { (success, error) in
                    if !success {
                        print("error:", error!.localizedDescription)
                        activityIndicator.stopAnimating()
                    } else {
                        print("success")
                        activityIndicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
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










