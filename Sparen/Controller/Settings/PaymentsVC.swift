//
//  PaymentsVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class PaymentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    var tableView: UITableView!

    let textCellIdentifier = "PaymentCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add card"
        view.backgroundColor = .white

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)

    }
}

extension PaymentsVC {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = cell.tintColor
        cell.textLabel?.text = "Add new Debit Card"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddPaymentVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}









