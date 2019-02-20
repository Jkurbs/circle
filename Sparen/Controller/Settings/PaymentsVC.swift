//
//  PaymentVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/15/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth

class PaymentVC: UIViewController, ListAdapterDataSource {
    
    
    var cards = [Card]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add card"
        view.backgroundColor = .white

        collectionView.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        fetchCards()
    }

    
    
    
    func fetchCards() {
    
        DataService.call.RefCards.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            self.cards = [] 
            guard let value = snapshot.value as? [String : Any] else {return}
            let key = snapshot.key
            let card = Card(key, value)
            self.cards.append(card)
        }
    }
}

extension PaymentVC {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return cards as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CardSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
