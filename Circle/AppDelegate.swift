//
//  AppDelegate.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseInvites
import GoogleSignIn
import SwiftyUserDefaults
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        IQKeyboardManager.shared().isEnabled = true

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = UIColor.darkText
        self.window?.backgroundColor = UIColor.white
        userIsLoggingIn()
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            print("ERROR")
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        print("clientID:----->\(authentication.clientID)")
        print("idToken:----->\(authentication.idToken)")
        print("accessToken:----->\(authentication.accessToken)")
        print("credential:----->\(credential)")
        
        
        Auth.auth().signIn(with: credential) { (user, error) in
            // ...
            if error != nil {
                // ...
                print("ERROR: \(error.debugDescription)")
                print("Success")
                self.logInUser()
                
                return
            } else {
                self.logInUser()

                print("Failure:----->\(error.debugDescription)")
            }
            // ...
        }
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            //            return GIDSignIn.sharedInstance().handle(url,
            //                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            //                                                     annotation: [:])
            return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
            
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let invite = Invites.handle(url, sourceApplication: sourceApplication, annotation: annotation) as? ReceivedInvite {
            let matchType = (invite.matchType == .weak) ? "Weak" : "Strong"
            print("Invite received from: \(sourceApplication ?? "") Deeplink: \(invite.deepLink)," +
                "Id: \(invite.inviteId), Type: \(matchType)")
            return true
        }
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TestAppInvite")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func logInUser() {
        print("LOG IN")
        // Called when the user log in.
        let circleVC = CircleVC()
        self.window?.rootViewController = circleVC
        self.window?.makeKeyAndVisible()
    }
    
    func userIsLoggingIn() {
        if let uid = Defaults[.key_uid] {
            if !uid.isEmpty {
                let circleVC = CircleVC()
                self.window?.rootViewController = circleVC
                self.window?.makeKeyAndVisible()
            }
        }
    }
}

