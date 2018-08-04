//
//  EditAccountSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import IGListKit

class EditAccountSection: ListSectionController {
    
    private var user: User?
    
    override func sizeForItem(at index: Int) -> CGSize {
        if index == 0 {
            return CGSize(width: collectionContext!.containerSize.width, height: 90)
        } else {
            return CGSize(width: collectionContext!.containerSize.width, height: 80)
        }
    }
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateUserProfile))
        self.viewController?.navigationItem.rightBarButtonItem = button
    }
    
    
    override func numberOfItems() -> Int {
        return 4
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ProfileImageCell.self, for: self, at: index) as? ProfileImageCell else {
                fatalError()
            }
            
            if let url = user?.imageUrl {
                cell.imageView.sd_setImage(with: URL(string: url))
            } else {
                cell.imageView.image = #imageLiteral(resourceName: "Profile-40")
            }
            return cell
        } else if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: UserNameCell.self, for: self, at: index) as? UserNameCell else {
                fatalError()
            }
            cell.textField.text = user?.userName ?? ""
            return cell
        } else if index == 2 {
            guard let cell = collectionContext?.dequeueReusableCell(of: DisplayNameCell.self, for: self, at: index) as? DisplayNameCell else {
                fatalError()
            }
            cell.textField.text = "\(user!.firstName ?? "") \(user!.lastName ?? "")"
            return cell
        } else  {
            guard let cell = collectionContext?.dequeueReusableCell(of: EmailCell.self, for: self, at: index) as? EmailCell else {
                fatalError()
            }
            cell.textField.text = user!.email
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
    
    
    
    
    
    @objc func updateUserProfile() {
        if let imageCell = collectionContext?.cellForItem(at: 0, sectionController: self) as? ProfileImageCell, let userNameCell = collectionContext?.cellForItem(at: 1, sectionController: self) as? UserNameCell, let displayNameCell = collectionContext?.cellForItem(at: 2, sectionController: self) as? DisplayNameCell, let emailCell = collectionContext?.cellForItem(at: 3, sectionController: self) as? EmailCell {
            if let userId = Auth.auth().currentUser?.uid {
                let storageItem = DataService.call.REF_STORAGE.child("profile_images").child(userId)
                guard let image = imageCell.imageView.image else {return}
                if let newImage = UIImagePNGRepresentation(image) {
                    storageItem.putData(newImage, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("error updating user profile", error.localizedDescription)
                            return
                        } else {
                            storageItem.downloadURL(completion: { (url, error) in
                                if let error = error {
                                    print("error downloading url", error.localizedDescription)
                                    return
                                }
                                if let profilePhotoUrl = url?.absoluteString {
                                    guard let newUserName = userNameCell.textField.text else {return}
                                    guard let fullName = displayNameCell.textField.text else {return}
                                    guard let newEmail = emailCell.textField.text else {return}
                                    
                                    let fullNameArr = fullName.components(separatedBy: " ")
                                    
                                    let firstName = fullNameArr[0]
                                    let lastName = fullNameArr[1]

                                    let data = ["image_url": profilePhotoUrl,
                                                     "user_name": newUserName,
                                                     "first_name": firstName,
                                                     "last_name": lastName,
                                                     "email_address": newEmail] as [String : Any]                                
                                    
                                    DataService.call.REF_CIRCLES.document((self.user?.circle)!).collection("insiders").document(userId).updateData(data)
                                    
                                    DataService.call.REF_USERS.document(userId).updateData(data, completion: { (error) in
                                        if let error = error {
                                            print("error", error.localizedDescription)
                                        } else {
                                            self.viewController?.navigationController?.popViewController(animated: true)
                                        }
                                    })
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
