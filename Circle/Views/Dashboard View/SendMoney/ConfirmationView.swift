//
//  ConfirmationView.swift
//  Circle
//
//  Created by Kerby Jean on 3/18/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit

class ConfirmationView: UIView, UITableViewDelegate, UITableViewDataSource {

    struct Data {
        var image: UIImage?
        var title: String?
        var info: String!
    }

    var dataArray = [Data]()

    var tableView: UITableView!
    var parentView: UserDashboardView!
    
    @IBOutlet weak var last4Label: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    var amount: String?
    var user: User?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.textFieldBackgroundColor
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 150))
        tableView.backgroundColor = UIColor.textFieldBackgroundColor
        tableView.register(ConfirmationCell.self, forCellReuseIdentifier: "ConfirmationCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
    }
    
    @IBAction func actions(_ sender: OptionButton) {
        switch sender.tag {
        case 0:
            parentView.hideShow(hideView: self, showView: parentView.transactionView)
        case 1:
            parentView.hideShow(hideView: self, showView: parentView.processingView)
            parentView.processingView.parentView = parentView
            send()
        default:
            print("default")
        }
    }
    
    func send() {
        parentView.processingView.send(user: user!, amount: amount!)
    }
    
    func configure(_ user: User) {
        self.user = user
        self.dataArray = [Data(image: #imageLiteral(resourceName: "Museum-20"), title: nil, info: user.bank?.last4 ?? ""), Data(image: nil, title: "Amount", info: amount), Data(image: nil, title: "Destination", info: "\(user.firstName ?? "") \(user.lastName ?? "")")]
        self.tableView.reloadData()
    }
}

extension ConfirmationView {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationCell") as! ConfirmationCell
        let data = dataArray[indexPath.row]
        cell.titleLabel.text = data.title
        cell.iconImageView.image = data.image
        cell.descriptionLabel.text = data.info
        return cell
    }
}

