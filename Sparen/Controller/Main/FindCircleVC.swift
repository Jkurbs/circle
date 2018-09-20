//
//  FindCircleVC.swift
//  Sparen
//
//  Created by Kerby Jean on 9/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import Cartography

class FindCircleVC: UIViewController, ListAdapterDataSource {
    
    var circles = [Circle]()
    var label: UILabel!
    var pulse = Pulsator()
    var reloadButton = UIButton()
    
    var minimumAmount: Int?
    var maximumAmount: Int?
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .backgroundColor
        
        self.title = "Find Circle"

        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        pulse.autoRemove = true
        pulse.radius = 50.0
        pulse.numPulse = 2
        pulse.backgroundColor = UIColor.sparenColor.cgColor
        pulse.position = CGPoint(x: view.center.x, y: view.center.y)
        view.layer.addSublayer(pulse)
        
        findCircles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(collectionView, label, view) { (collectionView, label, view) in

            label.bottom == view.bottom - 250
            label.width == view.width - 100
            label.height == 100
            label.centerX == view.centerX

            collectionView.edges == view.edges
            collectionView.height == view.height
            
        }
    }
    
    
    @objc func findCircles () {
        self.circles = []
        
        label = UICreator.create.label("Hold on, I'm looking for circles you can join...", 17, .darkText, .center, .regular, view)
        label.numberOfLines = 4

        pulse.start()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            
            DataService.call.REF_CIRCLES.whereField("activated", isEqualTo: false).addSnapshotListener { (snapshot, error) in
                guard let snap = snapshot else {
                    return
                }
                
                if snap.documents.count == 0 {
                    self.label.text = "Sorry no matches were found for the moment."
                    self.pulse.stop()
                }
                
                for document in snap.documents {
                    if document.exists {
                        let key = document.documentID
                        let data = document.data()
                        let circle = Circle(key: key, data: data)
                        self.circles.append(circle)
                        self.adapter.performUpdates(animated: true, completion: nil)
                        self.pulse.stop()
                        self.label.text = ""
                    } else {
                        self.label.text = "Sorry no matches were found for the moment."
                        self.pulse.stop()
                    }
                }
            }
        }
    }
}

extension FindCircleVC {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return circles as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return FindCircleSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
