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
        layout.scrollDirection = .vertical 
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.backgroundColor = .clear
        self.contentView.addSubview(view)
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        //(red: 230.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
    
    

final class CircleCollectionViewCell: UICollectionViewCell {
    
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        self.contentView.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PendingInviteCell.self, forCellWithReuseIdentifier: "PendingInviteCell")
        //(red: 230.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
    
}
    
    extension CircleCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PendingInviteCell", for: indexPath) as! PendingInviteCell
            //let user = self.users[indexPath.row]
            //cell.configure(user)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
//            if (userViewIsShow) {
//                userViewIsShow = false
//            } else {
//                //First Tap
//                userViewIsShow = true
//                contentView.addSubview(dashboardView)
//                dashboardView.isHidden = false
//            }
//            
//            let user = self.users[indexPath.row]
//            
//            if(selectedIndex != indexPath) {
//                var indicesArray = [IndexPath]()
//                if(selectedIndex != nil) {
//                    
//                    let cell = collectionView.cellForItem(at: selectedIndex!) as! PendingInviteCell
//                    UIView.animate(withDuration: 0.3, animations: {
//                        cell.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
//                        cell.transform = CGAffineTransform.identity
//                    }, completion: { (completion) in
//                    })
//                    indicesArray.append(selectedIndex!)
//                }
//                
//                selectedIndex = indexPath
//                let cell = collectionView.cellForItem(at: indexPath) as! PendingInviteCell
//                
//                UIView.animate(withDuration: 0.3, animations: {
//                    cell.layer.borderColor = UIColor.blueColor.cgColor
//                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//                }, completion: { (completion) in
//                    dispatch.async {
//                        if user?.userId != Auth.auth().currentUser!.uid {
//                            self.dashboardView.configure(user)
//                        } else {
//                            print("CURRENT USER")
//                        }
//                    }
//             })
//                indicesArray.append(indexPath)
//        }
    }
}






    
    
  