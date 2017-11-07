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
import SwiftyUserDefaults
import HGCircularSlider


class CircleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nextDescriptionLabel: UILabel!
    var nextLabel: UILabel!
    var circle: CircularSlider!
        
    var images = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"),#imageLiteral(resourceName: "three"),#imageLiteral(resourceName: "six"),#imageLiteral(resourceName: "eight"),#imageLiteral(resourceName: "seven")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        Defaults.remove(.key_uid)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DispatchQueue.main.async {
                let board = UIStoryboard(name: "Log", bundle: nil)
                let controller = board.instantiateViewController(withIdentifier: "NameVC") as! NameVC
                self.present(controller, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("SIGNOUT ERROR:\(signOutError)")
        }
    }
    
    // update collection view if size changes (e.g. rotate device)
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView?.performBatchUpdates(nil)
        })
    }
    
    func setupViews() {
        
        let width = self.view.frame.width/2
        nextDescriptionLabel = UILabel(frame: CGRect(x: 20, y: 20, width: width, height: 50))
        nextDescriptionLabel.font = UIFont.boldSystemFont(ofSize:18)
        nextDescriptionLabel.textColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        nextDescriptionLabel.text = "Next Payout"
        self.view.addSubview(nextDescriptionLabel)
        
        nextLabel = UILabel(frame: CGRect(x: 20, y: nextDescriptionLabel.layer.position.y, width: width, height: 50))
        nextLabel.font = UIFont.boldSystemFont(ofSize: 26)
        nextLabel.text = "20 days"
        self.view.addSubview(nextLabel)
        circle = CircularSlider(frame: CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height))
        circle.draw(CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
        circle.thumbRadius = 0.0
        circle.endThumbStrokeColor = UIColor(white: 0.7, alpha: 1.0)
        circle.lineWidth = 4.0
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
        let vc = ProfileVC()
        self.present(vc, animated: true, completion: nil)
    }
}

