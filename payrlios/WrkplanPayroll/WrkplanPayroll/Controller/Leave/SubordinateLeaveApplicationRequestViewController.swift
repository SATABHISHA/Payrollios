//
//  SubordinateLeaveApplicationRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 09/04/21.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import Toast_Swift

class SubordinateLeaveApplicationRequestViewController: UIViewController {

    @IBOutlet weak var txt_employee_name: UITextField!
    @IBOutlet weak var txt_leave_type: UITextField!
    @IBOutlet weak var txt_from_date: UITextField!
    @IBOutlet weak var txt_to_date: UITextField!
    @IBOutlet weak var label_day_count: UILabel!
    @IBOutlet weak var txt_view_details: UITextView!
    @IBOutlet weak var label_supervisor_remarks_name: UILabel!
    @IBOutlet weak var txt_view_supervisor_remarks: UITextView!
    @IBOutlet weak var label_final_supervisor_remarks_name: UILabel!
    @IBOutlet weak var txt_view_final_supervisor_remarks: UITextView!
    @IBOutlet weak var label_application_type: UILabel!
    @IBOutlet weak var custom_label_btn_save: UILabel!
    @IBOutlet weak var custom_label_btn_cancel: UILabel!
    
    @IBOutlet weak var btn_select_status: UIButton!
    
    var od_status:String?
    let dropDown = DropDown()
    var type = [String]()
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    static var supervisor1_id: Int!, supervisor2_id: Int!, leave_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeStatusBarColor() //---to change background statusbar color
        
        // Do any additional setup after loading the view.
//        txt_employee_name.text = SubordinateLeaveApplicationViewController.employee_name!
        txt_view_details.isUserInteractionEnabled = false
        txt_leave_type.text = SubordinateLeaveApplicationViewController.leave_name!
        
        txt_employee_name.setLeftPaddingPoints(5)
        txt_leave_type.setLeftPaddingPoints(5)
        txt_from_date.setLeftPaddingPoints(5)
        txt_to_date.setLeftPaddingPoints(5)
        
        txt_employee_name.isUserInteractionEnabled = false
        txt_leave_type.isUserInteractionEnabled = false
        txt_from_date.isUserInteractionEnabled = false
        txt_to_date.isUserInteractionEnabled = false
        txt_view_final_supervisor_remarks.isUserInteractionEnabled = false
        
        txt_view_details.backgroundColor = UIColor(hexFromString: "ffffff")
        txt_view_supervisor_remarks.backgroundColor = UIColor(hexFromString: "ffffff")
        txt_view_final_supervisor_remarks.backgroundColor = UIColor(hexFromString: "ffffff")
        
        //---appending data for dropdown, starts
        type.append("Approved")
        type.append("Canceled")
        type.append("Return")
        //---appending data for dropdown, ends
        
        //-----Save
        let tapGestureRecognizerSave = UITapGestureRecognizer(target: self, action: #selector(Save(tapGestureRecognizer:)))
        custom_label_btn_save.isUserInteractionEnabled = false
        custom_label_btn_save.alpha = 0.6
        custom_label_btn_save.addGestureRecognizer(tapGestureRecognizerSave)
        
        //-----Cancel
        let tapGestureRecognizerCancel = UITapGestureRecognizer(target: self, action: #selector(Cancel(tapGestureRecognizer:)))
        custom_label_btn_cancel.isUserInteractionEnabled = true
        custom_label_btn_cancel.addGestureRecognizer(tapGestureRecognizerCancel)
        
        loadData()
    }
    //---Save
    @objc func Save(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "empinfo", sender: nil)
//        print("Save-=>",od_status ?? "")
        
        SaveData()
    }
    //---Cancel
    @objc func Cancel(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "subleaveappltn", sender: self)
        print("Cancel")
    }
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "subleaveappltn", sender: self)
        print("tapped")
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
            
            self!.custom_label_btn_save.isUserInteractionEnabled = true
            self!.custom_label_btn_save.alpha = 1.0
//            print("name-=>",SubordinateLogViewController.subordinate_details[index].slno!)

    }
    }
    
    //--------function to show leave application request details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        
        let url = "\(BASE_URL)leave/application/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(SubordinateLeaveApplicationViewController.appliction_id!)/2/"
        print("SubordinateOutDoorDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Subordinate Log details: \(swiftyJsonVar)")
                
                self.txt_employee_name.text = swiftyJsonVar["fields"]["employee_name"].stringValue
                self.txt_from_date.text = swiftyJsonVar["fields"]["from_date"].stringValue
                self.txt_to_date.text = swiftyJsonVar["fields"]["to_date"].stringValue
                self.label_day_count.text = swiftyJsonVar["fields"]["total_days"].stringValue
                self.txt_view_details.text = swiftyJsonVar["fields"]["description"].stringValue
                self.label_application_type.text = swiftyJsonVar["fields"]["leave_status"].stringValue
                SubordinateLeaveApplicationRequestViewController.supervisor1_id = swiftyJsonVar["fields"]["supervisor1_id"].intValue
                self.label_supervisor_remarks_name.text = swiftyJsonVar["fields"]["supervisor1_name"].stringValue
                SubordinateLeaveApplicationRequestViewController.supervisor2_id = swiftyJsonVar["fields"]["supervisor2_id"].intValue
                self.label_final_supervisor_remarks_name.text = swiftyJsonVar["fields"]["supervisor2_name"].stringValue
//                self.txt_view_supervisor_remarks.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                SubordinateLeaveApplicationRequestViewController.leave_id = swiftyJsonVar["fields"]["leave_id"].intValue
                
               
                
                if swiftyJsonVar["fields"]["approved_by_id"].intValue == 0 {
                    self.txt_view_supervisor_remarks.isUserInteractionEnabled = true
                    self.txt_view_supervisor_remarks.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                }else{
                    self.txt_view_supervisor_remarks.isUserInteractionEnabled = false
                    self.txt_view_supervisor_remarks.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                    self.custom_label_btn_save.isUserInteractionEnabled = false
                    self.custom_label_btn_save.alpha = 0.6
//                    self.custom_label_btn_save.backgroundColor = UIColor(hexFromString: "F4F4F1")
                    
                    self.btn_select_status.isUserInteractionEnabled = false
                    self.btn_select_status.setTitle(swiftyJsonVar["fields"]["leave_status"].stringValue, for: .normal)
                }
                
               }
               
           }
       }
       //--------function to show leave application request details using Alamofire and Json Swifty code ends------------
    
    //-----function to save data, code starts---
    func SaveData(){
        let url = "\(BASE_URL)leave/application/save"
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: date))
        
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "appliction_id": SubordinateLeaveApplicationViewController.appliction_id!,
            "leave_id": SubordinateLeaveApplicationRequestViewController.leave_id!,
            "employee_id": 0,
            "from_date": txt_from_date.text!,
            "to_date": txt_to_date.text!,
            "total_days": label_day_count.text!,
            "description": txt_view_details.text!,
            "supervisor_remark": txt_view_supervisor_remarks.text!,
            "leave_status": od_status!,
            "approved_by_id": swiftyJsonvar1["employee"]["employee_id"].stringValue,
            "approved_date": dateFormatter.string(from: date),
            "supervisor1_id": SubordinateLeaveApplicationRequestViewController.supervisor1_id!,
            "supervisor2_id": SubordinateLeaveApplicationRequestViewController.supervisor1_id!
            
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
                                self.performSegue(withIdentifier: "subleaveappltn", sender: nil)
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
