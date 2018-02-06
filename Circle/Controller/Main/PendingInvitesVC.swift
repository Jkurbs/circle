//
//  PendingInvitesVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/5/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//




import UIKit


final class PendingInvitesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var pendingInsiders = [User]()
    
    
    var images = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "six"), #imageLiteral(resourceName: "seven"), #imageLiteral(resourceName: "five")]

    var circle = CircleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("PENDING...")
        self.view.backgroundColor = .white
        setup()
        
        //retrievePendingInvites()
    }


    
    
    func setup() {
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = CircleLayout()

        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        
        

        
        
        circle.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: self.view.frame.size.height)
        circle.center = collectionView.center
        circle.draw(CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
        let shortestAxisLength = min(collectionView.frame.width, collectionView.frame.height)
        circle.radius = shortestAxisLength * 0.4
        circle.thumbRadius = 0.0
        circle.endThumbStrokeColor = UIColor(white: 0.7, alpha: 1.0)
        circle.lineWidth = 3.0
        circle.endPointValue = 0.4
        circle.trackColor = UIColor(white: 0.8, alpha: 1.0)
        circle.backtrackLineWidth = 3.0
        circle.diskFillColor = UIColor(red: 52, green: 128, blue: 219, alpha: 1.0)
        circle.diskColor = .white
        circle.backgroundColor = .clear
        self.view.insertSubview(circle, at: 0)
    }



    // update collection view if size changes (e.g. rotate device)

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.collectionView?.performBatchUpdates(nil)
        })
    }


    func retrievePendingInvites() {
        DataService.instance.retrievePossibleInsider { (success, error, user) in
            if !success {
                print("ERROR:", error)
            } else {
                //print("FIRSTNAM:", user?.firstName)

                self.collectionView.performBatchUpdates({
                    self.collectionView?.insertItems(at: [IndexPath(item: self.pendingInsiders.count - 1, section: 0)])
                    self.pendingInsiders.insert(user!, at: 0)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                       }
                   })
                }
            }
        }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PendingInviteCell", for: indexPath) as! PendingInviteCell
        let image = images[indexPath.row]
        cell.configure(image)
        return cell
    }
    
    var selectedIndex: IndexPath?
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(selectedIndex != indexPath){ // It's not the expanded cell
            var indicesArray = [IndexPath]()
            if(selectedIndex != nil){  //User already expanded other previous cell

                let cell = collectionView.cellForItem(at: selectedIndex!) as! PendingInviteCell
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: { (completion) in
                    
                })
                indicesArray.append(selectedIndex!)
            }
            
            selectedIndex = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as! PendingInviteCell
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (completion) in
                
            })
            indicesArray.append(indexPath)
        }
    }
}




