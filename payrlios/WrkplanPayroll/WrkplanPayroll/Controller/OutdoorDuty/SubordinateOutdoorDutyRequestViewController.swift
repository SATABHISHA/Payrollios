//
//  SubordinateOutdoorDutyRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 08/03/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Toast_Swift

class SubordinateOutdoorDutyRequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txt_od_rqst_no: UITextField!
    @IBOutlet weak var txt_emp_name: UITextField!
    @IBOutlet weak var txt_od_duty_type: UITextField!
    @IBOutlet weak var label_from_date: UILabel!
    @IBOutlet weak var label_to_date: UILabel!
    @IBOutlet weak var txt_view_reason: UITextView!
    @IBOutlet weak var txt_view_remarks: UITextView!
    @IBOutlet weak var label_custom_btn_save: UILabel!
    @IBOutlet weak var label_custom_btn_cancel: UILabel!
    @IBOutlet weak var label_count: UILabel!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    @IBOutlet weak var btn_select_status: UIButton!
    
    let dropDown = DropDown()
    var type = [String]()
    
    var od_status:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeStatusBarColor() //---to change background statusbar color
        
        // Do any additional setup after loading the view.
        txt_od_rqst_no.isUserInteractionEnabled = false
        txt_emp_name.isUserInteractionEnabled = false
        txt_view_reason.isUserInteractionEnabled = false
        txt_od_duty_type.isUserInteractionEnabled = false
        txt_od_duty_type.text = ""
        
        txt_od_rqst_no.setLeftPaddingPoints(5)
        txt_emp_name.setLeftPaddingPoints(5)
        txt_od_duty_type.setLeftPaddingPoints(5)
        
        txt_view_reason.backgroundColor = UIColor(hexFromString: "ffffff")
        txt_view_remarks.backgroundColor = UIColor(hexFromString: "ffffff")
        
        //---appending data for dropdown, starts
        type.append("Approved")
        type.append("Canceled")
        type.append("Return")
        //---appending data for dropdown, ends
        
        txt_view_remarks.delegate = self
        
        loadData()
        
        //-----Save
        let tapGestureRecognizerSave = UITapGestureRecognizer(target: self, action: #selector(Save(tapGestureRecognizer:)))
        label_custom_btn_save.isUserInteractionEnabled = false
        label_custom_btn_save.addGestureRecognizer(tapGestureRecognizerSave)
        
        //-----Cancel
        let tapGestureRecognizerCancel = UITapGestureRecognizer(target: self, action: #selector(Cancel(tapGestureRecognizer:)))
        label_custom_btn_cancel.isUserInteractionEnabled = true
        label_custom_btn_cancel.addGestureRecognizer(tapGestureRecognizerCancel)
    }
    //---Save
    @objc func Save(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
        print("Save-=>",od_status ?? "")
        
        SaveData()
    }
    //---Cancel
    @objc func Cancel(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
        self.performSegue(withIdentifier: "subordinateoutdoordutylist", sender: nil)
        print("Cancel")
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "subordinateoutdoordutylist", sender: nil)
        DashboardViewController.NotificationPendingItemsYN = false
    }
    
   
    @IBAction func btn_select_type(_ sender: UIButton) {
        dropDown.dataSource = type
        dropDown.anchorView = sender//5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
          sender.setTitle(item, for: .normal) //9
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
            
            self!.od_status = item
            
            self!.label_custom_btn_save.isUserInteractionEnabled = true
//            print("name-=>",SubordinateLogViewController.subordinate_details[index].slno!)

    }
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
    
    //--------function to show details using Alamofire and Json Swifty------------
    static var od_request_id: Int!, employee_id: Int!
    func loadData(){
           loaderStart()
        
        
        if DashboardViewController.NotificationPendingItemsYN == true {
            SubordinateOutdoorDutyRequestViewController.od_request_id = Int(DashboardViewController.event_id!)
            SubordinateOutdoorDutyRequestViewController.employee_id = Int(DashboardViewController.event_owner_id!)
        }else if DashboardViewController.NotificationPendingItemsYN == false {
            SubordinateOutdoorDutyRequestViewController.od_request_id = Int(SubordinateOutdoorDutyRequestListViewController.od_request_id)
            SubordinateOutdoorDutyRequestViewController.employee_id = Int(SubordinateOutdoorDutyRequestListViewController.supervisor_employee_id!)
        }
        
//        let url = "\(BASE_URL)od/request/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(SubordinateOutdoorDutyRequestListViewController.od_request_id!)/2/"
        let url = "\(BASE_URL)od/request/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(SubordinateOutdoorDutyRequestViewController.od_request_id!)/2/"
        print("SubordinateOutDoorDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log details: \(swiftyJsonVar)")
                
                self.txt_od_rqst_no.text = swiftyJsonVar["fields"]["od_request_no"].stringValue
                self.txt_emp_name.text = swiftyJsonVar["fields"]["employee_name"].stringValue
                self.label_from_date.text = swiftyJsonVar["fields"]["from_date"].stringValue
                self.label_to_date.text = swiftyJsonVar["fields"]["to_date"].stringValue
                self.label_count.text = swiftyJsonVar["fields"]["total_days"].stringValue
                self.txt_view_reason.text = swiftyJsonVar["fields"]["description"].stringValue
                
                if swiftyJsonVar["fields"]["approved_by_id"].intValue == 0 {
                    self.txt_view_remarks.isUserInteractionEnabled = true
                    self.txt_view_remarks.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                }else{
                    self.txt_view_remarks.isUserInteractionEnabled = false
                    self.txt_view_remarks.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                    self.label_custom_btn_save.isUserInteractionEnabled = false
                    self.label_custom_btn_save.backgroundColor = UIColor(hexFromString: "F4F4F1")
                    
                    self.btn_select_status.isUserInteractionEnabled = false
                    self.btn_select_status.setTitle(swiftyJsonVar["fields"]["od_status"].stringValue, for: .normal)
                }
                
               }
               
           }
       }
       //--------function to log details using Alamofire and Json Swifty code ends------------
    
    //-----function to save data, code starts---
    func SaveData(){
        let url = "\(BASE_URL)od/request/save"
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: date))
        
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "od_request_id": SubordinateOutdoorDutyRequestViewController.od_request_id!,
            "od_request_no": txt_od_rqst_no.text!,
            "employee_id": SubordinateOutdoorDutyRequestViewController.employee_id!,
            "from_date": label_from_date.text!,
            "to_date": label_to_date.text!,
            "total_days": label_count.text!,
            "description": txt_view_reason.text!,
            "supervisor_remark": txt_view_remarks.text!,
            "od_status": od_status!,
            "approved_by_id": swiftyJsonvar1["employee"]["employee_id"].stringValue,
            "approved_date": dateFormatter.string(from: date)
            
        ]
             print("sendData-=>",sentData)
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
                                self.performSegue(withIdentifier: "subordinateoutdoordutylist", sender: nil)
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
