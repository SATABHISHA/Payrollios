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
class SubordinateLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SubordinateLogTableViewCellDelegate {
    
    @IBOutlet weak var designablebtn_subordinate_monthly_attendance_log: DesignableButton!
    @IBOutlet weak var designablebtn_label_subordinate_monthly_attendance_log: UILabel!
    @IBOutlet weak var tableviewSubordinateLog: UITableView!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var stackViewTableHeader: UIStackView!
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    static var subordinate_details = [SubordinateDetails]()
    
    //--variables for tableview-=>popup, added on 07-Jun-2021
    static var Log_employee_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        //---TableView header/footer customization, code starts
        self.stackViewTableHeader.clipsToBounds = true
        self.stackViewTableHeader.layer.cornerRadius = 10
        self.stackViewTableHeader.backgroundColor = UIColor(hexFromString: "CBCBCB")
        self.stackViewTableHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.stackViewTableHeader.layer.shadowColor = UIColor.gray.cgColor
        self.stackViewTableHeader.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.stackViewTableHeader.layer.shadowOpacity = 3
        self.stackViewTableHeader.layer.shadowRadius = 3.0
        //---TableView header/footer customization, code ends
        
        //-----code to get current date and show date in the label, starts-----
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        label_date.text = formatter.string(from: date)
        //-----code to get current date and show date in the label, starts-----
        
        self.tableviewSubordinateLog.delegate = self
        self.tableviewSubordinateLog.dataSource = self
        tableviewSubordinateLog.backgroundColor = UIColor(hexFromString: "ffffff")
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
        
        //LocationDetails OK Popup
        let tapGestureRecognizerLocationDetailsOk = UITapGestureRecognizer(target: self, action: #selector(LocationDetailsPopupOk(tapGestureRecognizer:)))
        custom_btn_ok_location_details_popup.isUserInteractionEnabled = true
        custom_btn_ok_location_details_popup.addGestureRecognizer(tapGestureRecognizerLocationDetailsOk)
        
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "timesheet", sender: nil)
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
    func SubordinateLogTableViewCellDidTapView(_ sender: SubordinateLogTableViewCell) {
        guard let tappedIndexPath = tableviewSubordinateLog.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        
        SubordinateLogViewController.Log_employee_id = rowData["employee_id"] as? Int
        loadPopupLocationData(Log_employee_id: SubordinateLogViewController.Log_employee_id!)
        //        OutdoorDutyLogListViewController.Log_task_employee_name = rowData["employee_name"] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateLogTableViewCell
        
        let dict = arrRes[indexPath.row]
        cell.delegate = self
        
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
        cell.label_status.layer.masksToBounds = true
        cell.img_sub_log_arrow.isHidden = true
        
        if dict["status"] as! String == "Absent"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#ffffff")
            cell.label_status.backgroundColor = UIColor(hexFromString: "#fb4e4e")
            cell.label_status.cornerRadius = 5
        }else if dict["status"] as! String == "Present" {
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#6E6E6E")
            cell.label_status.backgroundColor = UIColor(hexFromString: "#9fdd55")
            cell.label_status.cornerRadius = 5
            if swiftyJsonvar1["company"]["attendance_with_selfie_yn"].intValue == 1 {
                cell.img_sub_log_arrow.isHidden = false
            }else{
                cell.img_sub_log_arrow.isHidden = true
            }
        }else if dict["status"] as! String == "Present(WFH)"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#ffffff")
            cell.label_status.backgroundColor = UIColor(hexFromString: "#9fdd55")
            cell.label_status.cornerRadius = 5
            if swiftyJsonvar1["company"]["attendance_with_selfie_yn"].intValue == 1 {
                cell.img_sub_log_arrow.isHidden = false
            }else{
                cell.img_sub_log_arrow.isHidden = true
            }
        }else if dict["status"] as! String == "WFH"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#ffffff")
            cell.label_status.backgroundColor = UIColor(hexFromString: "#9fdd55")
            cell.label_status.cornerRadius = 5
            if swiftyJsonvar1["company"]["attendance_with_selfie_yn"].intValue == 1 {
                cell.img_sub_log_arrow.isHidden = false
            }else{
                cell.img_sub_log_arrow.isHidden = true
            }
        }else{
            cell.label_status.isHidden = true
            cell.label_status.backgroundColor = UIColor(hexFromString: "#ffffff")
            cell.label_status.cornerRadius = 5
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
        print("LogSubordinateUrl-=>",url)
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
//                    k.slno = value["slno"].intValue
                    k.slno = value["employee_id"].intValue
                    SubordinateLogViewController.subordinate_details.append(k)
                }
                if self.arrRes.count>0 {
                    self.tableviewSubordinateLog.reloadData()
                }else{
                    self.tableviewSubordinateLog.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewSubordinateLog.bounds.size.width, height: self.tableviewSubordinateLog.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.tableviewSubordinateLog.backgroundView  = noDataLabel
                    self.tableviewSubordinateLog.separatorStyle  = .none
                    
                }
            }
            
        }
    }
    //--------function to show log details using Alamofire and Json Swifty code ends------------
    //=====added on 07-Jun-2021, starts
    //============================-Form Location Details dialog, code starts============================
    @IBOutlet var viewLatLongDetailsPopup: UIView!
    
    
    @IBOutlet weak var custom_btn_ok_location_details_popup: UIView!
    
    @IBOutlet weak var PopupEmpName: UILabel!
    
    @IBOutlet weak var PopupEmpCode: UILabel!
    
    @IBOutlet weak var PopupAttendanceDate: UILabel!
    
    @IBOutlet weak var PopupInTime: UILabel!
    
    @IBOutlet weak var PopupInLatitude: UILabel!
    @IBOutlet weak var PopupInLongitude: UILabel!
    @IBOutlet weak var PopupInAddress: UILabel!
    
    @IBOutlet weak var PopupInImageView: UIImageView!
    
    @IBOutlet weak var PopupOutLatitude: UILabel!
    @IBOutlet weak var PopupOutLongitude: UILabel!
    
    @IBOutlet weak var PopupAddressOut: UILabel!
    @IBOutlet weak var PopupOutImageView: UIImageView!
    
    @IBOutlet weak var PopupOutTime: UILabel!
    
    @IBOutlet weak var PopupTitleOutLatitude: UILabel!
    @IBOutlet weak var PopupTitleOutLongitude: UILabel!
    @IBOutlet weak var PopupViewOut: UIView!
    @IBOutlet weak var PopupLabelOut: UILabel!
    @IBOutlet weak var PopupLabelStatus: UILabel!
    //---Location Details PopupOk
    @objc func LocationDetailsPopupOk(tapGestureRecognizer: UITapGestureRecognizer){
        cancelLatLongDetailsPopup()
    }
    let screenSize = UIScreen.main.bounds
    let screenWidth = UIScreen.main.bounds.width
    func OpenLatLongDetailsPopup(employee_name: String!,employee_code: String!, attendance_date: String!, in_time: String!, in_latitude: String!, in_longitude: String!, in_address: String!, out_time: String!, out_latitude: String!, out_longitude: String!, out_address: String!, in_image_base_64: String!, out_image_base_64: String!){
        blurEffect()
        
        print("screenwidthtesting-=>", screenWidth)
        //        self.viewLatLongDetailsPopup.frame.size.width = UIScreen.main.bounds.size.width - 40
        
        print("viewTesting-=>", view.frame.size.width)
        self.view.addSubview(viewLatLongDetailsPopup)
        
        viewLatLongDetailsPopup.layer.masksToBounds = true
        viewLatLongDetailsPopup.frame.size.width = screenWidth - 40
        //        self.viewLatLongDetailsPopup.frame.size.height = 451
        //        self.viewLatLongDetailsPopup.frame.size.width = 300
        viewLatLongDetailsPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewLatLongDetailsPopup.center = self.view.center
        viewLatLongDetailsPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewLatLongDetailsPopup.alpha = 0
        viewLatLongDetailsPopup.sizeToFit()
        
        
        self.PopupEmpName.text = employee_name
        self.PopupEmpCode.text = employee_code
        self.PopupAttendanceDate.text = attendance_date
        self.PopupLabelStatus.textColor = UIColor(hexFromString: "#FFFFFF")
        self.PopupLabelStatus.backgroundColor = UIColor(hexFromString: "#9fdd55")
        self.PopupLabelStatus.layer.masksToBounds = true
        self.PopupLabelStatus.cornerRadius = 5
        
        self.PopupInTime.text = in_time
        self.PopupInLatitude.text = in_latitude
        self.PopupInLongitude.text = in_longitude
        self.PopupInAddress.text = in_address
        if let imageDataIn = Data(base64Encoded: in_image_base_64) {
            let image = UIImage(data: imageDataIn)
            self.PopupInImageView.image = image
        }
        //        self.PopupInImageView.
        if out_latitude == "" {
            PopupTitleOutLatitude.isHidden = true
            PopupTitleOutLongitude.isHidden = true
            PopupViewOut.isHidden = true
            PopupLabelOut.isHidden = true
        }
        
        self.PopupOutTime.text = out_time
        self.PopupOutLatitude.text = out_latitude
        self.PopupOutLongitude.text = out_longitude
        self.PopupAddressOut.text = out_address
        if let imageDataOut = Data(base64Encoded: out_image_base_64) {
            let image = UIImage(data: imageDataOut)
            self.PopupOutImageView.image = image
        }
        
        
        custom_btn_ok_location_details_popup.addBorder(side: .top, color: UIColor(hexFromString: "B3B3B2"), width: 1)
        /*  stackViewButtonborder.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
         view_custom_btn_punchout.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)*/
        
        
        
        
        UIView.animate(withDuration: 0.3){
            self.viewLatLongDetailsPopup.alpha = 1
            self.viewLatLongDetailsPopup.transform = CGAffineTransform.identity
        }
        
    }
    
    func cancelLatLongDetailsPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewLatLongDetailsPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewLatLongDetailsPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewLatLongDetailsPopup.removeFromSuperview()
            //            self.loadData()
            self.canelBlurEffect()
        }
    }
    
    
    
    //--------function to load popup Lat/Long Details data using Alamofire and Json Swifty code starts----------
    func loadPopupLocationData(Log_employee_id:Int!){
        //        loaderStart()
        let url = "\(BASE_URL)timesheet/log/subordinate/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(Log_employee_id!)"
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            //                self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Location details: \(swiftyJsonVar)")
                self.OpenLatLongDetailsPopup(employee_name: swiftyJsonVar["employee_name"].stringValue, employee_code: swiftyJsonVar["employee_code"].stringValue, attendance_date: swiftyJsonVar["attendance_date"].stringValue, in_time: swiftyJsonVar["detail"]["in_time"].stringValue, in_latitude: swiftyJsonVar["detail"]["in_latitude"].stringValue, in_longitude: swiftyJsonVar["detail"]["in_longitude"].stringValue, in_address: swiftyJsonVar["detail"]["in_address"].stringValue, out_time: swiftyJsonVar["detail"]["out_time"].stringValue, out_latitude: swiftyJsonVar["detail"]["out_latitude"].stringValue, out_longitude: swiftyJsonVar["detail"]["out_longitude"].stringValue, out_address: swiftyJsonVar["detail"]["out_address"].stringValue,
                                             in_image_base_64: swiftyJsonVar["detail"]["in_image_base_64"].stringValue, out_image_base_64: swiftyJsonVar["detail"]["out_image_base_64"].stringValue)
                
            }
            
            
        }
        
    }
    //---Leave PopupOk
    @objc func LeavePopupOk(tapGestureRecognizer: UITapGestureRecognizer){
        cancelLatLongDetailsPopup()
    }
    //--------function to load popup Lat/Long Details data using Alamofire and Json Swifty code ends----------
    //============================Form Location Details dialog, code ends============================
    //======added on 07-Jun-2021, ends
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
