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

class NotificationHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var NotificationHomeTableView: UITableView!
    var arrResNotification = [[String:Any]]()
    var jsondata: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.NotificationHomeTableView.delegate = self
        self.NotificationHomeTableView.dataSource = self
        
        
        fetchCoreData()

        // Do any additional setup after loading the view.
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
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    jsondata = result.value(forKey: "jsondata") as? String ?? ""
                    if (result.value(forKey: "jsondata") as? String) != nil{
//                        print("jsonNotificationData1-=>", jsonData)
                        
                        
                        
                        
                        let data = Data(jsondata.utf8)
                        let response = try JSON(data: data)
                      
                        let swiftyJsonVar=JSON(response)
                        if let resData = swiftyJsonVar["notifications"].arrayObject{
                            arrResNotification = resData as! [[String:AnyObject]]
                        }
                        print("jsonNotificationData1-=>", swiftyJsonVar)
                       print("Count-=>",arrResNotification.count)
                      
                        
                    }
                   
//                    print("All results1: ",result.toJSON()!)
                    
                    
                }
               
                /*let swiftyJsonVar=JSON(jsondata)
                if let resData = swiftyJsonVar["notifications"].arrayObject{
                    self.arrResNotification = resData as! [[String:AnyObject]]
                }
                print("jsonNotificationData1-=>", swiftyJsonVar)
                print("Count-=>",swiftyJsonVar["notifications"][0]["body"])*/
            }
        }catch{
            print("Error")
        }
    }
    

    //========tableview code starts=======
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResNotification.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationHlomeTableViewCell
//        rowIndex = indexPath.row
        
//        cell.delegate = self
        
        let dict = arrResNotification[indexPath.row]
        
        
        
        cell.LabelTitle.text = dict["title"] as? String
        
        let body : String = dict["body"] as! String
        let fullbodyArr : [String] = body.components(separatedBy: "::")
        
        var message : String = fullbodyArr[5]
        var fullMessageArr: [String] = message.components(separatedBy: "=")
        var messageOutput : String = fullMessageArr[1]
        
        cell.LabelMessage.text = messageOutput
        
        if dict["title"] as? String == "Leave Application"{
            cell.LabelEventId.text = "LA"
        }else if dict["title"] as? String == "OD Duty" {
            cell.LabelEventId.text = "OD"
        }
        
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
       /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            LtaListViewController.new_create_yn = false
            let row=arrRes[indexPath.row]
            print(row)
            print("tap is working")
           
            LtaListViewController.lta_no = row["lta_application_no"] as? String
            LtaListViewController.lta_status = row["lta_application_status"] as? String
            LtaListViewController.lta_id = row["lta_application_id"]?.intValue
            LtaListViewController.employee_id = row["employee_id"]?.intValue

            LtaListViewController.EmployeeType = "Employee"
            
            
            LtaListViewController.employee_name = row["employee_name"] as? String
           
            LtaListViewController.new_create_yn = false
            self.performSegue(withIdentifier: "ltarequest", sender: nil)
        }*/
        //---------onClick tableview code ends----------
    //========tableview code ends========
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
