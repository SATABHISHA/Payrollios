//
//  SubordinateOdDutyLogEmployeeTaskViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift


struct SubordinateTaskDetails{
    var od_duty_task_detail_id: Int!
    var od_duty_task_head_id: Int!
    var task_name: String!
    var task_description: String!
    var saved_from_mobile_app: Int!
    var Task_delete_api_call: Int!
    
}
class SubordinateOdDutyLogEmployeeTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TxtViewRemarks: UITextView!
    @IBOutlet weak var LabelSupervisorName: UILabel!
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var NavTaskDate: UILabel!
    @IBOutlet weak var NavName: UILabel!
    @IBOutlet weak var tableViewEmpTask: UITableView!
    @IBOutlet weak var CustomBtnBack: UIView!
    @IBOutlet weak var CustomBtnCancel: UIView!
    @IBOutlet weak var CustomBtnReturn: UIView!
    @IBOutlet weak var CustomBtnApprove: UIView!
    var tableChildData = [SubordinateTaskDetails]()
    
    
    @IBOutlet weak var ViewLine: UIView!
    @IBOutlet weak var LabelSupervisorRemarkTitle: UILabel!
    @IBOutlet weak var TxtViewRemarksHeightConstraint: NSLayoutConstraint!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    var arrRes = [[String:AnyObject]]()
    static var od_duty_task_head_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor()
        
        self.tableViewEmpTask.dataSource = self
        self.tableViewEmpTask.delegate = self
        self.tableViewEmpTask.backgroundColor = UIColor(hexFromString: "ffffff")

        TxtViewRemarks.backgroundColor = UIColor(hexFromString: "ffffff")
        // Do any additional setup after loading the view.
        
        //============keyboard will show/hide, code starts==========
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //============keyboard will show/hide, code ends===========
        
        
        //Back
        let tapGestureRecognizerBack = UITapGestureRecognizer(target: self, action: #selector(Back(tapGestureRecognizer:)))
        CustomBtnBack.isUserInteractionEnabled = true
        CustomBtnBack.addGestureRecognizer(tapGestureRecognizerBack)
        
        //Cancel
        let tapGestureRecognizerCancel = UITapGestureRecognizer(target: self, action: #selector(Cancel(tapGestureRecognizer:)))
        CustomBtnCancel.isUserInteractionEnabled = true
        CustomBtnCancel.addGestureRecognizer(tapGestureRecognizerCancel)
        
        //Return
        let tapGestureRecognizerReturn = UITapGestureRecognizer(target: self, action: #selector(Return(tapGestureRecognizer:)))
        CustomBtnReturn.isUserInteractionEnabled = true
        CustomBtnReturn.addGestureRecognizer(tapGestureRecognizerReturn)
        
        //Approve
        let tapGestureRecognizerApprove = UITapGestureRecognizer(target: self, action: #selector(Approve(tapGestureRecognizer:)))
        CustomBtnApprove.isUserInteractionEnabled = true
        CustomBtnApprove.addGestureRecognizer(tapGestureRecognizerApprove)
        
        loadData()
    }
    
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
    
    //Back
     @objc func Back(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "subodlog", sender: nil)
         
     }
    
    //Cancel
     @objc func Cancel(tapGestureRecognizer: UITapGestureRecognizer){
       approve_return_cancel(task_status: "Cancelled")
     }
    
    //Cancel
     @objc func Return(tapGestureRecognizer: UITapGestureRecognizer){
       approve_return_cancel(task_status: "Returned")
     }
    
    //Approve
     @objc func Approve(tapGestureRecognizer: UITapGestureRecognizer){
      approve_return_cancel(task_status: "Approved")
     }
    //Submit
    //------function to save/submit, starts------
    func approve_return_cancel(task_status: String){
        let url = "\(BASE_URL)od/task/approval"
        print("save_url-=>",url)
        
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "od_duty_task_head_id": SubordinateOdDutyLogEmployeeTaskViewController.od_duty_task_head_id!,
            "task_status": task_status,
            "supervisor_remark": TxtViewRemarks.text!,
            "action_taken_by_id": swiftyJsonvar1["employee"]["employee_id"].intValue,
            "update_user": LoginViewController.entry_user
        ]
        
        print("SentData-=>",sentData)
                
                AF.request(url, method: .post, parameters: sentData, encoding: JSONEncoding.default, headers: nil).responseJSON{
                    response in
                    switch response.result{
                        
                    case .success:
//                        self.loaderEnd()
                        let swiftyJsonVar = JSON(response.value!)
                    
                        if swiftyJsonVar["status"].stringValue == "true"{
                            // Create new Alert
                            let dialogMessage = UIAlertController(title: "", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
//                                print("Ok button tapped")
                                
//                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
                                
                                self.loadData()
                                
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
                            
                            print("Error-=>",swiftyJsonVar["message"].stringValue)
                            
                           
                        }

                        break
                        
                    case .failure(let error):
//                        self.loaderEnd()
                        print("Error: ", error)
                    }
                }
        
    }
    //------function to save/submit, ends------
    
    //----------tableview code starts------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableChildData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateOdDtyLogEmployeeTaskTableViewCell
//        rowIndex = indexPath.row
        
        let dict = tableChildData[indexPath.row]
        
        cell.LabelTaskName.text = dict.task_name
        cell.LabelTaskDescription.text = dict.task_description
       
       
        
        return cell
        
    }
    
    //----------tableview code ends------------
    //--------function to load data using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        
        //---code to format date, starts----
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        let showDate = inputFormatter.date(from: SubordinateOdDutyLogListViewController.Log_task_date!)
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        //---code to format date, ends---
        let url = "\(BASE_URL)od/task/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(resultString)/\(SubordinateOdDutyLogListViewController.od_request_id!)/\(SubordinateOdDutyLogListViewController.Log_employee_id!)/"
        print("odDutyEmpTaskurl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log Emp description: \(swiftyJsonVar)")
                   
                SubordinateOdDutyLogEmployeeTaskViewController.od_duty_task_head_id = swiftyJsonVar["od_duty_task_head_id"].intValue
//                OdDutyLogEmployeeTaskViewController.task_status = swiftyJsonVar["task_status"].stringValue
                self.NavName.text = swiftyJsonVar["employee_name"].stringValue
                self.NavTaskDate.text = "Task Details of \(swiftyJsonVar["task_date"].stringValue)"
                self.LabelSupervisorName.text = "By \(swiftyJsonVar["action_taken_by_name"].stringValue)"
                self.TxtViewRemarks.text = swiftyJsonVar["supervisor_remark"].stringValue
                self.TxtViewRemarks.textColor = UIColor(hexFromString: "#7b7a7a")
                
                
                if swiftyJsonVar["task_status"] == "Saved" {
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewEmpTask.bounds.size.width, height: self.tableViewEmpTask.bounds.size.height))
                    noDataLabel.text          = "No OD task detail exists for this day"
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tableViewEmpTask.backgroundView  = noDataLabel
                    self.tableViewEmpTask.separatorStyle  = .none
                    
                    self.LabelStatus.isHidden = true
                    self.LabelSupervisorName.isHidden = true
                    self.LabelSupervisorRemarkTitle.isHidden = true
                    self.TxtViewRemarks.isHidden = true
                    self.TxtViewRemarksHeightConstraint.constant = 0
                    
                    self.CustomBtnCancel.isUserInteractionEnabled = false
                    self.CustomBtnCancel.alpha = 0.6
                    
                    self.CustomBtnReturn.isUserInteractionEnabled = false
                    self.CustomBtnReturn.alpha = 0.6
                    
                    self.CustomBtnApprove.isUserInteractionEnabled = false
                    self.CustomBtnApprove.alpha = 0.6
                    
                    self.ViewLine.isHidden = true
                    self.tableViewEmpTask.isHidden = true
                    
                    
                    
                }else if swiftyJsonVar["task_status"] == "Submitted" {
                    
                    
                   
                    
                    self.LabelStatus.text = swiftyJsonVar["task_status"].stringValue
//                    self.LabelSupervisorName.text =
                    
                } else if swiftyJsonVar["task_status"] == "Approved" {
                    self.LabelStatus.text = swiftyJsonVar["task_status"].stringValue
//                    self.LabelSupervisorName.text =
                    self.CustomBtnCancel.isUserInteractionEnabled = false
                    self.CustomBtnCancel.alpha = 0.6
                    
                    self.CustomBtnReturn.isUserInteractionEnabled = false
                    self.CustomBtnReturn.alpha = 0.6
                    
                    self.CustomBtnApprove.isUserInteractionEnabled = false
                    self.CustomBtnApprove.alpha = 0.6
                    
                    self.TxtViewRemarks.isUserInteractionEnabled = false
                    
                } else if swiftyJsonVar["task_status"] == "Returned" {
                    self.LabelStatus.text = swiftyJsonVar["task_status"].stringValue
//                    self.LabelSupervisorName.text =
                    self.CustomBtnCancel.isUserInteractionEnabled = false
                    self.CustomBtnCancel.alpha = 0.6
                    
                    self.CustomBtnReturn.isUserInteractionEnabled = false
                    self.CustomBtnReturn.alpha = 0.6
                    
                    self.CustomBtnApprove.isUserInteractionEnabled = false
                    self.CustomBtnApprove.alpha = 0.6
                    
                    self.TxtViewRemarks.isUserInteractionEnabled = false
                } else if swiftyJsonVar["task_status"] == "Cancelled" {
                    self.LabelStatus.text = swiftyJsonVar["task_status"].stringValue
//                    self.LabelSupervisorName.text =
                    self.CustomBtnCancel.isUserInteractionEnabled = false
                    self.CustomBtnCancel.alpha = 0.6
                    
                    self.CustomBtnReturn.isUserInteractionEnabled = false
                    self.CustomBtnReturn.alpha = 0.6
                    
                    self.CustomBtnApprove.isUserInteractionEnabled = false
                    self.CustomBtnApprove.alpha = 0.6
                    
                    self.TxtViewRemarks.isUserInteractionEnabled = false
                    
                } else if swiftyJsonVar["task_status"] == "" {
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewEmpTask.bounds.size.width, height: self.tableViewEmpTask.bounds.size.height))
                    noDataLabel.text          = "No OD task detail exists for this day"
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tableViewEmpTask.backgroundView  = noDataLabel
                    self.tableViewEmpTask.separatorStyle  = .none
                    
                    self.LabelStatus.isHidden = true
                    self.LabelSupervisorName.isHidden = true
                    self.LabelSupervisorRemarkTitle.isHidden = true
                    self.TxtViewRemarks.isHidden = true
                    self.TxtViewRemarksHeightConstraint.constant = 0
                    
                    self.CustomBtnCancel.isUserInteractionEnabled = false
                    self.CustomBtnCancel.alpha = 0.6
                    
                    self.CustomBtnReturn.isUserInteractionEnabled = false
                    self.CustomBtnReturn.alpha = 0.6
                    
                    self.CustomBtnApprove.isUserInteractionEnabled = false
                    self.CustomBtnApprove.alpha = 0.6
                    
                    self.ViewLine.isHidden = true
                }
                if swiftyJsonVar["task_status"] != ""{
                    for (key,value) in  swiftyJsonVar["tasks"]{
                        var data = SubordinateTaskDetails()
                        data.Task_delete_api_call = 1
                        data.od_duty_task_detail_id = value["od_duty_task_detail_id"].intValue
                        data.od_duty_task_head_id = value["od_duty_task_head_id"].intValue
                        data.task_name = value["task_name"].stringValue
                        data.task_description = value["task_description"].stringValue
                        data.saved_from_mobile_app = 1
                        
                        self.tableChildData.append(data)
                    }
                    
                    if self.tableChildData.count > 0 {
                        self.tableViewEmpTask.reloadData()
                    }
                }
                
                
                                    
                 /*  if let resData = swiftyJsonVar["items"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.tableviewOdDutyLog.reloadData()
                   }else{
                       self.tableviewOdDutyLog.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewOdDutyLog.bounds.size.width, height: self.tableviewOdDutyLog.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.tableviewOdDutyLog.backgroundView  = noDataLabel
                       self.tableviewOdDutyLog.separatorStyle  = .none
                       
                   }*/
               }
               
           }
       }
       //--------function to load data using Alamofire and Json Swifty code ends------------
    
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
