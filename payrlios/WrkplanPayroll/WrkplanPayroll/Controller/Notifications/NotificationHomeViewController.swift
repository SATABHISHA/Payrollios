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


struct NotificationDetails{
    var employeeid: String!
    var event_id: String!
    var event_name: String!
    var event_owner: String!
    var event_owner_id: String!
    var jsondata: String!
    var message: String!
    var notificationid: String!
    var readyn: String!
    var title: String!
}

class NotificationHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var NotificationHomeTableView: UITableView!
    var arrResNotification = [[String:Any]]()
    var jsondata: String = ""
    var tableNotificationData = [NotificationDetails]()
//    static var event_id: String!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.NotificationHomeTableView.delegate = self
        self.NotificationHomeTableView.dataSource = self
        
        NotificationHomeTableView.backgroundColor = UIColor.white
        
        if UIScreen.main.bounds.size.width < 768 { //IPHONE
            NotificationHomeTableView.rowHeight = 100;
            NotificationHomeTableView.rowHeight = UITableView.automaticDimension
            NotificationHomeTableView.estimatedRowHeight = 130
        } else { //IPAD
            NotificationHomeTableView.rowHeight = 127;
            NotificationHomeTableView.rowHeight = UITableView.automaticDimension
            NotificationHomeTableView.estimatedRowHeight = 150
        }
        
        fetchCoreData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "dashboard", sender: nil)
    }
    func fetchCoreData(){
       /* if !arrResNotification.isEmpty {
            arrResNotification.removeAll()
        }*/
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
//        let UserNotification = NSEntityDescription.insertNewObject(forEntityName: "UserNotification", into: context)
        //---code to fetch data, starts
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotification")
        request.predicate = NSPredicate(format: "employeeid == %@", swiftyJsonvar1["employee"]["employee_id"].stringValue)
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    jsondata = result.value(forKey: "jsondata") as? String ?? ""
                    print("TestingArray-=>", jsondata)
                    
                    var data = NotificationDetails()
                    data.employeeid = result.value(forKey: "employeeid") as? String ?? ""
                    data.event_id = result.value(forKey: "event_id") as? String ?? ""
                    data.event_name = result.value(forKey: "event_name") as? String ?? ""
                    data.event_owner = result.value(forKey: "event_owner") as? String ?? ""
                    data.event_owner_id = result.value(forKey: "event_owner_id") as? String ?? ""
                    data.jsondata = result.value(forKey: "jsondata") as? String ?? ""
                    data.message = result.value(forKey: "message") as? String ?? ""
                    data.notificationid = result.value(forKey: "notificationid") as? String ?? ""
                    data.readyn = result.value(forKey: "readyn") as? String ?? ""
                    data.title = result.value(forKey: "title") as? String ?? ""
                    
                    tableNotificationData.append(data)
                    
                }
                
                
                if tableNotificationData.count>0 {
                    NotificationHomeTableView.reloadData()
                }else{
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.NotificationHomeTableView.bounds.size.width, height: self.NotificationHomeTableView.bounds.size.height))
                    noDataLabel.text          = "No Data to show"
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.NotificationHomeTableView.backgroundView  = noDataLabel
                    self.NotificationHomeTableView.separatorStyle  = .none
                }
               
               
            }
        }catch{
            print("Error")
        }
    }
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {

            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
                if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return jsonString as String
                }
                
            } catch let error as NSError {
                print("Array convertIntoJSON - \(error.description)")
            }
            return nil
        }
    //========tableview code starts=======
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNotificationData.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationHlomeTableViewCell
//        rowIndex = indexPath.row
        
//        cell.delegate = self
        var dict1 = tableNotificationData[indexPath.row]
        cell.LabelTitle.text = dict1.message
        
        if dict1.title == "Leave Application"{
            cell.LabelEventId.text = "LA"
        }else if dict1.title == "OD Application" {
            cell.LabelEventId.text = "OD"
        }
        
       
        print("Messaage-=>", dict1.message)
        
        
        return cell
    }
    
   /* func LtaListTableViewCellRemoveDidTapAddOrView(_ sender: LtaListTableViewCell) {
        guard let tappedIndexPath = TableViewLtaRequisitionList.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        let body = "Do you really want to delete this record \(rowData["lta_application_no"] as! String)?"
        let  lta_application_id = rowData["lta_application_id"] as? Int
        LtaListViewController.lta_id = rowData["lta_application_id"] as? Int
        print("Selected-=>",lta_application_id!)
        print("Selected")
        openDeletePopup(body: body)
    }*/
    
    //---------onClick tableview code starts----------
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let row = tableNotificationData[indexPath.row]
           
            if row.title == "Leave Application"{
                DashboardViewController.event_id = row.event_id
                DashboardViewController.NotificationPendingItemsYN = true
//                self.performSegue(withIdentifier: "subleaveappltn", sender: nil)
                self.performSegue(withIdentifier: "la", sender: nil)
            }else if row.title == "OD Application" {
                DashboardViewController.event_id = row.event_id
                DashboardViewController.NotificationPendingItemsYN = true
                self.performSegue(withIdentifier: "od", sender: nil)
            }
            
        }
        //---------onClick tableview code ends----------
    
    //-----swipe delete code starts-----
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            var dict1 = tableNotificationData[indexPath.row]
            print("notificationis-=>", dict1.notificationid!)
            if deleteNotification(notificationid: dict1.notificationid!) == true {
//                NotificationHomeTableView.reloadData()
                print("result-=>","success")
                
                //---code to get instatnt updates from row, starts---
                NotificationHomeTableView.beginUpdates()
                tableNotificationData.remove(at: indexPath.row)
                NotificationHomeTableView.deleteRows(at: [indexPath], with: .none)
                NotificationHomeTableView.endUpdates()
                //---code to get instatnt updates from row, ends---
            }
            
            
        }
    }
    //-----swipe delete code ends------
    //========tableview code ends========
    
    //=====function to delete row from coredata, starts=======
    func deleteNotification(notificationid: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //---code to fetch data, starts
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotification")
        fetchRequest.predicate = NSPredicate(format: "notificationid = %@", "\(notificationid)")
        var status: Bool?
        do
        {

            let results = try context.fetch(fetchRequest)
            for entity in results {

                context.delete(entity as! NSManagedObject)
                try context.save()
                status = true
            }
        }
        catch _ {
            print("Could not delete")
            status = false

        }
        
        return status!
    }
    //=====function to delete row from coredata, ends=======
};
extension NSManagedObject {
  func toJSON() -> String? {
    let keys = Array(self.entity.attributesByName.keys)
    let dict = self.dictionaryWithValues(forKeys: keys)
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        return reqJSONStr
    }
    catch{}
    return nil
  }
}
