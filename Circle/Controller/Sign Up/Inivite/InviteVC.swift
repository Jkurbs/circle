//
//  InviteVC.swift
//  Circle
//
//  Created by Kerby Jean on 1/11/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Contacts
import IGListKit
import FirebaseAuth

final class InviteVC: UIViewController, ListAdapterDataSource {
    
    var contacts = [Contact]()
    var infoView: UIView!
    var subhead = Subhead()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        
        subhead.text = "Invite at least 5 person to join your Circle"

        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        self.contacts = []
        collectionView.allowsMultipleSelection = true 
        adapter.collectionView = collectionView
        adapter.dataSource = self
        GetContactAccess() 
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        infoView.backgroundColor = UIColor.textFieldBackgroundColor
        view.addSubview(infoView)
        
        subhead.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: 45)
        subhead.center.x = infoView.center.x
        infoView.addSubview(subhead)

        collectionView.frame = CGRect(x: 0, y: infoView.frame.height , width: view.frame.width, height: view.frame.height - 50 )
    }
    
    
    private func GetContactAccess() {
        let store = CNContactStore()
        self.retrieveContactsWithStore(store)
    }
    
    
    func retrieveContactsWithStore(_ store: CNContactStore) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: [ CNContactIdentifierKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor,CNContactNamePrefixKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor])
        fetchRequest.sortOrder = .userDefault
        
        let store = CNContactStore()
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                if !contact.isKeyAvailable(CNContactPhoneNumbersKey){
                    print("CAN'T SHOW ")
                } else {
                    let cont = Contact(identifier: contact.identifier, givenName: contact.givenName, namePrefix: contact.namePrefix, familyName: contact.familyName, emailAddress: String(describing: contact.emailAddresses.first?.value ?? ""), phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "",  imageData: contact.imageData)
                    self.contacts.append(cont)
                }
                dispatch.async {
                    self.adapter.performUpdates(animated: true)
                }
                DispatchQueue.global(qos: .background).async {
                    //DataService.instance.saveContacts(contacts: self.contacts)
                }
            })
            return
        } catch let error as NSError {
            print(error.localizedDescription)
    }
}
    
    // MARK: ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
       return contacts as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ContactListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}
