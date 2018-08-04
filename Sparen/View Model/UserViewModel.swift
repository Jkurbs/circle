//
//  UserViewModel.swift
//  Circle
//
//  Created by Kerby Jean on 7/1/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import Foundation

class UserListViewModel {
    
    let apiService: DataService
    
    private var users: [User] = [User]()
    

    private var cellViewModels: [UserCellViewModel] = [UserCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
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
    
    
    var selectedUser: User?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    
    init( apiService: DataServiceProtocol = DataService()) {
        self.apiService = apiService as! DataService
    }
    
    
    func initFetch() {
        apiService.fetchUsers { [weak self] (success, users, error) in
            if let error = error {
                print("ERROR:", error.localizedDescription)
            } else {
                self?.processFetchedUser(users: users)
            }
        }
    }
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> UserCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    
    func createCellViewModel( user: User ) -> UserCellViewModel {
        return UserCellViewModel(imageUrl: user.photoUrl!)
    }
    
    
    private func processFetchedUser( users: [User] ) {
        self.users = users // Cache
        var vms = [UserCellViewModel]()
        for user in users {
            vms.append( createCellViewModel(user: user))
        }
        self.cellViewModels = vms
    }
}


struct UserCellViewModel {
    let imageUrl: String
}
