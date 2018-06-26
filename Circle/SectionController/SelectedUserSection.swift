//
//  UpperSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class UpperSection: ListSectionController, ListAdapterDataSource {
    
    private var user: User?
    private var users = [User]()
    
    
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 3)
    }()
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override init() {
        super.init()
        retrieveUsers()
    }


    override func numberOfItems() -> Int {
        return 2
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: SettingsCell.self, for: self, at: index) as? SettingsCell else {
                fatalError()
            }
            cell.configure(user!)
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else {
                fatalError()
            }
            adapter.collectionView = cell.collectionView
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
}

extension UpperSection {
    
    
    func retrieveUsers() {
        DataService.instance.REF_CIRCLES.document("").collection("insiders").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New city: \(diff.document.data())")
                

                    
                    
                    
                    
                    
                }
                if (diff.type == .modified) {
                    print("Modified city: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                }
            }
            
        }
    }
    
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return users as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SelectedUsersSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

