//
//  CircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import HGCircularSlider


class CircleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var circle: CircularSlider!
        
    var images = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"),#imageLiteral(resourceName: "three"),#imageLiteral(resourceName: "six"),#imageLiteral(resourceName: "eight"),#imageLiteral(resourceName: "seven")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

        // just for giggles and grins, let's show the insertion of a cell
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.collectionView?.performBatchUpdates({
//                self.numberOfCells += 1
//                self.collectionView?.insertItems(at: [IndexPath(item: 0, section: 0)])
//            })
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.collectionView?.performBatchUpdates({
//                self.numberOfCells -= 1
//                self.collectionView?.deleteItems(at: [IndexPath(item: 0, section: 0)])
//            })
//        }
    }
            
    // update collection view if size changes (e.g. rotate device)
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView?.performBatchUpdates(nil)
        })
    }
    
    func setupViews() {
        
        circle = CircularSlider(frame: CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height))
        circle.draw(CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
        circle.thumbRadius = 0.0
        circle.endThumbStrokeColor = UIColor(white: 0.7, alpha: 1.0)
        circle.lineWidth = 2.0
        circle.endPointValue = 0.4
        circle.trackColor = UIColor(white: 0.8, alpha: 1.0)
        circle.backtrackLineWidth = 2.0
        circle.diskColor = .white
        circle.backgroundColor = .clear
        self.view.insertSubview(circle, at: 0)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CircleLayout()
        
        }
}


// MARK: UICollectionViewDataSource
extension CircleVC {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCell", for: indexPath) as! CircleCell
        let image = images[indexPath.row]
        cell.imageView.image = image 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select")
    }
}

