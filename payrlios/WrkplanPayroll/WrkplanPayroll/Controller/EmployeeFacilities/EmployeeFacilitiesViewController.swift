//
//  EmployeeFacilitiesViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 26/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class EmployeeFacilitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var tableViewEmployeeFacilities: UITableView!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    var arrRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.tableViewEmployeeFacilities.delegate = self
        self.tableViewEmployeeFacilities.dataSource = self
        
        tableViewEmployeeFacilities.backgroundColor = UIColor(hexFromString: "ffffff")

        // Do any additional setup after loading the view.
        loadData()
    }
    
    
    @IBAction func btn_home(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    
    //--------function to show goal details using Alamofire and Json Swifty------------
        func loadData(){
//            loaderStart()
            let url = "\(BASE_URL)facilities/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)"
            AF.request(url).responseJSON{ (responseData) -> Void in
//                self.loaderEnd()
                if((responseData.value) != nil){
                    let swiftyJsonVar=JSON(responseData.value!)
                    print("details: \(swiftyJsonVar)")
                    if let resData = swiftyJsonVar["facilities"].arrayObject{
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if self.arrRes.count>0 {
                        self.tableViewEmployeeFacilities.reloadData()
                    }else{
                        self.tableViewEmployeeFacilities.reloadData()
                        //                    Toast(text: "No data", duration: Delay.short).show()
                        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewEmployeeFacilities.bounds.size.width, height: self.tableViewEmployeeFacilities.bounds.size.height))
                        noDataLabel.text          = "No record found"
                        noDataLabel.font = UIFont.systemFont(ofSize: 14)
                        noDataLabel.textColor     = UIColor(hexFromString: "767575")
                        noDataLabel.textAlignment = .center
                        self.tableViewEmployeeFacilities.backgroundView  = noDataLabel
                        self.tableViewEmployeeFacilities.separatorStyle  = .none
                        
                    }
                }
                
            }
        }
        //--------function to show goal details using Alamofire and Json Swifty code ends------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeeFacilitiesTableViewCell
//        cell.delegate = self
        let dict = arrRes[indexPath.row]
        cell.label_employee_service_type.text = dict["service_type"] as? String
        cell.label_employee_value.text = "₹\(dict["value"]?.stringValue ?? "")"
        
        return cell
    }

}
