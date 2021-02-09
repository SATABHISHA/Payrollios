//
//  SubordinateLogViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON

struct SubordinateDetails {
    var employee_name:String!
    var slno:Int!
}
class SubordinateLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var designablebtn_subordinate_monthly_attendance_log: DesignableButton!
    @IBOutlet weak var designablebtn_label_subordinate_monthly_attendance_log: UILabel!
    @IBOutlet weak var tableviewSubordinateLog: UITableView!
    @IBOutlet weak var label_date: UILabel!
    
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    static var subordinate_details = [SubordinateDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableviewSubordinateLog.delegate = self
        self.tableviewSubordinateLog.dataSource = self
        // Do any additional setup after loading the view.
        loadData()
        
        //SubordinateMonthlyAttendanceLog OnClick
        let tapGestureRecognizerSubordinateMonthlyAttendanceLogDesignablebtn = UITapGestureRecognizer(target: self, action: #selector(DesignablebtnSubordinateMonthlyAttendanceLog(tapGestureRecognizer:)))
        designablebtn_subordinate_monthly_attendance_log.isUserInteractionEnabled = true
        designablebtn_subordinate_monthly_attendance_log.addGestureRecognizer(tapGestureRecognizerSubordinateMonthlyAttendanceLogDesignablebtn)
        
        //LabelSubordinateMonthlyAttendanceLog OnClick
        let tapGestureRecognizerLabelSubordinateMonthlyAttendanceLogDesignablebtn = UITapGestureRecognizer(target: self, action: #selector(DesignablebtnLabelSubordinateMonthlyAttendanceLog(tapGestureRecognizer:)))
        designablebtn_label_subordinate_monthly_attendance_log.isUserInteractionEnabled = true
        designablebtn_label_subordinate_monthly_attendance_log.addGestureRecognizer(tapGestureRecognizerLabelSubordinateMonthlyAttendanceLogDesignablebtn)
        
        
    }
    
    //---SubordinateMonthlyAttendanceLog OnClick
    @objc func DesignablebtnSubordinateMonthlyAttendanceLog(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "submyattendance", sender: nil)
//        print("details-=>",SubordinateLogViewController.subordinate_details)
        /*for i in 0..<subordinate_details.count{
            print("empname-=>",subordinate_details[i].employee_name!)
        }*/
    }
    
    //---LabelSubordinateMonthlyAttendanceLog OnClick
    @objc func DesignablebtnLabelSubordinateMonthlyAttendanceLog(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "submyattendance", sender: nil)
//        print("details-=>",SubordinateLogViewController.subordinate_details)
        for i in 0..<SubordinateLogViewController.subordinate_details.count{
//            print("empname-=>",SubordinateLogViewController.subordinate_details[i].employee_name!)
        }
    }
    
    
    //---------tableview code starts---------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateLogTableViewCell
        
        let dict = arrRes[indexPath.row]
        
      /*  let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        let date = dateFormatterGet.date(from: (dict["date"] as? String)!) */
//                labelDate.text = eventData[i].date
//        cell.label_date.text = dateFormatterPrint.string(from: date!)
        cell.label_emp_name.text = dict["employee_name"] as? String
        
        cell.label_timein.text = dict["time_in"] as? String
        cell.label_timeout.text = dict["time_out"] as? String
        cell.label_status.text = dict["status"] as? String
//        cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)
        
        
        if dict["status"] as! String == "Absent"{
            cell.label_status.isHidden = false
            cell.label_status.backgroundColor = UIColor(hexFromString: "#FF0000")
        }else if dict["status"] as! String == "Present" {
            cell.label_status.isHidden = false
            cell.label_status.backgroundColor = UIColor(hexFromString: "#00FF00")
        }else{
            cell.label_status.isHidden = true
        }
        return cell
    }
    //---------tableview code ends---------
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        if !SubordinateLogViewController.subordinate_details.isEmpty{
            SubordinateLogViewController.subordinate_details.removeAll(keepingCapacity: true)
        }
        
        let url = "\(BASE_URL)timesheet/log/subordinate/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)"
//        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                   if let resData = swiftyJsonVar["subordinate_logs"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                for(key,value) in swiftyJsonVar["subordinate_logs"]{
                    var k = SubordinateDetails()
                    k.employee_name = value["employee_name"].stringValue
                    k.slno = value["slno"].intValue
                    SubordinateLogViewController.subordinate_details.append(k)
                }
                   if self.arrRes.count>0 {
                    self.tableviewSubordinateLog.reloadData()
                   }else{
                       self.tableviewSubordinateLog.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewSubordinateLog.bounds.size.width, height: self.tableviewSubordinateLog.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.tableviewSubordinateLog.backgroundView  = noDataLabel
                       self.tableviewSubordinateLog.separatorStyle  = .none
                       
                   }
               }
               
           }
       }
       //--------function to show log details using Alamofire and Json Swifty code ends------------
    
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
