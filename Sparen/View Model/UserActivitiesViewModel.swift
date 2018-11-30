//
//  UserActivitiesViewModel.swift
//  Sparen
//
//  Created by Kerby Jean on 9/6/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


//import Foundation
//import UIKit
//
//class UserActivitiesViewModel {
//    
//    let apiService: DataService
//    
//    var activities = [UserActivities]()
//    
//    private var cellViewModels: [ActivitiesCellViewModel] = [ActivitiesCellViewModel]() {
//        didSet {
//            self.reloadCollectionViewClosure?()
//        }
//    }
//    
//    var isLoading: Bool = false {
//        didSet {
//            // self.updateLoadingStatus?()
//        }
//    }
//    
//    var numberOfCells: Int {
//        return cellViewModels.count
//    }
//    
//    var selectedIndex: IndexPath?
//    var isSelected: Bool = false
//    
//    var reloadCollectionViewClosure: (()->())?
//    var showAlertClosure: (()->())?
//    var updateLoadingStatus: (()->())?
//    
//    
//    init (apiService: DataProtocol = DataService()) {
//        self.apiService = apiService as! DataService
//    }
//    
//    
//    func fetchUserActivities(_ circleId: String?, _ userId: String) {
//        self.activities = []
//        apiService.fetchUserActivities(circleId!, userId) { [weak self] (success, error, activities) in
//            if !success {
//                print("ERROR:", error?.localizedDescription)
//            } else {
//                self?.activities.append(activities)
//
//                print("activity:::", self?.activities.count)
//            }
//        }
//    }
//    
//    
//    func getCellViewModel( at indexPath: IndexPath ) -> ActivitiesCellViewModel {
//        return cellViewModels[indexPath.row]
//    }
//    
//    
//    func createCellViewModel( activites: UserActivities ) -> ActivitiesCellViewModel {
//        return ActivitiesCellViewModel(daysLeft: 0, daysTotal: 0)
//    }
//    
//    
//    private func processFetchedUser( activities: [UserActivities] ) {
//        self.activities = activities
//        print("activities count::", self.activities.count)
//        var vms = [ActivitiesCellViewModel]()
//        for activities in activities {
//            vms.append( createCellViewModel(activites: activities))
//        }
//        self.cellViewModels = vms
//    }
//}
//
//
//
//struct ActivitiesCellViewModel {
//    let daysLeft: Int
//    let daysTotal: Int
//}
//
