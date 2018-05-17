//
//  ChooseBankVC.swift
//  Circle
//
//  Created by Kerby Jean on 3/2/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//


import Stripe
import FirebaseAuth

// <!-- SMARTDOWN_IMPORT_LINKKIT -->
import LinkKit
// <!-- SMARTDOWN_IMPORT_LINKKIT -->


class ChooseBankVC: UIViewController {
    
    var emailAddress: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseBankVC.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        #if USE_CUSTOM_CONFIG
            presentPlaidLinkWithCustomConfiguration()
        #else
            presentPlaidLinkWithSharedConfiguration()
        #endif

    }
    
    @objc func didReceiveNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "PLDPlaidLinkSetupFinished" {
            NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        }
    }
    
    
    func handleSuccessWithToken(_ publicToken: String, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleError(_ error: Error, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleExitWithMetadata(_ metadata: [String : Any]?) {
        //presentAlertViewWithTitle("Exit", message: "metadata: \(metadata ?? [:])")
        dismiss(animated: true, completion: nil)
    }
    
    func presentAlertViewWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Plaid Link setup with shared configuration from Info.plist
    func presentPlaidLinkWithSharedConfiguration() {
        // <!-- SMARTDOWN_PRESENT_SHARED -->
        // With shared configuration from Info.plist
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .custom;
        }
        linkViewController.providesPresentationContextTransitionStyle = true
        linkViewController.definesPresentationContext = true
        linkViewController.modalPresentationStyle = .custom
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_PRESENT_SHARED -->
    }
    
    // MARK: Plaid Link setup with custom configuration
    func presentPlaidLinkWithCustomConfiguration() {
        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "f4ca51e7acd2e7241957a0df256d8e", env: .sandbox, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .custom;
        }
        linkViewController.providesPresentationContextTransitionStyle = true
        linkViewController.definesPresentationContext = true
        linkViewController.modalPresentationStyle = .custom
        
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_PRESENT_CUSTOM -->
    }
    
    // MARK: Start Plaid Link in update mode
    func presentPlaidLinkInUpdateMode() {
        // <!-- SMARTDOWN_UPDATE_MODE -->
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(publicToken: "f4ca51e7acd2e7241957a0df256d8e", delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .custom;
        }
        linkViewController.providesPresentationContextTransitionStyle = true
        linkViewController.definesPresentationContext = true
        linkViewController.modalPresentationStyle = .custom
        present(linkViewController, animated: true)
        // <!-- SMARTDOWN_UPDATE_MODE -->
    }
}

// MARK: - PLKPlaidLinkViewDelegate Protocol
// <!-- SMARTDOWN_PROTOCOL -->
extension ChooseBankVC : PLKPlaidLinkViewDelegate
    // <!-- SMARTDOWN_PROTOCOL -->
{
    
    // <!-- SMARTDOWN_DELEGATE_SUCCESS -->
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")            
            let data: [String: Any] = ["public_token": publicToken, "account_id": metadata!["account_id"]!]
            self.save(data)
        }
    }
    // <!-- SMARTDOWN_DELEGATE_SUCCESS -->
    
    // <!-- SMARTDOWN_DELEGATE_EXIT -->
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                self.handleError(error, metadata: metadata)
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                self.handleExitWithMetadata(metadata)
            }
        }
    }
    // <!-- SMARTDOWN_DELEGATE_EXIT -->
    
    // <!-- SMARTDOWN_DELEGATE_EVENT -->
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
        NSLog("Link event: \(event)\nmetadata: \(metadata ?? [:])")
    }
    // <!-- SMARTDOWN_DELEGATE_EVENT -->
    
    
    func save(_ plaid: [String: Any]) {
        
        DataService.instance.saveBankInformation(email: emailAddress!, plaid: plaid) { (success, error) in
            if !success {
                dispatch.async {
                    let alert = Alert()
                    alert.showPromptMessage(self, title: "Error", message: (error?.localizedDescription)!)
                }
            } else {
                DataService.instance.addNewInsider(Auth.auth().currentUser!.uid)
                dispatch.async {
                    let vc = CircleVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

