//
//  CircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
import SwiftyUserDefaults
import HGCircularSlider

class CircleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var loginVC = LoginViewController()
    var nextDescriptionLabel: UILabel!
    var nextLabel: UILabel!
    var descriptionLabel: UILabel!
    var timeLabel: UILabel!
    var circle: CircularSlider!
    var addButton: UIButton!
    var users = [User]()
    
    var images = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "six"), #imageLiteral(resourceName: "eight"), #imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "six"), #imageLiteral(resourceName: "seven"), #imageLiteral(resourceName: "three")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUser()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func settings(_ sender: Any) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
       navigationController?.pushViewController(vc, animated: true)
    }
    
    // update collection view if size changes (e.g. rotate device)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView?.performBatchUpdates(nil)
        })
    }
    
    func retrieveUser() {
        DataService.instance.retrieveUsers { (success, error, user) in
            if !success {
                print(error)

            } else {
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertItems(at: [IndexPath(item: 0, section: 0)])
                    self.users.insert(user!, at: 0)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    
    func setupViews() {
        
        // ADD LABELS
        let width = self.view.frame.width/2
        let height: CGFloat = 50.0
        let color = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        
        nextDescriptionLabel = UILabel(frame: CGRect(x: 20, y: 20, width: width, height: height))
        nextDescriptionLabel.font = UIFont.boldSystemFont(ofSize:18)
        nextDescriptionLabel.textColor = color
        nextDescriptionLabel.text = "Next Payout"
        self.view.addSubview(nextDescriptionLabel)
        
        nextLabel = UILabel(frame: CGRect(x: 20, y: nextDescriptionLabel.layer.position.y, width: width, height: height))
        nextLabel.font = UIFont.boldSystemFont(ofSize: 26)
        nextLabel.text = "20 days"
        self.view.addSubview(nextLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: self.view.bounds.width - width - 20, y: 20, width: width, height: height))
        descriptionLabel.textAlignment = .right
        descriptionLabel.font = UIFont.boldSystemFont(ofSize:18)
        descriptionLabel.textColor = color
        descriptionLabel.text = "Circle ends"
        self.view.addSubview(descriptionLabel)
        
        timeLabel = UILabel(frame: CGRect(x: self.view.bounds.width - width - 20, y: descriptionLabel.layer.position.y, width: width, height: height))
        timeLabel.textAlignment = .right
        timeLabel.font = UIFont.boldSystemFont(ofSize:26)
        timeLabel.text = "40 days"
        self.view.addSubview(timeLabel)
        
        // ADD CIRCLE

        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CircleLayout()
        
        circle = CircularSlider(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height))
        let shortestAxisLength = min(collectionView.bounds.width, collectionView.bounds.height)
        circle.radius = shortestAxisLength * 0.4
        circle.thumbRadius = 0.0
        circle.endThumbStrokeColor = UIColor(white: 0.7, alpha: 1.0)
        circle.lineWidth = 4.0
        circle.endPointValue = 0.4
        circle.trackColor = UIColor(white: 0.8, alpha: 1.0)
        circle.backtrackLineWidth = 4.0
        circle.diskFillColor = UIColor(red: 52, green: 128, blue: 219, alpha: 1.0)
        circle.diskColor = .white
        circle.backgroundColor = .clear
        self.view.insertSubview(circle, at: 0)
        
        addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        addButton.center = CGPoint(x: circle.bounds.midX, y: circle.bounds.midY)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        addButton.setImage(#imageLiteral(resourceName: "Add-24"), for: .normal)
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        collectionView.insertSubview(addButton, at: 1)
    }
    
    @objc func add() {
        
    }
}


// MARK: UICollectionViewDataSource
extension CircleVC {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCell", for: indexPath) as! CircleCell
        let user = users[indexPath.row]
        cell.configure(user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let vc = ProfileVC()
        vc.user = []
        vc.user.insert(user, at: 0)
        self.present(vc, animated: true, completion: nil)
    }
}



