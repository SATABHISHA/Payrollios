//
//  OutDoorDutyRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/03/21.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import Toast_Swift

class OutDoorDutyRequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txt_employee_name: UITextField!
    @IBOutlet weak var txt_requisition_no: UITextField!
    @IBOutlet weak var img_from_date: UIImageView!
    @IBOutlet weak var img_to_date: UIImageView!
    @IBOutlet weak var txt_view_reason: UITextView!
    @IBOutlet weak var txt_view_remarks: UITextView!
    @IBOutlet weak var txt_from_date: UITextField!
    @IBOutlet weak var txt_to_date: UITextField!
    @IBOutlet weak var btn_save: KGRadioButton!
    @IBOutlet weak var btn_submit: KGRadioButton!
    @IBOutlet weak var txt_request_status: UITextField!
    @IBOutlet weak var custom_btn_label_save: UILabel!
    @IBOutlet weak var custom_btn_label_cancel: UILabel!
    @IBOutlet weak var label_days_count: UILabel!
    
    var from_date: Bool = false
    var to_date: Bool = false
    
    let dropDown = DropDown()
    var type = [String]()
    let datePicker = UIDatePicker()
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var od_request_id:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_from_date.delegate = self
        txt_to_date.delegate = self
        
        txt_view_reason.delegate = self
        
        txt_requisition_no.setLeftPaddingPoints(5)
        txt_employee_name.setLeftPaddingPoints(5)
//        txt_view_reason.setLeftPaddingPoints(5)
        
        txt_requisition_no.isUserInteractionEnabled = false
        txt_employee_name.isUserInteractionEnabled = false
        txt_view_remarks.isUserInteractionEnabled = false
        
        btn_submit.isSelected = true
       
        
        type.append("Work From Home")
        
//        showDatePicker()
        
        //-----Save
        let tapGestureRecognizerSave = UITapGestureRecognizer(target: self, action: #selector(Save(tapGestureRecognizer:)))
        custom_btn_label_save.isUserInteractionEnabled = true
        custom_btn_label_save.addGestureRecognizer(tapGestureRecognizerSave)
        
        //-----Cancel
        let tapGestureRecognizerCancel = UITapGestureRecognizer(target: self, action: #selector(Cancel(tapGestureRecognizer:)))
        custom_btn_label_cancel.isUserInteractionEnabled = true
        custom_btn_label_cancel.addGestureRecognizer(tapGestureRecognizerCancel)
        
        print("random-=>", Int.random(in: 0 ... 999999))
        
        populate_value()
        print("jsonData-=>",swiftyJsonvar1)
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
    }
    func populate_value(){
        let year = Calendar.current.component(.year, from: Date())
        let random = Int.random(in: 0 ... 999999)
        let od_number: String = "OD/\(year)/\(random)"
        txt_requisition_no.text = od_number
        txt_employee_name.text = "\(swiftyJsonvar1["employee"]["employee_fname"].stringValue) \(swiftyJsonvar1["employee"]["employee_lname"].stringValue)"
    }
    
    //---Save
    @objc func Save(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
        print("Save")
        SaveData()
    }
    
    //---Cancel
    @objc func Cancel(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
        print("Cancel")
    }
    
    //-----------dismiss keyboard on touching anywhere in the screen code starts-----------
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //-----------dismiss keyboard code ends-----------
    
    //============keyboard will show/hide, code starts==========
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    //============keyboard will show/hide, code ends===========
    
    
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case self.txt_from_date:
            from_date = true
            to_date = false
            showDatePicker(txtfield: txt_from_date)
            break
        case self.txt_to_date:
            to_date = true
            from_date = false
            showDatePicker(txtfield: txt_to_date)
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
    
    //---code for dropdown on button click, starts
    @IBAction func btn_select_type(_ sender: UIButton) {
        dropDown.dataSource = type
        dropDown.anchorView = sender//5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
          sender.setTitle(item, for: .normal) //9
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
//            print("name-=>",SubordinateLogViewController.subordinate_details[index].slno!)

    }
    }
    //---code for dropdown on button click, ends
   

    
    //--------function to load data using Alamofire and Json Swifty------------
    func loadData(){
//           loaderStart1()
        
        let url = "\(BASE_URL)od/request/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("odDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
//               self.loaderEnd1()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
//                   if let resData = swiftyJsonVar["request_list"].arrayObject{
//                       self.arrRes = resData as! [[String:AnyObject]]
//                   }
                   
               }
               
           }
       }
       //--------function to load data using Alamofire and Json Swifty code ends------------
    
    //-----function to save data, code starts---
    func SaveData(){
        let url = "\(BASE_URL)od/request/save"
        var od_status:String?
        if btn_save.isSelected == true{
            od_status = "Save"
        }else if btn_submit.isSelected == true{
            od_status = "Submit"
        }
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "od_request_id": od_request_id,
            "od_request_no": txt_requisition_no.text!,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].stringValue,
            "from_date": txt_from_date.text!,
            "to_date": txt_to_date.text!,
            "total_days": label_days_count.text!,
            "description": txt_view_reason.text!,
            "supervisor_remark": txt_view_remarks.text!,
            "od_status": od_status!,
            "approved_by_id": 0,
            "approved_date": ""
        ]
                
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
                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
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
//                        if swiftyJsonVar["status"].stringValue == "success" {
//                            let data = swiftyJsonVar["message"].stringValue
//
//
//                        } else {
//                            let message = swiftyJsonVar["message"].stringValue
//
////                            Toast(text: message, duration: Delay.short).show()
//                            print("Return edit data: ", swiftyJsonVar)
//                        }
                        break
                        
                    case .failure(let error):
//                        self.loaderEnd()
                        print("Error: ", error)
                    }
                }
    }
    
    //-----function to save data, code ends---
   

}

