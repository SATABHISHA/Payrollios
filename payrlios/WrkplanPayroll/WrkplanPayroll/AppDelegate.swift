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
import Alamofire
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?  //---using for autoupdate
    
    var arrResNotification = [[String:Any]]()
    
    static var NotificationYN: Bool = false
    
    let userNotificationCenter = UNUserNotificationCenter.current() //---added on 10-Mar-2022
    let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
    lazy var swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)//---added on 10-Mar-2022

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
       
        //---using for autoupdate, code starts
//        window?.makeKeyAndVisible()
//        Siren.shared.wail()
        //---using for autoupdate, code ends
        
        hyperCriticalRulesAppForceUpdate() //--aded on 2021-Aug-02
        
        application.setMinimumBackgroundFetchInterval(10) //---added on 10-Mar-2022
        self.userNotificationCenter.delegate = self
        
        self.requestNotificationAuthorization()
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    func sendNotification(title: String, body: String) {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.badge = NSNumber(value: 3)
        
        // Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    //---added on 10-Mar-2022, code ends---
    //---added on 10-Mar-2022, code starts---
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        LoadNotificationData()
        
    }
    
    //-----function to get notifications data from api using Alamofire and SwiftyJson,(added on 09-Mar-2020) code starts----
    func LoadNotificationData(){
        let url = "\(BASE_URL)notification/custom/fetch/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("NotificationUrl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            //               self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log Notification description: \(swiftyJsonVar)")
                
                if !self.arrResNotification.isEmpty{
                    self.arrResNotification.removeAll()
                }
                
                if let resData = swiftyJsonVar["notifications"].arrayObject{
                    self.arrResNotification = resData as! [[String:AnyObject]]
                }
                if swiftyJsonVar["response"]["status"] == "true"{
                    print("Eureka")
                    if self.arrResNotification.count > 0 {
                        //Storing core data
                        //----code to insert data, starts---
//                        self.resetAllRecords(in: "UserNotification") //---commented on 11-Mar-2022
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let UserNotification = NSEntityDescription.insertNewObject(forEntityName: "UserNotification", into: context)
                        for items in self.arrResNotification{
                            UserNotification.setValue("\(self.swiftyJsonvar1["employee"]["employee_id"].stringValue)", forKey: "employeeid")
                            UserNotification.setValue("\(items)", forKey: "jsondata")
                            
                            var title: String = items["title"] as! String
                            
                            let body : String = items["body"] as! String
                            let fullbodyNotificationArr : [String] = body.components(separatedBy: "::")
                            var notificationId : String = fullbodyNotificationArr[0]
                            let fullbodyNotificationIdArray: [String] = notificationId.components(separatedBy: "=")
                            var notification_id_output : String = fullbodyNotificationIdArray[1]
                            
                            var event_name : String = fullbodyNotificationArr[1]
                            let fullbodyEventNameArray: [String] = event_name.components(separatedBy: "=")
                            var event_name_output : String = fullbodyEventNameArray[1]
                            
                            var event_id : String = fullbodyNotificationArr[2]
                            let fullbodyEventIdArray: [String] = event_id.components(separatedBy: "=")
                            var event_id_output : String = fullbodyEventIdArray[1]
                            
                            var event_owner : String = fullbodyNotificationArr[3]
                            let fullbodyEventOwnerArray: [String] = event_owner.components(separatedBy: "=")
                            var event_owner_output : String = fullbodyEventOwnerArray[1]
                            
                            var event_owner_id : String = fullbodyNotificationArr[4]
                            let fullbodyEventOwnerIdArray: [String] = event_owner_id.components(separatedBy: "=")
                            var event_owner_id_output : String = fullbodyEventOwnerIdArray[1]
                            
                            var message : String = fullbodyNotificationArr[5]
                            let fullbodyMessageArray: [String] = message.components(separatedBy: "=")
                            var message_output : String = fullbodyMessageArray[1]
                            
                            UserNotification.setValue("\(event_id_output)", forKey: "event_id")
                            UserNotification.setValue("\(event_name_output)", forKey: "event_name")
                            UserNotification.setValue("\(event_owner_output)", forKey: "event_owner")
                            UserNotification.setValue("\(event_owner_id_output)", forKey: "event_owner_id")
                            UserNotification.setValue("\(message_output)", forKey: "message")
                            UserNotification.setValue("\(title)", forKey: "title")
                            UserNotification.setValue("\(notification_id_output)", forKey: "notificationid")
                            UserNotification.setValue("N", forKey: "readyn")
                            do{
                               try context.save()
                                print("Saved")
                            }catch{
                                print("Error in saving data")
                            }
                        }
                       
                            
                            //---code to fetch data, starts
                            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotification")
                            request.returnsObjectsAsFaults = false
                            do{
                                let results = try context.fetch(request)
                                if results.count > 0
                                {
                                    for result in results as! [NSManagedObject]
                                    {
                                        if let jsonData = result.value(forKey: "jsondata") as? String{
                                            print("jsonNotificationData-=>", jsonData)
                                            
                                        }
                                       
                                        print("All results: ",result)
                                    }
                                          if let items = swiftyJsonVar["notifications"].array {
                                              for item in items {
                                                 /* if let title = item["title"].string {
                                                      print(title)
                                                  }*/
                                                  var title: String = item["title"].stringValue
                                                  let body : String = item["body"].stringValue
                                                  let fullbodyArr : [String] = body.components(separatedBy: "::")
                                                  
                                                  var message : String = fullbodyArr[5]
                                                  var fullMessageArr: [String] = message.components(separatedBy: "=")
                                                  var messageOutput : String = fullMessageArr[1]
                                                  
                                                  var event_id: String = fullbodyArr[0]
                                                  let fullbodyEventIdArray: [String] = event_id.components(separatedBy: "=")
                                                  var event_id_output : String = fullbodyEventIdArray[1]
                                                  print("Message-=>", messageOutput)
                                                  print("EventId-=>", event_id_output)
                                                  
                                                  self.sendNotification(title: title, body: messageOutput)
                                                  self.CustomNotificationUpdate(notificationId: Int(event_id_output)!)
                                              }
                                          }
                                    
                                    self.update(readyn: "N")
                                     }
                                   
//                            self.update(readyn: "N")
                            
                            
                        }catch{
                            //PROCESS ERROR
                        }
                        //----code to insert data, ends---
                    }
                }else if swiftyJsonVar["status"] == "false"{
                    print("false")
                }
                
            }
            
        }
    }
    func CustomNotificationUpdate(notificationId: Int){
        let url = "\(BASE_URL)notification/custom/update"
        
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "notification_id": notificationId
        ]
        
        print("SentData-=>",sentData)
        
        AF.request(url, method: .post, parameters: sentData, encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in
            switch response.result{
                
            case .success:
                //                        self.loaderEnd()
                let swiftyJsonVar = JSON(response.value!)
                print("Return notifictaion response: ", swiftyJsonVar)
                
                
                break
                
            case .failure(let error):
                //                        self.loaderEnd()
                print("Error: ", error)
            }
        }
        
    }
    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
            print("Database cleaned")
        }
        catch
        {
            print ("There was an error")
        }
    }
    func update(readyn:String){
        
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "UserNotification")
        
        // 3
        let predicate = NSPredicate(format: "%K == %@", "readyn", readyn)
        fetchRequest.predicate = predicate
        
        //3
        
        do {
            let  rs = try managedContext.fetch(fetchRequest)
            
            for result in rs as [NSManagedObject] {
                
                // update
                do {
                    var managedObject = rs[0]
                    managedObject.setValue("Y", forKey: "readyn")
                    
                    try managedContext.save()
                    print("update successfull")
                    
                    
                } catch let error as NSError {
                    print("Could not Update. \(error), \(error.userInfo)")
                }
                //end update
                
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //-----function to get notifications data from api using Alamofire and SwiftyJson,(added on 09-Mar-2020) code ends----
    
    //---added on 10-Mar-2022, code ends---
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


