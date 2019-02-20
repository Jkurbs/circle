//
//  AddCardVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/16/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import Stripe
import CreditCardRow


class AddCardVC: UIViewController {
    
    var tableView: UITableView!
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: SetupView
    
    func setupView() {
        self.title = "Add Cards"
        view.backgroundColor = .white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(add))
        addButton.isEnabled = false
        navigationItem.rightBarButtonItem = addButton
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight))
        tableView.tableFooterView = UIView()
        
        tableView.register(PaymentsCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    // MARK: Action
    
    @objc func add() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        let cardParams = STPCardParams()
        if let cell =  tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PaymentsCell {
            if let cardNumber = cell.numberField.text, let expirationDates = cell.expirationField.text?.components(separatedBy: "/"), let expMonth = UInt(expirationDates.first!), let expYear = UInt(expirationDates.last!), let cvv = cell.cvvField.text, let cardType = cell.type, let prefix = cell.prefix {
                cardParams.number = cardNumber
                cardParams.expMonth = expMonth
                cardParams.expYear = expYear
                cardParams.cvc = cvv
                
//                STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
//                    guard let token = token, error == nil else {
//                        self.navigationItem.rightBarButtonItem = self.addButton
//                        ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "An error has occured", .error)
//                        return
//                    }
//                    DataService.call.addPayment(token.tokenId, cardType, "\(expMonth)/\(expYear)", cardParams.cvc!, prefix,  complete: { (success, error) in
//                        self.navigationItem.rightBarButtonItem = self.addButton
//                        ErrorHandler.show.showMessage(self, error?.localizedDescription ?? "Card saved", .success)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    })
//                }
            }
        }
    }
}

//MARK: Tableview Delegate/Datasource

extension AddCardVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentsCell
        cell.cardImageView.image = UIImage(named: "Generic")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        
        let label = UICreator.create.label("This card is saved for future payments.", 14, .gray, .left, .regular, headerView)
        label.frame = CGRect(x: 15, y: 0, width: tableView.frame.size.width, height: 60)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
}

