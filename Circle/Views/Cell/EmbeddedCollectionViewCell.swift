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

final class EmbeddedCollectionViewCell: UICollectionViewCell {
    let layout = UICollectionViewFlowLayout()

    lazy var collectionView: UICollectionView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initFetch()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initLayout()
    }
    
    
    func initView() {
        contentView.addSubview(circleView)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircleUserCell.self, forCellWithReuseIdentifier: "CircleUserCell")
    }
    
    func initLayout() {
        
        print("DEVICE NAME",UIDevice.modelName)

        switch UIDevice.modelName {
        case "Simulator iPhone 6":
            constrain(circleView, collectionView, contentView) { circleView, collectionView, contentView in
                collectionView.edges == contentView.edges
                circleView.height == collectionView.height
                circleView.width == contentView.width * 0.7
                circleView.centerX == collectionView.centerX
            }
        case "iPhone X":
            print("VIEW WIDTH::", contentView.frame.width)
            constrain(circleView, collectionView, contentView) { circleView, collectionView, contentView in
                collectionView.edges == contentView.edges
                circleView.height == collectionView.height
                circleView.width == contentView.width * 0.8
                circleView.centerX == collectionView.centerX
                
            }
        default:
            print("unknown model")
        }
    }
    
    
    func initFetch() {
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        self.viewModel.initFetch()
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    extension CircleCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleUserCell", for: indexPath) as! CircleUserCell
    
    let cellVM = viewModel.getCellViewModel( at: indexPath )
    cell.userViewModel = cellVM
    return cell
}
        
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! CircleUserCell
        
        self.viewModel.userPressed(at: indexPath)
        
        //cell.animate(viewModel.isSelected)

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






    
    
  
