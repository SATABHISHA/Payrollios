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
                   /* if let jsonData = result.value(forKey: "jsondata") as? String{
//                        print("jsonNotificationData1-=>", jsonData)
                        
                        let swiftyJsonVar=JSON(jsonData)
                        if let resData = swiftyJsonVar["notifications"].arrayObject{
                            NotificationHomeViewController.arrResNotification = resData as! [[String:AnyObject]]
                        }
                        print("jsonNotificationData1-=>", swiftyJsonVar)
                        
                        
                    }*/
                   
                    print("All results1: ",result)
                    
                    
                }
                let swiftyJsonVar=JSON(jsondata)
                if let resData = swiftyJsonVar["notifications"].arrayObject{
                    arrResNotification = resData as! [[String:AnyObject]]
                }
                print("jsonNotificationData1-=>", swiftyJsonVar)
                print("Count-=>",arrResNotification.count)
            }
        }catch{
            print("Error")
        }
    }
    

    //========tableview code starts=======
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrResNotification.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationHlomeTableViewCell
//        rowIndex = indexPath.row
        
//        cell.delegate = self
        
//        let dict = arrResNotification[indexPath.row]
        
        
        
//        cell.LabelTitle.text = dict["title"] as? String
        
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
}
