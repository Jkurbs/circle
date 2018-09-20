//
//  EditAccountSection.swift
//  Circle
//
//  Created by Kerby Jean on 6/27/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth
import GSMessages

class EditAccountSection: ListSectionController {
    
    private var user: User?
    private var handle: AuthStateDidChangeListenerHandle!
    
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
            guard let cell = collectionContext?.dequeueReusableCell(of: UsernameCell.self, for: self, at: index) as? UsernameCell else {
                fatalError()
            }
            cell.textField.text = user?.username ?? ""
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
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.viewController?.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user {
                let password = UserDefaults.standard.string(forKey: "password")
                let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password!)
                user.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
                    if let error = error {
                        self.viewController?.showMessage(error.localizedDescription, type: .error)
                    } else {
                        if let imageCell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? ProfileImageCell, let usernameCell = self.collectionContext?.cellForItem(at: 1, sectionController: self) as? UsernameCell, let displayNameCell = self.collectionContext?.cellForItem(at: 2, sectionController: self) as? DisplayNameCell, let emailCell = self.collectionContext?.cellForItem(at: 3, sectionController: self) as? EmailCell {
                            
                            guard let image = imageCell.imageView.image, let username = usernameCell.textField.text, let displayname = displayNameCell.textField.text, let email = emailCell.textField.text else {
                                return
                            }
                            
                            let storageItem = DataService.call.REF_STORAGE.child("profile_images").child(user.uid)
                            if let data = UIImageJPEGRepresentation(image, 1.0) {
                                storageItem.putData(data, metadata: nil) { (metadata, error) in
                                    if let error = error {
                                        self.viewController?.showMessage(error.localizedDescription, type: .error)
                                        activityIndicator.stopAnimating()
                                        return
                                    } else {
                                        storageItem.downloadURL(completion: { (url, error) in
                                            if let error = error {
                                                self.viewController?.showMessage("An error occured while updating your profile", type: .error)
                                                activityIndicator.stopAnimating()
                                                return
                                            }
                                            if let photoUrl = url?.absoluteString {
                                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                                changeRequest?.displayName = username
                                                changeRequest?.photoURL = URL(string: photoUrl)
                                                changeRequest?.commitChanges { (error) in
                                                    
                                                    if let error = error {
                                                        print("error commiting change", error.localizedDescription)
                                                    } else {
                                                        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                                                            if let error = error {
                                                              print("error updating email", error.localizedDescription)
                                                            } else {
                                                                let fullNameArr = displayname.components(separatedBy: " ")
                                                                 let firstName = fullNameArr[0]
                                                                let lastName = fullNameArr[1]
                                                                let data = ["image_url": photoUrl, "user_name": username, "first_name": firstName, "last_name": lastName, "email_address": email] as [String : Any]
                                                                DataService.call.REF_CIRCLES.document((self.user?.circle)!).collection("insiders").document(user.uid).updateData(data)
                                                                
                                                                DataService.call.REF_USERS.document(user.uid).updateData(data, completion: { (error) in
                                                                    if let error = error {
                                                                        print("error updating user data", error.localizedDescription)
                                                                        activityIndicator.stopAnimating()
                                                                    } else {
                                                                        self.viewController?.showMessage("Your profile was successfully updated", type: .success)
                                                                        activityIndicator.stopAnimating()
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                                        self.viewController?.navigationController?.popViewController(animated: true)
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                })
            } else {
                print("NO USER")
            }
        }
    }
}
