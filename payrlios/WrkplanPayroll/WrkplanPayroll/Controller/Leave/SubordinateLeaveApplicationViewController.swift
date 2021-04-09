//
//  SubordinateLeaveApplicationViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 09/04/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class SubordinateLeaveApplicationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TableViewSubordinateLeave: UITableView!
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    static var leave_status: String!, employee_name: String!, supervisor_remark: String!, leave_name: String!, description: String!, to_date: String!, from_date: String!, final_approved_by: String!, appliction_code: String!, approved_by: String!, approved_date: String!
    
    static var supervisor1_id: Int!, total_days: Int!, approved_level: Int!, supervisor2_id: Int!, appliction_id: Int!, approved_by_id: Int!, employee_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.TableViewSubordinateLeave.delegate = self
        self.TableViewSubordinateLeave.dataSource = self
        TableViewSubordinateLeave.backgroundColor = UIColor(hexFromString: "ffffff")
        loadData()
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "leave", sender: self)
        print("tapped")
    }
    
    //--------tableview code starts------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateLeaveApplicationTableViewCell
        
        let dict = arrRes[indexPath.row]
        
        cell.LabelName.text = dict["employee_name"] as? String
        cell.LabelApplicationCode.text = dict["appliction_code"] as? String
        cell.LabelDate.text = "\(String(describing: dict["from_date"] as! String)) to \(String(describing: dict["to_date"] as! String))"
        cell.LabelDayCount.text = String(dict["total_days"] as! Int)
        cell.LabelLeaveType.text = dict["leave_name"] as? String
        cell.LabelLeaveStatus.text = dict["leave_status"] as? String
        
        if dict["leave_status"]as? String == "Canceled" {
            cell.LabelLeaveStatus.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["leave_status"]as? String == "Return" {
            cell.LabelLeaveStatus.textColor = UIColor(hexFromString: "b04d0b")
        }else if dict["leave_status"]as? String == "Save" {
            cell.LabelLeaveStatus.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["leave_status"]as? String == "Submit" {
            cell.LabelLeaveStatus.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["leave_status"] as? String == "Approved" {
            cell.LabelLeaveStatus.textColor = UIColor(hexFromString: "1e9547")
        }
        
        return cell
    }
    
    //---------onClick tableview code starts----------
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
//            OutDoorDutyListViewController.new_create_yn = false
            let row=arrRes[indexPath.row]
            print(row)
            print("tap is working")
            
            SubordinateLeaveApplicationViewController.leave_status = row["leave_status"] as? String
            SubordinateLeaveApplicationViewController.employee_name = row["employee_name"] as? String
            SubordinateLeaveApplicationViewController.supervisor_remark = row["supervisor_remark"] as? String
            SubordinateLeaveApplicationViewController.leave_name = row["leave_name"] as? String
            SubordinateLeaveApplicationViewController.description = row["description"] as? String
            SubordinateLeaveApplicationViewController.total_days = row["total_days"] as? Int
            SubordinateLeaveApplicationViewController.to_date = row["to_date"] as? String
            SubordinateLeaveApplicationViewController.supervisor1_id = row["supervisor1_id"] as? Int
            SubordinateLeaveApplicationViewController.from_date = row["from_date"] as? String
            SubordinateLeaveApplicationViewController.final_approved_by = row["final_approved_by"] as? String
            SubordinateLeaveApplicationViewController.appliction_code = row["appliction_code"] as? String
            SubordinateLeaveApplicationViewController.approved_by = row["approved_by"] as? String
            SubordinateLeaveApplicationViewController.approved_level = row["approved_level"] as? Int
            SubordinateLeaveApplicationViewController.supervisor2_id = row["supervisor2_id"] as? Int
            SubordinateLeaveApplicationViewController.appliction_id = row["appliction_id"] as? Int
            SubordinateLeaveApplicationViewController.approved_date = row["approved_date"] as? String
            SubordinateLeaveApplicationViewController.approved_by_id = row["approved_by_id"] as? Int
            SubordinateLeaveApplicationViewController.employee_id = row["employee_id"] as? Int
           
//            print("empname-=>",row["employee_name"] as? String)
//            OutDoorDutyListViewController.supervisor_od_request_id = row["od_request_id"]?.stringValue
//            SubordinateOutdoorDutyRequestListViewController.supervisor_employee_id = row["employee_id"]?.stringValue
           
//            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
//            print("test-=>",row["od_request_id"]?.stringValue)
            self.performSegue(withIdentifier: "subleaverqst", sender: self)
        }
        //---------onClick tableview code ends----------
    //--------tableview code ends------
    
    //--------function to show leave details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        
        let url = "\(BASE_URL)leave/application/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/2/\(swiftyJsonvar1["user"]["user_id"].stringValue)/"
        print("odDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["application_list"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.TableViewSubordinateLeave.reloadData()
                   }else{
                       self.TableViewSubordinateLeave.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewSubordinateLeave.bounds.size.width, height: self.TableViewSubordinateLeave.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewSubordinateLeave.backgroundView  = noDataLabel
                       self.TableViewSubordinateLeave.separatorStyle  = .none
                       
                   }
               }
               
           }
       }
       //--------function to show leave details using Alamofire and Json Swifty code ends------------
    
    // ====================== Blur Effect Defiend START ================= \\
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        var blurEffectView: UIVisualEffectView!
        var loader: UIVisualEffectView!
        func loaderStart() {
            // ====================== Blur Effect START ================= \\
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            loader = UIVisualEffectView(effect: blurEffect)
            loader.frame = view.bounds
            loader.alpha = 2
            view.addSubview(loader)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
            let transform: CGAffineTransform = CGAffineTransform(scaleX: 2, y: 2)
            activityIndicator.transform = transform
            loadingIndicator.center = self.view.center;
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.white
            loadingIndicator.startAnimating();
            loader.contentView.addSubview(loadingIndicator)
            
            // screen roted and size resize automatic
            loader.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
            
            // ====================== Blur Effect END ================= \\
        }
        
        func loaderEnd() {
            self.loader.removeFromSuperview();
        }
        // ====================== Blur Effect Defiend END ================= \\
        
        // ====================== Blur Effect START ================= \\
        func blurEffect() {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.alpha = 0.9
            view.addSubview(blurEffectView)
            // screen roted and size resize automatic
            blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
          
        }
        func canelBlurEffect() {
            self.blurEffectView.removeFromSuperview();
        }
        // ====================== Blur Effect END ================= \\

}
