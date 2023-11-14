//
//  AppDelegate.swift
//  File Manager
//
//  Created by Zakaria Darwish on 09/11/2023.
//

import UIKit
import CoreData
import AppLovinSDK
import AdSupport
import AppTrackingTransparency
import OneSignalFramework
import FirebaseCore
// adding testing Git
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device Token",deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        

        
        
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UINavigationBar.appearance().backgroundColor = .blue // backgorund color with gradient
//        // or
//        UINavigationBar.appearance().barTintColor = .blue  // solid color
//            
//        UIBarButtonItem.appearance().tintColor = .blue
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        UITabBar.appearance().barTintColor = .yellow
        
        

//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization { status in
//                switch status {
//                    case .authorized:
//                        print("enable tracking")
//                    case .denied:
//                        print("disable tracking")
//                    default:
//                        print("disable tracking")
//                }
//            }
//        }
//        var navigationBarAppearace = UINavigationBar.appearance()
//        navigationBarAppearace.tintColor = UIColor.red
//        navigationBarAppearace.barTintColor = UIColor.red
//        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        UINavigationBar.appearance().tintColor = UIColor.white

        FirebaseApp.configure()
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("d51ead96-2966-46a4-afc4-2f467a91421e", withLaunchOptions: launchOptions)

        OneSignal.Notifications.requestPermission({ accepted in
                print("User accepted notifications: \(accepted)")
              }, fallbackToSettings: true)

        
        let myIDFA: String?
           // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
               // Set the IDFA
            myIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("my ID",myIDFA ?? "DEFAuL_VALUE")
           } else {
               myIDFA = nil
           }
        
        ALSdk.shared()!.mediationProvider = "max"

           ALSdk.shared()!.userIdentifier = myIDFA

           ALSdk.shared()!.initializeSdk { (configuration: ALSdkConfiguration) in
               // Start loading ads
           }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "File_Manager")
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

}

