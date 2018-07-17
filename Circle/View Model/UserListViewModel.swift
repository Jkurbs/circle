//
//  UserViewModel.swift
//  Circle
//
//  Created by Kerby Jean on 7/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import Foundation
import UIKit

class UserListViewModel {
    
    let apiService: DataService
    
    var users = [User]()
    var user: User!

    private var cellViewModels: [UserCellViewModel] = [UserCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
          // self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }

    var selectedIndex: IndexPath?
    var isSelected: Bool = false
    
    var reloadCollectionViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?


    
    init (apiService: DataServiceProtocol = DataService()) {
        self.apiService = apiService as! DataService
    }
    
    
    func initFetch() {
        apiService.fetchUsers { [weak self] (success, users, error) in
            if !success {
                print("ERROR:", error!.localizedDescription)
            } else {
                self?.processFetchedUser(users: users!)
            }
        }
    }
    
    func initFetchPayoutUsers() {
//        apiService.fetchPayoutUsers { (success, users, error) in
//            if !success {
//                print("ERROR:", error!.localizedDescription)
//            } else {
//                self.processFetchedUser(users: users!)
//            }
//        }
    }
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> UserCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    
    func createCellViewModel( user: User ) -> UserCellViewModel {
        return UserCellViewModel(imageUrl: user.imageUrl!, userId: user.userId!, payed: user.payed ?? false, daysLeft: 0)
    }
    
    
    private func processFetchedUser( users: [User] ) {
        self.users = users
        var vms = [UserCellViewModel]()
        for user in users {
            vms.append( createCellViewModel(user: user))
        }
        self.cellViewModels = vms
    }
}

extension UserListViewModel {
    
    func userPressed( at indexPath: IndexPath) {
        Haptic.tic.occured()
        let user  = self.users[indexPath.row]
        let data = ["user": user]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
    }
}



struct UserCellViewModel {
    let imageUrl: String
    let userId: String
    let payed: Bool
    let daysLeft: Int
}
