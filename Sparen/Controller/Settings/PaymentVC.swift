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

class PaymentsVC: UIViewController, ListAdapterDataSource {

    var cards = [Card]()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.textAlignment = .center
        label.text = "Tap the + button to add a bank"
        view.addSubview(label)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add card"
        view.backgroundColor = .white
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard))
        navigationItem.rightBarButtonItem = add
        
        

        collectionView.backgroundColor = .white
        
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        fetchCards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        label.frame = view.frame

    }


    func fetchCards() {
        DataService.call.RefCards.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? [String : Any] else {
                return
            }
            let key = snapshot.key
            let card = Card(key, value)
            self.cards.append(card)
            self.adapter.performUpdates(animated: true)
        }
    }
    
    @objc func addCard() {
        navigationController?.pushViewController(AddPaymentVC(), animated: true)
    }

}

extension PaymentsVC {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return cards as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CardSection()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return label
    }
}


//class PaymentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//
//    var tableView: UITableView!
//
//    let textCellIdentifier = "PaymentCell"
//    let currentPaymentId = "SettingPaymentCell"
//    var row = 1
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "Add card"
//        view.backgroundColor = .white
//
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard))
//
//        navigationItem.rightBarButtonItem = add
//
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//        let displayWidth: CGFloat = self.view.frame.width
//        let displayHeight: CGFloat = self.view.frame.height
//
//        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
//        tableView.tableFooterView = UIView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
//        tableView.register(SettingPaymentCell.self, forCellReuseIdentifier: currentPaymentId)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.backgroundColor = .white
//        self.view.addSubview(tableView)
//
//        fetchCards()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//    }
//}
//
//extension PaymentsVC {
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return row
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: currentPaymentId, for: indexPath) as! SettingPaymentCell
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let vc = AddPaymentVC()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func fetchCards() {
//        DataService.call.RefCards.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
//            guard let value = snapshot.value as? [String : Any] else {
//                return
//            }
//            let key = snapshot.key
//            let card = Card(key, value)
//            if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SettingPaymentCell {
//                cell.configure(card)
//            }
//        }
//    }
//
//    @objc func addCard() {
//        navigationController?.pushViewController(AddPaymentVC(), animated: true)
//    }
//}
//
//
//
//
//
//
//
//
