//
//  EmbeddedCollectionViewCell.swift
//  Circle
//
//  Created by Kerby Jean on 11/26/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit
import Cartography
import FirebaseDatabase

final class EmbeddedCollectionViewCell: UICollectionViewCell {
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.backgroundColor = .white
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var newFrame = layoutAttributes.frame
//        // note: don't change the width
//        newFrame.size.height = ceil(size.height)
//        layoutAttributes.frame = newFrame
//        return layoutAttributes
//    }
}


import IGListKit

final class CircleCollectionViewCell: UICollectionViewCell {
    
    var circleView = CircleView()
    var pulsator = Pulsator()
    var users = [User]()
    var circle: Circle? {
        didSet {
            if circle == nil {
                print("CIRCLE IS NIL")
            }
        }
    }
    
    var position: CGPoint? {
        didSet {
            if (position?.x.isNaN)! && (position?.y.isNaN)! {
            } else {
                pulsator.radius = 25.0
                pulsator.animationDuration = 5
                pulsator.pulseInterval = 0.8
                pulsator.backgroundColor = UIColor.sparenColor.cgColor
                pulsator.position = position!
                self.circleView.layer.addSublayer(pulsator)
                pulsator.start()
                stopTimerTest()
            }
        }
        
        willSet {
            self.pulsator.removeFromSuperlayer()
        }
    }

    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    
    var selectedIndex: IndexPath?
    var timerTest : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initFetch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureCirclePulse(_:)), name: NSNotification.Name(rawValue: "pulseNotification"), object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initLayout()
    }
    
    
    func initView() {
        contentView.addSubview(circleView)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = .backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircleUserCell.self, forCellWithReuseIdentifier: "CircleUserCell")
    }
    
    func initLayout() {
        switch UIDevice.modelName {
        case "iPhone X":
            constrain(circleView, collectionView, contentView) { circleView, collectionView, contentView in
                collectionView.edges == contentView.edges
                circleView.height == collectionView.height
                circleView.width == contentView.width * 0.7
                circleView.centerX == collectionView.centerX
            }
        default:
            constrain(circleView, collectionView, contentView) { circleView, collectionView, contentView in
                collectionView.edges == contentView.edges
                circleView.height == collectionView.height
                circleView.width == contentView.width * 0.4
                circleView.centerX == collectionView.centerX
            }
        }
    }
    
    
    func initFetch() {

        guard let circleId  = UserDefaults.standard.string(forKey: "circleId") else {
            return
        }
        
        self.users.removeAll()

        DataService.call.RefCircleMembers.child(circleId).observe( .value) { (snapshot) in
            self.users = []

            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let key = rest.key
                DataService.call.RefUsers.child(key).queryOrdered(byChild: "position").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value, let postDict = value as? [String : AnyObject] else {return}
                    let key = snapshot.key
                    let user = User(key: key, data: postDict)
                    self.users.append(user)
                    dispatch.async {
                        self.collectionView.reloadData()
                     }
                })
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
extension CircleCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleUserCell", for: indexPath) as! CircleUserCell
    let user = users[indexPath.row]
    cell.user = user
    return cell
}
        
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.viewModel.userPressed(at: indexPath)

        if(selectedIndex != indexPath) {
            var indicesArray = [IndexPath]()
            if(selectedIndex != nil) {
                let cell = collectionView.cellForItem(at: selectedIndex!) as! CircleUserCell
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: { (completion) in
                })
                indicesArray.append(selectedIndex!)
            }
            
            let user  = self.users[indexPath.row]
            let data = ["user": user]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
            Haptic.tic.occured()
            selectedIndex = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as! CircleUserCell
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (completion) in
                UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
            })
            indicesArray.append(indexPath)
        }
    }

       
    func configure(_ insight: Insight) {
        let daysPassed = insight.daysTotal! - insight.daysLeft!
        let daysTotal = insight.daysTotal
        self.circleView.maximumValue = CGFloat(daysTotal!)
        self.circleView.endPointValue = CGFloat(daysPassed)
    }
}

extension CircleCollectionViewCell {
    
    @objc func configureCirclePulse(_ notification: NSNotification) {

        guard let dict = notification.userInfo as NSDictionary? else {return}
        guard let insight = dict["insight"] as? Insight else {return}
        
        print("INSIGHT:", insight)
        
        let daysTotal = insight.daysTotal ?? 0
        let daysLeft = insight.daysLeft ?? 0
        
        let daysPassed = daysTotal - daysLeft
            
        self.circleView.maximumValue = CGFloat(daysTotal)
        self.circleView.endPointValue = CGFloat(daysPassed)
        
        if timerTest == nil {
            timerTest = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(pulse), userInfo: nil, repeats: true)
        }
    }
    

    
    @objc func pulse() {
        guard let pos = circleView.thumbPosition else {return}
        self.position = pos
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = nil
        }
    }
}





    
    
  
