////
////  InviteSectionController.swift
////  Circle
////
////  Created by Kerby Jean on 1/11/18.
////  Copyright © 2018 Kerby Jean. All rights reserved.
////
//
//import UIKit
//import IGListKit
//import Contacts
//
//enum FetchType {
//    case Email
//    case PhoneNumber
//    case BothPhoneAndEmail
//}
//
//class InviteSectionController: ListSectionController, ListAdapterDataSource, UIScrollViewDelegate, UISearchBarDelegate {
//
//    var data: String!
//    private var contacts = [CNContact]()
//
//    let indicatorView: UIActivityIndicatorView = {
//        let view = UIActivityIndicatorView()
//        view.activityIndicatorViewStyle = .gray
//        view.startAnimating()
//        return view
//    }()
//
//
//    lazy var adapter: ListAdapter = {
//        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 0)
//        adapter.dataSource = self
//        adapter.scrollViewDelegate = self
//        return adapter
//    }()
//
//    override init() {
//        super.init()
//        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        GetContactAccess()
//    }
//
//    func GetContactAccess() {
//        let store = CNContactStore()
//        switch CNContactStore.authorizationStatus(for: .contacts){
//        case .authorized:
//            self.retrieveContactsWithStore(store)
//            break
//        case .denied:
//            print("permission denied")
//            //User not allowed to access contect list.
//            break
//        case .notDetermined:
//            store.requestAccess(for: .contacts, completionHandler: { (authorized, error) in
//                if authorized {
//                    self.retrieveContactsWithStore(store)
//                } else {
//                    print("ERROR:", error?.localizedDescription)
//                }
//            })
//        case .restricted:
//            break
//        }
//    }
//
//
//    func retrieveContactsWithStore(_ store: CNContactStore) {
//        do {
//            let groups = try store.groups(matching: nil)
//
//            //let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
//            let predicate = CNContact.predicateForContacts(matchingName: "John")
//            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
//            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
//            self.contacts = contacts
//            DispatchQueue.main.async {
//                self.adapter.performUpdates(animated: true)
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//    override func sizeForItem(at index: Int) -> CGSize {
//        let height: CGFloat = 80
//        if index == 0 {
//            return CGSize(width: collectionContext!.containerSize.width, height: height)
//        } else {
//            return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height - height)
//        }
//    }
//
//    override func numberOfItems() -> Int {
//        return 2
//    }
//
//
//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//
//        if index == 0 {
//            guard let cell = collectionContext?.dequeueReusableCell(of: SearchCell.self , for: self, at: index) as? SearchCell else {
//                fatalError()
//            }
//            cell.searchBar.delegate = self
//            return cell
//        } else {
//            let cell = collectionContext!.dequeueReusableCell(of: EmbeddedCollectionViewCell.self , for: self, at: index)
//            if let cell = cell as? EmbeddedCollectionViewCell {
//               self.adapter.collectionView = cell.collectionView
//            }
//            return cell
//        }
//    }
//
//
//    override func didUpdate(to object: Any) {
//        data = object as! String
//    }
//
//
//    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        return contacts as! [ListDiffable]
//    }
//
//    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
////        return SearchSectionController()
//    }
//
//    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        return nil
//    }
//}
//
