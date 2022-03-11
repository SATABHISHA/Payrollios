//
//  NotificationHomeViewController.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 08/03/22.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class NotificationHomeViewController: UIViewController {

    @IBOutlet weak var NotificationHomeTableView: UITableView!
    var arrResNotification = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        fetchCoreData()

        // Do any additional setup after loading the view.
    }
    
    func fetchCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
//        let UserNotification = NSEntityDescription.insertNewObject(forEntityName: "UserNotification", into: context)
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
//                        print("jsonNotificationData1-=>", jsonData)
                        
                        let swiftyJsonVar=JSON(jsonData)
                        if let resData = swiftyJsonVar["notifications"].arrayObject{
                            self.arrResNotification = resData as! [[String:AnyObject]]
                        }
                        print("jsonNotificationData1-=>", swiftyJsonVar)
                        
                        
                    }
                   
                    print("All results1: ",result)
                    
                    
                }
            }
        }catch{
            print("Error")
        }
    }
    

}
