//
//  CurrentUserView.swift
//  Circle
//
//  Created by Kerby Jean on 3/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import UIKit
import Firebase
import IGListKit

class CurrentUserView: UIView, ListAdapterDataSource, ListSingleSectionControllerDelegate {
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var nextPayoutLabel: UILabel!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 4)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var controller: CircleVC!
    
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var events = [Event]()
    var insight = [Balance]()
    var listener: ListenerRegistration!
    var expanded: Bool = false
    
    var collectionViewFrame: CGRect!    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionView.backgroundColor = UIColor.textFieldBackgroundColor
        collectionView.autoresizingMask = [.flexibleHeight]
        adapter.collectionView = collectionView
        adapter.dataSource = self
        getBalance()
        get()        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let displayWidth: CGFloat = self.frame.width
        collectionView.frame =  CGRect(x: 0, y: 55, width: displayWidth, height: 100)
        collectionViewFrame = collectionView.frame
        self.contentView.addSubview(collectionView)
        self.moreLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    @IBAction func moreButton(_ sender: OptionButton) {
        let height = (self.viewController?.view.frame.height)! - 65
        expanded = !expanded
        if expanded {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect(x: 0, y: 45, width: self.frame.width, height: height)
                self.collectionView.frame = CGRect(x: 0, y: 45, width: self.frame.width, height: height)
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.moreLabel.text = "Show less"
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = CGRect(x: 0, y: 45, width: self.frame.width, height: 236)
                self.contentView.layoutIfNeeded()
                self.collectionView.frame = self.collectionViewFrame
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                self.moreLabel.text = "Show more"
            })
        }
    }


    
    
    func get() {
        events = []
        self.adapter.reloadData(completion: nil)
        listener = DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("events").order(by: "date", descending: true).addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreiving snapshots \(error!)")
                return
            }
            for document in snapshot.documents {
                if document.exists {
                    let data = document.data()
                    let key = document.documentID
                    let event = Event(key: key, data: data)
                    self.events.append(event)
                    self.reload()
                }
            }
        }
    }
    
    func getBalance() {
        listener = DataService.instance.REF_USERS.document(Auth.auth().currentUser!.uid).collection("insight").document("balance").addSnapshotListener { (document, error) in
            if (document?.exists)! {
                let data = document!.data()
                let balance = Balance(data: data)
                self.pendingLabel.text = "\(balance.pendingAmount ?? 0)$"
                self.availableLabel.text = "\(balance.availableAmount ?? 0)$"
            }
        }
    }
    
    
    func reload() {
        self.adapter.performUpdates(animated: true) { (success) in
            //self.listener.remove()
            //self.adapter.reloadData(completion: nil)
        }
    }
}

extension CurrentUserView {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return events as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CurrentUserListController()
    }
    
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel()
        label.frame = self.frame
        label.text = "No data to show yet."
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }
}

