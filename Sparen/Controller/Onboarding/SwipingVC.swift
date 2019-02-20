//
//  SwipingVC.swift
//  Sparen
//
//  Created by Kerby Jean on 2/12/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class SwipingVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    struct Data {
        var title: String
        var image: UIImage
    }
    
    var data = [Data]()
    
    var circleId: String?
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = .gray
        pc.pageIndicatorTintColor = UIColor(white: 0.9, alpha: 1.0)
        return pc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(circleId, forKey: "circleId")
        
        data = [Data(title: "Sparen is a rotating savings and credit association between a small group of people", image: UIImage(named: "sparen")!), Data(title: "two", image: UIImage(named: "sparen")!), Data(title: "three", image: UIImage(named: "sparen")!), Data(title: "four", image: UIImage(named: "sparen")!)]

        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        collectionView?.addSubview(pageControl)
        
        constrain(pageControl, view) { (pageControl, view) in
           pageControl.centerX == view.centerX
           pageControl.bottom == view.bottom - 50
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageCell
        let row = indexPath.row
        let data = self.data[row]
        if row == 3 {
            cell.startedButton.isHidden = false
        } else {
            cell.startedButton.isHidden = true 
        }
        cell.configure(data.title, data.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
}
