//
//  AppDelegate.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 16/11/20.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Siren

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?  //---using for autoupdate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
       
        //---using for autoupdate, code starts
//        window?.makeKeyAndVisible()
//        Siren.shared.wail()
        //---using for autoupdate, code ends
        
        hyperCriticalRulesAppForceUpdate() //--aded on 2021-Aug-02
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    //---added on 08-Mar-2022, code starts----
    /*func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("Local notification received (tapped, or while app in foreground): \(notification)")
    }*/
    // Local notifications
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    //---added on 08-Mar-2022, code ends----
    
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
//        let container = NSPersistentContainer(name: "WrkplanPayroll") //---commented on 09-March-2022
        let container = NSPersistentContainer(name: "DataModel") //---added on 09-Mar-2022
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

};

extension UIApplication {
var statusBarView: UIView? {
    if #available(iOS 13.0, *) {
        let tag = 5111
        if let statusBar = self.keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBarView.tag = tag

            self.keyWindow?.addSubview(statusBarView)
            return statusBarView
        }
    } else {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil}
}

//---added on 2021-Aug-02 for app update, code starts
private extension AppDelegate{
    /// How to present an alert every time the app is foregrounded.
       /// This will block the user from using the app until they update the app.
       /// Setting `showAlertAfterCurrentVersionHasBeenReleasedForDays` to `0` IS NOT RECOMMENDED
       /// as it will cause the user to go into an endless loop to the App Store if the JSON results
       /// update faster than the App Store CDN.
       ///
       /// The `0` value is illustrated in this app as an example on how to change how quickly an alert is presented.
       func hyperCriticalRulesAppForceUpdate() {
           let siren = Siren.shared
           siren.rulesManager = RulesManager(globalRules: .critical,
                                             showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)

           siren.wail { results in
               switch results {
               case .success(let updateResults):
                   print("AlertAction ", updateResults.alertAction)
                   print("Localization ", updateResults.localization)
                   print("Model ", updateResults.model)
                   print("UpdateType ", updateResults.updateType)
               case .failure(let error):
                   print(error.localizedDescription)
               }
           }
       }
}
//---added on 2021-Aug-02 for app update, code ends


