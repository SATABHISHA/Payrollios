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
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var od_request_id:Int = 0
    static var leave_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txt_from_date.delegate = self
        txt_to_date.delegate = self
        txt_from_date.isUserInteractionEnabled = false
        txt_to_date.isUserInteractionEnabled = false
        
        txt_employee_name.setLeftPaddingPoints(5)
        
        txt_employee_name.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        txt_employee_name.isUserInteractionEnabled = false
        
//        txt_view_reason.delegate = self
        
        
        txt_view_supervisor_remark.isUserInteractionEnabled = false
        txt_view_supervisor_remark.isEditable = false
        txt_final_supervisor_remark_name.isUserInteractionEnabled = false
        txt_final_supervisor_remark_name.isEditable = false
        txt_request_status.isUserInteractionEnabled = false
        loadLeaveData()
        
        if MyLeaveApplicationViewController.new_create_yn == true{
//            populate_value()
            btn_submit.isSelected = true
        }else if MyLeaveApplicationViewController.new_create_yn == false{
//            txt_employee_name.text = "\(swiftyJsonvar1["employee"]["employee_fname"].stringValue) \(swiftyJsonvar1["employee"]["employee_lname"].stringValue)"
//            loadData()
        }
        
        //-----Save
        let tapGestureRecognizerSave = UITapGestureRecognizer(target: self, action: #selector(Save(tapGestureRecognizer:)))
        custom_btn_label_save.isUserInteractionEnabled = false
        custom_btn_label_save.alpha = 0.6
        custom_btn_label_save.addGestureRecognizer(tapGestureRecognizerSave)
    }
    
    //---Save
    @objc func Save(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
        print("Save")
        SaveData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
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
            
            if (daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)+1) <= 0 {
                custom_btn_label_save.isEnabled = false
                custom_btn_label_save.isUserInteractionEnabled = false
                custom_btn_label_save.alpha = 0.6
            }else{
                custom_btn_label_save.isEnabled = true
                custom_btn_label_save.isUserInteractionEnabled = true
                custom_btn_label_save.alpha = 1.0
            }
//            daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)
        }
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
           loaderStart()
        if !leaveTypeDetails.isEmpty{
            leaveTypeDetails.removeAll(keepingCapacity: true)
        }
        if !leaveName.isEmpty{
            leaveName.removeAll(keepingCapacity: true)
        }
        
        let url = "\(BASE_URL)leave/type/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)"
//        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
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

}
