//
//  MonthlyAmoutCell.swift
//  Circle
//
//  Created by Kerby Jean on 6/12/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//
 
import UIKit
import IGListKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Cartography


class CircleStateCell: UICollectionViewCell, ListAdapterDataSource {
    
    var viewController: UIViewController?
    var nextPayoutUsers = [User]()
    var insights = [Insight]()

    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: viewController, workingRangeSize: 2)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        initView()
        fetchCircleActivities()
}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(collectionView, self) { (collectionView, self) in
            collectionView.width == self.width - 20
            collectionView.height == self.height - 20
            collectionView.centerX == self.centerX
        }
        
        self.layer.addShadow()
        self.layer.roundCorners(radius: 10)
    }
    
    func initView() {
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        self.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchCircleActivities() {
        guard let circleId = UserDefaults.standard.string(forKey: "circleId")  else {return}
        if !circleId.isEmpty {
            DataService.call.fetchCircleInsights(circleId) { (success, error, insight) in
                self.insights = []
                if !success {
                    print("error:", error?.localizedDescription ?? "")
                } else {
                    let data: [String: Any] = ["insight": insight]                    
                    self.insights.append(insight)
                    self.adapter.performUpdates(animated: true, completion: { (done) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pulseNotification"), object: nil, userInfo: data)
                    })
                }
            }
        } else {
            print("SOMETHING")
            self.backgroundColor = .clear
        }
    }
}

extension CircleStateCell {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return insights as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CircleInsightSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


//class CircleStateCell: UICollectionViewCell {
//
//    var viewController: UIViewController?
//    var setupCircleView = SetupCircleView()
//    var readyView = ReadyView()
//    var activatedView = ActivatedView()
//    var pulsator = Pulsator()
//
//    var circle: Circle! {
//        didSet {
//            self.addView(view: readyView)
//            self.readyView.circle = circle
//        }
//    }
//
//    var insight: Insight? {
//        didSet {
//            pulse()
//            activatedView.insights = []
//            activatedView.insights.append(insight!)
//            activatedView.circle = circle
//            activatedView.adapter.reloadData(completion: nil)
//            activatedView.viewController = self.viewController
//            self.pulsator.removeFromSuperlayer()
//            self.addView(view: self.activatedView)
//
//
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .yellow
//        contentView.clipsToBounds = true
//    }
//
//
//    func addView(view: UIView) {
//
////        view.backgroundColor = .clear
////        self.contentView.addSubview(view)
////
////        constrain(view, contentView) { (view, contentView) in
////            view.height == contentView.height - 10
////            view.width == contentView.width - 10
////            view.center == contentView.center
////        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    func pulse() {
//        pulsator.numPulse = 2
//        pulsator.radius = 30.0
//        pulsator.backgroundColor = UIColor.sparenColor.cgColor
//        pulsator.start()
//        pulsator.position = CGPoint(x: contentView.frame.width - 40, y: contentView.center.y)
//        contentView.layer.addSublayer(pulsator)
//    }
//}
//
