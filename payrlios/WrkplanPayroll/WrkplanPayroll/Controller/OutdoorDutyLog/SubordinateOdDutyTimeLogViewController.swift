//
//  SubordinateOdDutyTimeLogViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 05/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubordinateOdDutyTimeLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var NavBarLabelEmpName: UILabel!
    @IBOutlet weak var NavBarTimeLog: UILabel!
    @IBOutlet weak var tableViewTimeLog: UITableView!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var arrRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeStatusBarColor()
        
        // Do any additional setup after loading the view.
        self.tableViewTimeLog.delegate = self
        self.tableViewTimeLog.dataSource = self
        self.tableViewTimeLog.backgroundColor = UIColor(hexFromString: "ffffff")
        
        loadData()
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "subodlog", sender: nil)
    }
    
    //----------tableview code starts------------
//    var rowIndex: Int! // --for instant delete delaring the variable
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OutdoorDutyTimeLogTableViewCell
        
        let dict = arrRes[indexPath.row]
        
        //---code to format date, starts----
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss a"
        let showDate = inputFormatter.date(from: dict["log_datetime"] as? String ?? "")
        inputFormatter.dateFormat = "hh:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        //---code to format date, ends---
        
//        let date = dateFormatterGet.date(from: (dict["date"] as? String)!)
//                labelDate.text = eventData[i].date
//        cell.label_date.text = dateFormatterPrint.string(from: date!)
        
        cell.LabelLatitude.text = dict["latitude"] as? String
        cell.LabelLongitude.text = dict["longitude"] as? String
        cell.LabelAddress.numberOfLines = 0
        cell.LabelAddress.text = dict["location_address"] as? String
        cell.LabelTime.text = resultString
        cell.LabelStartStop.text = dict["log_action"] as? String
        
       
        return cell
        
    }
    
    
    //----------tableview code ends------------
    
    //---function to load data using Alamofire and Json Swifty, code starts-----
    func loadData(){
           loaderStart()
        
        //---code to format date, starts----
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        let showDate = inputFormatter.date(from: SubordinateOdDutyLogListViewController.Log_task_date!)
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        //---code to format date, ends---
        let url = "\(BASE_URL)od/log/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(SubordinateOdDutyLogListViewController.od_request_id!)/\(resultString)/"
        print("odDutyEmpTaskurl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log Emp description: \(swiftyJsonVar)")
                if let resData = swiftyJsonVar["items"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                self.NavBarLabelEmpName.text = swiftyJsonVar["employee_name"].stringValue
                self.NavBarTimeLog.text = "Time Log of \(swiftyJsonVar["od_duty_log_date"].stringValue)"
                if self.arrRes.count>0 {
                 self.tableViewTimeLog.reloadData()
                }else{
                    self.tableViewTimeLog.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewTimeLog.bounds.size.width, height: self.tableViewTimeLog.bounds.size.height))
                    noDataLabel.text          = "No Log(s) available"
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tableViewTimeLog.backgroundView  = noDataLabel
                    self.tableViewTimeLog.separatorStyle  = .none
                    
                }
               }
           }
    }
    //---function to load data using Alamofire and Json Swifty, code ends-----
    
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
    
    // ====================== Blur Effect function calling code starts ================= \\
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.7
        view.addSubview(blurEffectView)
        // screen roted and size resize automatic
        blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        
    }
    func canelBlurEffect() {
        self.blurEffectView.removeFromSuperview();
    }
    // ====================== Blur Effect function calling code ends =================

}
