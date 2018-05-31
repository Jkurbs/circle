//
//  AppDelegate.swift
//  Circle
//
//  Created by Kerby Jean on 2017-11-03.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//

import UIKit
import Stripe
import LinkKit
import Firebase
import FirebaseFirestore
import UserNotifications
import IQKeyboardManager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    private let customURLScheme = "com.Kurbs.Circle"
    
    private let publishableKey: String = "pk_test_7El6nynr3wdrWwMltimfThlk"
    private let plaidKey: String = "f4ca51e7acd2e7241957a0df256d8e"
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
                
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = self.customURLScheme
        FirebaseApp.configure()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true

        let db = Firestore.firestore()
        db.settings = settings

        // Stripe payment configuration
        STPPaymentConfiguration.shared().companyName = "Circle"
        
        if !publishableKey.isEmpty {
            STPPaymentConfiguration.shared().publishableKey = publishableKey
        }
        
        #if USE_CUSTOM_CONFIG
            setupPlaidWithCustomConfiguration()
        #else
            setupPlaidLinkWithSharedConfiguration()
        #endif
        
        IQKeyboardManager.shared().isEnabled = true
        
        initialize(application)

        application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        return true
    }

    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
       }
   }


    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let incomingUrl = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl, completion: { (dynamicLink, error) in
                
                if let dynamicLink = dynamicLink, let _ = dynamicLink.url {
                    self.handleDynamicLink(dynamicLink)
                }
            })
            return linkHandled
        }
        return false
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        
        let url = dynamicLink.url?.absoluteString ?? ""
        let components = URLComponents(string: url)!

        if let queryItems = components.queryItems,
            let hlsvp = queryItems.first(where: { $0.name == "id" }) {
            
            let matchConfidence: String
            if dynamicLink.matchType == .weak {
                matchConfidence = "Weak"
            } else {
                matchConfidence = "Strong"
                let initialViewController = WelcomeVC()
                let pageViewController =  PageViewController()
                pageViewController.pages.insert(initialViewController, at: 0)
                initialViewController.circleId = hlsvp.value
                            
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            
        } else {
            print("hlsvp not found")
        }
        
        
    }
    
    
    func showDeepLinkAlertView(withMessage message: String, link: String) {
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OKAY")
        }
        let alertController = UIAlertController(title: "Deep-link Data", message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
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
    
    
    
    // MARK: Plaid Link setup with shared configuration from Info.plist
    func setupPlaidLinkWithSharedConfiguration() {
        // <!-- SMARTDOWN_SETUP_SHARED -->
        // With shared configuration from Info.plist
        PLKPlaidLink.setup { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }
        // <!-- SMARTDOWN_SETUP_SHARED -->
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
             UserDefaults.standard.setValue(refreshedToken, forKey: "deviceToken")
        }
    }
    
    
    // MARK: Plaid Link setup with custom configuration
    func setupPlaidWithCustomConfiguration() {
        // <!-- SMARTDOWN_SETUP_CUSTOM -->
        // With custom configuration
        let linkConfiguration = PLKConfiguration(key: "f4ca51e7acd2e7241957a0df256d8e", env: .sandbox, product: .auth)
        linkConfiguration.clientName = "Link Demo"
        PLKPlaidLink.setup(with: linkConfiguration) { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }
        // <!-- SMARTDOWN_SETUP_CUSTOM -->
    }
    
    
    private func initialize(_ application: UIApplication) {
    
         let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        //(red: 241, green: 196, blue: 15, alpha: 1.0)
        
        let initialViewController =  LoginVC()
        let navigationController = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        if let uid = UserDefaults.standard.value(forKey: "userId") as? String {
            if !uid.isEmpty {
                let initialViewController = CircleVC()
                let navigationController = UINavigationController(rootViewController: initialViewController)
                let vc = navigationController
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            } else {
                let initialViewController =  LoginVC()
                let navigationController = UINavigationController(rootViewController: initialViewController)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
    }
}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("DEVICE TOKEN : \(fcmToken)")
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
        UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
}
