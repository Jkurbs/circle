//
//  EmbeddedCollectionViewCell.swift
//  Circle
//
//  Created by Kerby Jean on 11/26/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import UIKit
import IGListKit

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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}


import IGListKit

final class CircleCollectionViewCell: UICollectionViewCell {
    
    var users = [User]()
    
    var circleView = CircleView()
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    let impact = UIImpactFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    let notification = UINotificationFeedbackGenerator()

    var selectedIndex: IndexPath?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(circleView)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircleUserCell.self, forCellWithReuseIdentifier: "CircleUserCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame        
        circleView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - 85, height: contentView.frame.height)
        circleView.center.x = collectionView.center.x
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
            let user = self.users[indexPath.row]
            cell.configure(user)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            impact.impactOccurred()
            let user = self.users[indexPath.row]
            let userData = ["user": user]
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
                selectedIndex = indexPath
                let cell = collectionView.cellForItem(at: indexPath) as! CircleUserCell
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: userData)
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: { (completion) in

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






    
    
  
