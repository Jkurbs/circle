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

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

final class EmbeddedCollectionViewCell: UICollectionViewCell {
    
    fileprivate var sourceIndexPath: IndexPath?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
        
      
        
        return view
    }()
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != .ended {
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        if indexPath == nil {
            print("Couldn't find index path")
        } else {
            let cell = self.collectionView.cellForItem(at: indexPath!)
            if gestureRecognizer.state == .began {
                print("began pressing::", indexPath?.row)
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.backgroundColor = .white
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
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
import FirebaseAuth

final class CircleCollectionViewCell: UICollectionViewCell {
    
    var circleView = CircleView()
    var pulsator = Pulsator()
    var users = [User]()
    var circle: Circle? {
        didSet {
            if circle == nil {
                
            }
        }
    }
    
    var position: CGPoint? {
        didSet {
            if (position?.x.isNaN)! && (position?.y.isNaN)! {
                pulsator.start()

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureCirclePulse(_:)), name: NSNotification.Name(rawValue: "pulseNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPositions(_:)), name: .reloadPosition, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersIndex), name: .userLeft, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(initFetch), name: .fetchUsers, object: nil)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initLayout()
    }

    
    func initView() {
        contentView.addSubview(circleView)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = .white
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
                circleView.width == collectionView.width - 130
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
    
    
    @objc func initFetch(_ notification: Notification) {
        
        self.users.removeAll()
        
        guard let dict = notification.userInfo as NSDictionary? else {return}
        guard let users = dict["users"] as? [User] else {return}
        self.users = users
        self.users.sort(by: {$0.position! < $1.position!})
        self.collectionView.reloadData()
    }
    
    
    @objc func updateUsersIndex() {
        for user in self.users {
        DataService.call.RefUsers.child(user.userId!).child("position").observeSingleEvent(of: .value) { (snapshot) in
             let value = snapshot.value as! Int
                if value != 0 {
                    let newPosition = value - 1
                    DataService.call.RefUsers.child(user.userId!).updateChildValues(["position": newPosition])
                }
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
    cell.imageView.image = nil  //Remove the image from the recycled cell
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
            let data = ["user": user, "position": indexPath.row] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
            Haptic.tic.occured()
            selectedIndex = indexPath
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
    
    @objc func reloadPositions(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let positions = dict["positions"] as? [String: Any] {
                let position = positions["position"] as! Int
                let forPosition = positions["forPosition"] as! Int
                self.users.swapAt(position, forPosition)
                self.collectionView.reloadData()
            }
        }
    }
}

    
    
  
