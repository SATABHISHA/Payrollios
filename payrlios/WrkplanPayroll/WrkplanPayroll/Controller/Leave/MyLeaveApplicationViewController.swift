//
//  MyLeaveApplicationViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyLeaveApplicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableViewLeaveApplication: UITableView!
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    static var new_create_yn: Bool = false
    
    static var leave_status: String!, employee_name: String!, supervisor_remark: String!, leave_name: String!, description: String!, to_date: String!, from_date: String!, final_approved_by: String!, appliction_code: String!, approved_by: String!, approved_date: String!
    
    static var supervisor1_id: Int!, total_days: Int!, approved_level: Int!, supervisor2_id: Int!, appliction_id: Int!, approved_by_id: Int!, employee_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        // Do any additional setup after loading the view.
        
        self.TableViewLeaveApplication.delegate = self
        self.TableViewLeaveApplication.dataSource = self
        TableViewLeaveApplication.backgroundColor = UIColor(hexFromString: "ffffff")
        
        self.TableViewLeaveApplication.borderWidth = 0.8
        self.TableViewLeaveApplication.borderColor = UIColor(hexFromString: "CBCBCB")
        self.TableViewLeaveApplication.cornerRadius = 10
        loadData()
    }
    
    
    @IBAction func BtnNew(_ sender: Any) {
        MyLeaveApplicationViewController.new_create_yn = true
        self.performSegue(withIdentifier: "myleaverqst", sender: self)
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "leave", sender: self)
    }
    
    //--------tableview code starts------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyLeaveApplicationTableViewCell
        
        let dict = arrRes[indexPath.row]
        cell.LabelApplicationCode.text = dict["appliction_code"] as? String
        cell.LabelDate.text = "\(String(describing: dict["from_date"] as! String)) to \(String(describing: dict["to_date"] as! String))"
        cell.LabelHours.text = "\(String(dict["total_days"] as! Int)) Hour(s)"
        
        if let totalDays = dict["total_days"] as? Int {
            let floatDays = Float(totalDays) / 8.0
            let formattedDays: String
            
            if floatDays.truncatingRemainder(dividingBy: 1) == 0 {
                formattedDays = String(format: "%.0f", floatDays) // No decimal if it's zero
            } else {
                formattedDays = String(format: "%.2f", floatDays)
            }
            
            cell.LabelDayCount.text = "(\(formattedDays) Day(s))"
        }
//        cell.LabelDayCount.text = "(\(String((dict["total_days"] as! Int)/8)) Day(s))"
        cell.LabelLeaveType.text = dict["leave_name"] as? String
        cell.LabelStatus.text = dict["leave_status"] as? String
        
        if dict["leave_status"]as? String == "Canceled" {
//            cell.LabelStatus.textColor = UIColor(hexFromString: "ed1c24")
            cell.LabelStatus.backgroundColor = UIColor(hexFromString: "ed1c24")
        }else if dict["leave_status"]as? String == "Return" {
//            cell.LabelStatus.textColor = UIColor(hexFromString: "b04d0b")
            cell.LabelStatus.backgroundColor = UIColor(hexFromString: "b04d0b")
        }else if dict["leave_status"]as? String == "Save" {
//            cell.LabelStatus.textColor = UIColor(hexFromString: "2196ed")
            cell.LabelStatus.backgroundColor = UIColor(hexFromString: "2196ed")
        }else if dict["leave_status"]as? String == "Submit" {
//            cell.LabelStatus.textColor = UIColor(hexFromString: "fe52ce")
            cell.LabelStatus.backgroundColor = UIColor(hexFromString: "fe52ce")
        }else if dict["leave_status"]as? String == "Approved" {
//            cell.LabelStatus.textColor = UIColor(hexFromString: "1e9547")
            cell.LabelStatus.backgroundColor = UIColor(hexFromString: "FDD835")
        }
        
        return cell
    }
    //--------tableview code ends------
    //--------function to show leave details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        
        let url = "\(BASE_URL)leave/application/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1/\(swiftyJsonvar1["user"]["user_id"].stringValue)/"
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
                    self.TableViewLeaveApplication.reloadData()
                }else{
                    self.TableViewLeaveApplication.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewLeaveApplication.bounds.size.width, height: self.TableViewLeaveApplication.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.TableViewLeaveApplication.backgroundView  = noDataLabel
                    self.TableViewLeaveApplication.separatorStyle  = .none
                    
                }
            }
            
        }
    }
    //---------onClick tableview code starts----------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //            OutDoorDutyListViewController.new_create_yn = false
        let row=arrRes[indexPath.row]
        print(row)
        print("tap is working")
        
        MyLeaveApplicationViewController.leave_status = row["leave_status"] as? String
        MyLeaveApplicationViewController.employee_name = row["employee_name"] as? String
        MyLeaveApplicationViewController.supervisor_remark = row["supervisor_remark"] as? String
        MyLeaveApplicationViewController.leave_name = row["leave_name"] as? String
        MyLeaveApplicationViewController.description = row["description"] as? String
        MyLeaveApplicationViewController.total_days = row["total_days"] as? Int
        MyLeaveApplicationViewController.to_date = row["to_date"] as? String
        MyLeaveApplicationViewController.supervisor1_id = row["supervisor1_id"] as? Int
        MyLeaveApplicationViewController.from_date = row["from_date"] as? String
        MyLeaveApplicationViewController.final_approved_by = row["final_approved_by"] as? String
        MyLeaveApplicationViewController.appliction_code = row["appliction_code"] as? String
        MyLeaveApplicationViewController.approved_by = row["approved_by"] as? String
        MyLeaveApplicationViewController.approved_level = row["approved_level"] as? Int
        MyLeaveApplicationViewController.supervisor2_id = row["supervisor2_id"] as? Int
        MyLeaveApplicationViewController.appliction_id = row["appliction_id"] as? Int
        MyLeaveApplicationViewController.approved_date = row["approved_date"] as? String
        MyLeaveApplicationViewController.approved_by_id = row["approved_by_id"] as? Int
        MyLeaveApplicationViewController.employee_id = row["employee_id"] as? Int
        
        //            print("empname-=>",row["employee_name"] as? String)
        //            OutDoorDutyListViewController.supervisor_od_request_id = row["od_request_id"]?.stringValue
        //            SubordinateOutdoorDutyRequestListViewController.supervisor_employee_id = row["employee_id"]?.stringValue
        
        //            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
        //            print("test-=>",row["od_request_id"]?.stringValue)
        MyLeaveApplicationViewController.new_create_yn = false
        self.performSegue(withIdentifier: "myleaverqst", sender: self)
    }
    //---------onClick tableview code ends----------
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
