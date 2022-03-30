//
//  MyLeaveRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 08/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Toast_Swift

struct LeaveType {
    var leave_name: String!
    var leave_id: Int!
}
class MyLeaveRequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txt_employee_name: UITextField!
    @IBOutlet weak var img_from_date: UIImageView!
    @IBOutlet weak var img_to_date: UIImageView!
    @IBOutlet weak var txt_from_date: UITextField!
    @IBOutlet weak var txt_to_date: UITextField!
    @IBOutlet weak var btn_save: KGRadioButton!
    @IBOutlet weak var btn_submit: KGRadioButton!
    @IBOutlet weak var txt_request_status: UITextField!
    @IBOutlet weak var custom_btn_label_save: UILabel!
    @IBOutlet weak var custom_btn_label_cancel: UILabel!
    @IBOutlet weak var view_custom_btn_cancel: UIView!
    @IBOutlet weak var view_custom_button_save: UIView!
    @IBOutlet weak var StackViewButtons: UIStackView!
    @IBOutlet weak var label_days_count: UILabel!
    @IBOutlet weak var btn_select_type: UIButton!
    @IBOutlet weak var txt_view_details: UITextView!
    @IBOutlet weak var label_supervisor_remark_name: UILabel!
    @IBOutlet weak var txt_view_supervisor_remark: UITextView!
    @IBOutlet weak var label_final_supervisor_remark_name: UILabel!
    @IBOutlet weak var txt_final_supervisor_remark_name: UITextView!
    @IBOutlet weak var custom_view_leave_balance: UIView!
    
    var from_date: Bool = false
    var to_date: Bool = false
    
    let dropDown = DropDown()
    var leaveName = [String]()
    var leaveTypeDetails = [LeaveType]()
    let datePicker = UIDatePicker()
    var year_details = [YearDetails]()
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var od_request_id:Int = 0
//    static var leave_id: Int!
    static var supervisor1_id: Int!, supervisor2_id: Int!, leave_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        txt_from_date.delegate = self
        txt_to_date.delegate = self
        txt_from_date.isUserInteractionEnabled = false
        txt_to_date.isUserInteractionEnabled = false
        txt_from_date.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txt_to_date.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        txt_employee_name.setLeftPaddingPoints(5)
        
        txt_employee_name.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        txt_employee_name.isUserInteractionEnabled = false
        
//        txt_view_reason.delegate = self
        
        
        txt_view_supervisor_remark.isUserInteractionEnabled = false
        txt_view_supervisor_remark.isEditable = false
        txt_final_supervisor_remark_name.isUserInteractionEnabled = false
        txt_final_supervisor_remark_name.isEditable = false
        txt_request_status.isUserInteractionEnabled = false
        
        txt_view_details.backgroundColor = UIColor(hexFromString: "ffffff")
        txt_view_supervisor_remark.backgroundColor = UIColor(hexFromString: "ffffff")
        txt_final_supervisor_remark_name.backgroundColor = UIColor(hexFromString: "ffffff")
        
        loadLeaveData()
        
        //-----code to add button border, starts------
        StackViewButtons.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        view_custom_button_save.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        //-----code to add button border, ends------
        
        if DashboardViewController.DashboardToMyLeaveApplicationRequestNewCreateYN == true{
            txt_from_date.text = DashboardViewController.FirstDate
            txt_to_date.text = DashboardViewController.LastDate
            btn_submit.isSelected = true
        }else if DashboardViewController.DashboardToMyLeaveApplicationRequestNewCreateYN == false {
        
        if MyLeaveApplicationViewController.new_create_yn == true{
//            populate_value()
            btn_submit.isSelected = true
        }else if MyLeaveApplicationViewController.new_create_yn == false{
            loadData()
        }
        }
        //-----Save
        let tapGestureRecognizerSave = UITapGestureRecognizer(target: self, action: #selector(Save(tapGestureRecognizer:)))
        custom_btn_label_save.isUserInteractionEnabled = false
        custom_btn_label_save.alpha = 0.6
        custom_btn_label_save.addGestureRecognizer(tapGestureRecognizerSave)
        
        //-----Cancel
        let tapGestureRecognizerCancel = UITapGestureRecognizer(target: self, action: #selector(Cancel(tapGestureRecognizer:)))
        custom_btn_label_cancel.isUserInteractionEnabled = true
        custom_btn_label_cancel.alpha = 1.0
        custom_btn_label_cancel.addGestureRecognizer(tapGestureRecognizerCancel)
        
        //----Leave Balance
        let tapGestureRecognizerLeaveBalance = UITapGestureRecognizer(target: self, action: #selector(LeaveBalance(tapGestureRecognizer:)))
        custom_view_leave_balance.isUserInteractionEnabled = true
        custom_view_leave_balance.addGestureRecognizer(tapGestureRecognizerLeaveBalance)
        
        //------LeavePopup Ok
        let tapGestureRecognizerLeavePopupOk = UITapGestureRecognizer(target: self, action: #selector(LeavePopupOk(tapGestureRecognizer:)))
        custom_btn_ok_leave_popup.isUserInteractionEnabled = true
        custom_btn_ok_leave_popup.addGestureRecognizer(tapGestureRecognizerLeavePopupOk)
        
    }
    //============================-Form Leave Balance dialog, code starts============================
    @IBOutlet weak var viewPopupNavBar: UIView!
    @IBOutlet var viewLeaveBalance: UIView!
    @IBOutlet weak var label_casual_leave: UILabel!
    @IBOutlet weak var label_earned_leave: UILabel!
    @IBOutlet weak var label_sick_leave: UILabel!
    @IBOutlet weak var label_comp_off: UILabel!
    @IBOutlet weak var label_maternal_leave: UILabel!
    @IBOutlet weak var label_paternal_leave: UILabel!
   
    @IBOutlet weak var btn_select_year: UIButton!
    @IBOutlet weak var custom_btn_ok_leave_popup: UIView!
    
    let dropDownSelectYear = DropDown()
    
    @IBAction func btnCancel(_ sender: Any) {
        cancelLeaveBalancePopup()
    }
    @IBAction func btn_select_year(_ sender: UIButton) {
        dropDownSelectYear.dataSource = year
        dropDownSelectYear.anchorView = sender //5
        dropDownSelectYear.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDownSelectYear.show() //7
        dropDownSelectYear.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("year-=>",item)
                self!.loadPopupLeaveData(year: self!.year_details[index].financial_year_code)
            }
    }
    func openLeaveBalancePopup(){
        self.get_Year_details()
        blurEffect()
        self.view.addSubview(viewLeaveBalance)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        viewLeaveBalance.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewLeaveBalance.center = self.view.center
        viewLeaveBalance.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewLeaveBalance.alpha = 0
        viewLeaveBalance.sizeToFit()
        

        custom_btn_ok_leave_popup.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
      /*  stackViewButtonborder.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        view_custom_btn_punchout.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)*/
        
        
        
        
        UIView.animate(withDuration: 0.3){
            self.viewLeaveBalance.alpha = 1
            self.viewLeaveBalance.transform = CGAffineTransform.identity
        }
        
    }
    
    func cancelLeaveBalancePopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewLeaveBalance.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewLeaveBalance.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewLeaveBalance.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    //--------function to get year using Alamofire and Json Swifty------------
    var year = [String]()
        func get_Year_details(){
            loaderStart()
            if year.count > 0{
                year.removeAll()
            }
            if !year_details.isEmpty{
                year_details.removeAll(keepingCapacity: true)
            }
            let url = "\(BASE_URL)finyear/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)"
            AF.request(url).responseJSON{ (responseData) -> Void in
                self.loaderEnd()
                if((responseData.value) != nil){
                    let swiftyJsonVar=JSON(responseData.value!)
//                    print("Calendar description: \(swiftyJsonVar)")
                    
                    for i in 0..<swiftyJsonVar["fin_years"].count{
//                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
//                        print("Calendar-=>",self.year)
                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
                        
                    }

                    for(key,value) in swiftyJsonVar["fin_years"]{
                        var k = YearDetails()
                        k.calender_year = value["calender_year"].stringValue
                        k.financial_year_code = value["financial_year_code"].stringValue
                        self.year_details.append(k)
                    }
                    
                }
                
            }
        }
        //--------function to get year using Alamofire and Json Swifty code ends------------
    
    //--------function to load popup leave data using Alamofire and Json Swifty code starts----------
    func loadPopupLeaveData(year:String?){
//        loaderStart()
        let url = "\(BASE_URL)leave/balance/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(year!)"
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
//                self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                    print("Year description: \(swiftyJsonVar)")
                self.label_casual_leave.text = swiftyJsonVar["leave_balance"]["casual_leave"].stringValue
                self.label_earned_leave.text = swiftyJsonVar["leave_balance"]["earn_leave"].stringValue
                self.label_sick_leave.text = swiftyJsonVar["leave_balance"]["sick_leave"].stringValue
                self.label_maternal_leave.text = swiftyJsonVar["leave_balance"]["maternal_leave"].stringValue
                self.label_paternal_leave.text = swiftyJsonVar["leave_balance"]["paternal_leave"].stringValue
                self.label_comp_off.text = swiftyJsonVar["leave_balance"]["comp_off"].stringValue
                    
                }

                
            }
            
        }
    //---Leave PopupOk
    @objc func LeavePopupOk(tapGestureRecognizer: UITapGestureRecognizer){
        cancelLeaveBalancePopup()
    }
    //--------function to load popup leave data using Alamofire and Json Swifty code ends----------
    //============================Form Leave Balance dialog, code ends============================
    
    //---Save
    @objc func Save(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
        print("Save")
        if (daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)+1) <= 0 {
            
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .white
            
            // present the toast with the new style
            self.view.makeToast("\"To Date\" should be greater than \"From Date\"", duration: 3.0, position: .bottom, style: style)
        }else if txt_view_details.text == ""{
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .white
            
            // present the toast with the new style
            self.view.makeToast("Please enter Details", duration: 3.0, position: .bottom, style: style)
        }else{
            
        SaveData()
        }
    }
    
    //---Cancel
    @objc func Cancel(tapGestureRecognizer: UITapGestureRecognizer){
        DashboardViewController.DashboardToMyLeaveApplicationRequestNewCreateYN = false
        self.performSegue(withIdentifier: "myleave", sender: self)
    }
    
    //---Leave Balance
    @objc func LeaveBalance(tapGestureRecognizer: UITapGestureRecognizer){
        openLeaveBalancePopup()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        DashboardViewController.DashboardToMyLeaveApplicationRequestNewCreateYN = false
        self.performSegue(withIdentifier: "myleave", sender: self)
        print("tapped")
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case self.txt_from_date:
            from_date = true
            to_date = false
            showDatePicker(txtfield: txt_from_date)
            txt_to_date.isUserInteractionEnabled = true
            break
        case self.txt_to_date:
            
            if txt_from_date.text == "" {
                to_date = false
                
                
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                
                // present the toast with the new style
                self.view.makeToast("Please select From Date", duration: 3.0, position: .bottom, style: style)
            }else{
                to_date = true
                from_date = false
                
            showDatePicker(txtfield: txt_to_date)
            }
            break
        default:
            break
        }
    }
    
   
    //-----Date picker code starts
    func showDatePicker(txtfield: UITextField){
        //Formate Date
        datePicker.datePickerMode = .date

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

      txtfield.inputAccessoryView = toolbar
      txtfield.inputView = datePicker
        
        

     }

    @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MMM-yyyy"
        if from_date == true {
       txt_from_date.text = formatter.string(from: datePicker.date)
        }
        if to_date == true{
            txt_to_date.text = formatter.string(from: datePicker.date)
            print("test-=>",daysBetween(start: txt_from_date.text!, end: txt_to_date.text!))
            label_days_count.text = String(daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)+1)
            
            custom_btn_label_save.isEnabled = true
            custom_btn_label_save.isUserInteractionEnabled = true
            custom_btn_label_save.alpha = 1.0
            
            if (daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)+1) <= 0 {
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                // present the toast with the new style
                self.view.makeToast("\"To Date\" should be greater than \"From Date\"", duration: 3.0, position: .bottom, style: style)
                
                
               /* custom_btn_label_save.isEnabled = false
                custom_btn_label_save.isUserInteractionEnabled = false
                custom_btn_label_save.alpha = 0.6*/
            }else{
                /*custom_btn_label_save.isEnabled = true
                custom_btn_label_save.isUserInteractionEnabled = true
                custom_btn_label_save.alpha = 1.0*/
            }
//            daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)
        }
        
        //--added on 18th Feb, code starts
        if from_date == true && txt_to_date.text != ""{
            txt_from_date.text = formatter.string(from: datePicker.date)
            label_days_count.text = String(daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)+1)
            
            if (daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)+1) <= 0 {
                
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                // present the toast with the new style
                self.view.makeToast("\"To Date\" should be greater than \"From Date\"", duration: 3.0, position: .bottom, style: style)
                
                /* custom_btn_label_save.isEnabled = false
                 custom_btn_label_save.isUserInteractionEnabled = false
                 custom_btn_label_save.alpha = 0.6*/
            }else{
                /*  custom_btn_label_save.isEnabled = true
                 custom_btn_label_save.isUserInteractionEnabled = true
                 custom_btn_label_save.alpha = 1.0 */
            }
            
        }
        //--added on 18th Feb, code ends
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
       
    
   
    
    //-----Date picker code ends
    
    //--code to get day count starts
    func daysBetween(start: String, end: String) -> Int {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        // specify the format,
        formatter.dateFormat = "dd/MM/yyyy"
        // specify the start date
        let startDate = formatter.date(from: start)
        // specify the end date
        let endDate = formatter.date(from: end)
        print(startDate!)
        print(endDate!)
        let diff = calendar.dateComponents([.day], from: startDate!, to: endDate!).day ?? 0
        
        return diff
//        print("test-=>",diff)
       
        }
    //--code to get day count ends
  
    @IBAction func btn_onClick_kgradio_btn(_ sender: KGRadioButton) {
        switch sender {
        case btn_save:
            btn_save.isSelected = true
            btn_submit.isSelected = false
            break
        case btn_submit:
            btn_submit.isSelected = true
            btn_save.isSelected = false
            break
        default:
            break
        }
    }
    //---code for dropdown on button click, starts
    
    @IBAction func btn_select_type(_ sender: UIButton) {
        dropDown.dataSource = leaveName
        dropDown.anchorView = sender//5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
          sender.setTitle(item, for: .normal) //9
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
            print("name-=>",self!.leaveTypeDetails[index].leave_id!)
            
            MyLeaveRequestViewController.leave_id = self!.leaveTypeDetails[index].leave_id!
            
            if MyLeaveRequestViewController.leave_id != 0 {
                self!.txt_from_date.isUserInteractionEnabled = true
            }

    }
    }
    //---code for dropdown on button click, ends
    
    //--------function to load leave type using Alamofire and Json Swifty------------
    func loadLeaveData(){
//           loaderStart()
        if !leaveTypeDetails.isEmpty{
            leaveTypeDetails.removeAll(keepingCapacity: true)
        }
        if !leaveName.isEmpty{
            leaveName.removeAll(keepingCapacity: true)
        }
        
        let url = "\(BASE_URL)leave/type/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)"
//        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
//               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                for(key,value) in swiftyJsonVar["types"]{
                    var k = LeaveType()
                    k.leave_name = value["name"].stringValue
                    k.leave_id = value["id"].intValue
                    self.leaveTypeDetails.append(k)
                }
                for i in 0..<self.leaveTypeDetails.count{
                    self.leaveName.append(self.leaveTypeDetails[i].leave_name!)
                }
               }
               
           }
       }
       //--------function to load leave type using Alamofire and Json Swifty code ends------------
    //--------function to show leave application request details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        let url = "\(BASE_URL)leave/application/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(MyLeaveApplicationViewController.appliction_id!)/1/"
        print("MyLeaveAppltnRqsturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Leave Application Log details: \(swiftyJsonVar)")
                
                self.txt_employee_name.text = swiftyJsonVar["fields"]["employee_name"].stringValue
                self.txt_from_date.text = swiftyJsonVar["fields"]["from_date"].stringValue
                self.txt_to_date.text = swiftyJsonVar["fields"]["to_date"].stringValue
                self.label_days_count.text = swiftyJsonVar["fields"]["total_days"].stringValue
                self.txt_view_details.text = swiftyJsonVar["fields"]["description"].stringValue
                self.txt_request_status.text = swiftyJsonVar["fields"]["leave_status"].stringValue
                MyLeaveRequestViewController.supervisor1_id = swiftyJsonVar["fields"]["supervisor1_id"].intValue
                self.label_supervisor_remark_name.text = swiftyJsonVar["fields"]["supervisor1_name"].stringValue
                MyLeaveRequestViewController.supervisor2_id = swiftyJsonVar["fields"]["supervisor2_id"].intValue
                self.label_final_supervisor_remark_name.text = swiftyJsonVar["fields"]["supervisor2_name"].stringValue
                self.txt_view_supervisor_remark.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                MyLeaveRequestViewController.leave_id = swiftyJsonVar["fields"]["leave_id"].intValue
                
               
                
                
                if swiftyJsonVar["fields"]["leave_status"].stringValue == "Save"{
//                    self.od_request_id = swiftyJsonVar["fields"]["od_request_id"].intValue
                    
//                    self.txt_view_remarks.isUserInteractionEnabled = false
                    self.btn_select_type.isUserInteractionEnabled = true
                    self.custom_btn_label_save.alpha = 1.0
                    self.btn_select_type.setTitle(MyLeaveApplicationViewController.leave_name!, for: .normal)
                    
                    self.custom_btn_label_save.isUserInteractionEnabled = true
//                    self.custom_btn_label_save.backgroundColor = UIColor(hexFromString: "F4F4F1")
                    
                    self.btn_save.isSelected = true
                    
                    self.img_from_date.isHidden = false
                    self.img_from_date.isUserInteractionEnabled = true
                    
                    self.img_to_date.isHidden = false
                    self.img_to_date.isUserInteractionEnabled = true
                    
                    self.txt_from_date.isUserInteractionEnabled = true
                    self.txt_to_date.isUserInteractionEnabled = true
                    
                } else if swiftyJsonVar["fields"]["leave_status"].stringValue == "Return"{
//                    self.od_request_id = swiftyJsonVar["fields"]["od_request_id"].intValue
                    
//                    self.txt_view_remarks.isUserInteractionEnabled = false
                    self.btn_select_type.isUserInteractionEnabled = true
                    self.custom_btn_label_save.alpha = 1.0
                    self.btn_select_type.setTitle(MyLeaveApplicationViewController.leave_name!, for: .normal)
                    
                    self.custom_btn_label_save.isUserInteractionEnabled = true
//                    self.custom_btn_label_save.backgroundColor = UIColor(hexFromString: "F4F4F1")
                    
                    self.btn_submit.isSelected = true
                    
                    self.txt_from_date.isUserInteractionEnabled = true
                    self.txt_to_date.isUserInteractionEnabled = true
                    
                } else{
//                    self.od_request_id = swiftyJsonVar["fields"]["od_request_id"].intValue
                    
//                    self.txt_view_reason.isUserInteractionEnabled = false
//                    self.txt_view_remarks.isUserInteractionEnabled = false
                    self.btn_select_type.isUserInteractionEnabled = false
                    self.btn_select_type.setTitle(MyLeaveApplicationViewController.leave_name!, for: .normal)
                    
                    self.custom_btn_label_save.isUserInteractionEnabled = false
                    self.custom_btn_label_save.alpha = 0.6
                    
                    self.btn_submit.isSelected = true
                    self.btn_submit.isUserInteractionEnabled = false
                    self.btn_save.isUserInteractionEnabled = false
                    
                    self.img_from_date.isHidden = true
                    self.img_from_date.isUserInteractionEnabled = false
                    
                    self.img_to_date.isHidden = true
                    self.img_to_date.isUserInteractionEnabled = false
                }
                
               }
               
           }
       }
       //--------function to show leave application request details using Alamofire and Json Swifty code ends------------
    //-----function to save data, code starts---
    func SaveData(){
        let url = "\(BASE_URL)leave/application/save"
        print("save_url-=>",url)
        var leave_status:String?
        if btn_save.isSelected == true{
            leave_status = "Save"
        }else if btn_submit.isSelected == true{
            leave_status = "Submit"
        }
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "appliction_id": 0,
            "leave_id": MyLeaveRequestViewController.leave_id!,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].stringValue,
            "from_date": txt_from_date.text!,
            "to_date": txt_to_date.text!,
            "total_days": label_days_count.text!,
            "description": txt_view_details.text!,
            "supervisor_remark": txt_view_supervisor_remark.text!,
            "leave_status": leave_status!,
            "approved_by_id": 0,
            "approved_date": "",
            "supervisor1_id": 0,
            "supervisor2_id": 0
        ]
        
        print("SentData-=>",sentData)
                
                AF.request(url, method: .post, parameters: sentData, encoding: JSONEncoding.default, headers: nil).responseJSON{
                    response in
                    switch response.result{
                        
                    case .success:
//                        self.loaderEnd()
                        let swiftyJsonVar = JSON(response.value!)
                        print("Return saved data: ", swiftyJsonVar)
                    
                        if swiftyJsonVar["status"].stringValue == "true"{
                            // Create new Alert
                            var dialogMessage = UIAlertController(title: "", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                                print("Ok button tapped")
                                DashboardViewController.DashboardToMyLeaveApplicationRequestNewCreateYN = false
                                self.performSegue(withIdentifier: "myleave", sender: nil)
                             })
                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)

                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                        }else{
                            var style = ToastStyle()
                            
                            // this is just one of many style options
                            style.messageColor = .white
                            
                            // present the toast with the new style
                            self.view.makeToast(swiftyJsonVar["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                        }

                        break
                        
                    case .failure(let error):
//                        self.loaderEnd()
                        print("Error: ", error)
                    }
                }
    }
    
    //-----function to save data, code ends---
    
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

};

extension UIView {

    public enum BorderSide {
        case top, bottom, left, right
    }

    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
            let border = UIView()
            border.translatesAutoresizingMaskIntoConstraints = false
            border.backgroundColor = color
            self.addSubview(border)

            let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
            let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
            let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
            let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
            let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
            let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)


            switch side {
            case .top:
                NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
            case .right:
                NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
            case .bottom:
                NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
            case .left:
                NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
            }
        }
}
