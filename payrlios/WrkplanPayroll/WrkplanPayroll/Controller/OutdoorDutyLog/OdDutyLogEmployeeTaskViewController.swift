//
//  OdDutyLogEmployeeTaskViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 01/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

struct TaskDetails{
    var od_duty_task_detail_id: Int!
    var od_duty_task_head_id: Int!
    var task_name: String!
    var task_description: String!
    var saved_from_mobile_app: Int!
    var Task_delete_api_call: Int!
    
}
class OdDutyLogEmployeeTaskViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, OdDutyLogEmpTaskTableViewCellDelegate {
   
    @IBOutlet weak var tableViewEmpTask: UITableView!
    @IBOutlet weak var ScrollViewOdTask: UIScrollView!
    @IBOutlet weak var NewTask: UIView!
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var labelSupervisorRemark: UILabel!
    @IBOutlet weak var labelSupervisorRemarkHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelSupervisorName: UILabel!
    @IBOutlet weak var tvSupervisorRemark: UITextView!
    @IBOutlet weak var tvSupervisorRemarkHeight: NSLayoutConstraint!
    
    @IBOutlet weak var NavBarName: UILabel!
    @IBOutlet weak var NavBarTaskDate: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    static var od_duty_task_head_id: Int!
    
    var tableChildData = [TaskDetails]()
    var collectUpdatedDetailsData = [Any]()
    
    
    @IBOutlet weak var customViewBtnBack: UIView!
    @IBOutlet weak var customViewBtnSave: UIView!
    @IBOutlet weak var customViewBtnSubmit: UIView!
    @IBOutlet weak var navbtnNewTask: UIButton!
    
    static var task_status: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeStatusBarColor()
//        tvSupervisorRemarkHeight.constant = 0
        if tableChildData.count > 0 {
            tableChildData.removeAll()
        }
        self.tableViewEmpTask.dataSource = self
        self.tableViewEmpTask.delegate = self
        self.tableViewEmpTask.backgroundColor = UIColor(hexFromString: "ffffff")
        
        tvSupervisorRemark.backgroundColor = UIColor(hexFromString: "ffffff")
        // Do any additional setup after loading the view.
//        ScrollViewOdTask.backgroundColor = UIColor(hexFromString: "#ffffff")
        print(OutdoorDutyLogListViewController.Log_employee_id!)
        
        //New Task
       /* let tapGestureRecognizerNewTaskView = UITapGestureRecognizer(target: self, action: #selector(NewTaskView(tapGestureRecognizer:)))
        NewTask.isUserInteractionEnabled = true
        NewTask.addGestureRecognizer(tapGestureRecognizerNewTaskView)*/
        
        //Save
        let tapGestureRecognizerSave = UITapGestureRecognizer(target: self, action: #selector(Save(tapGestureRecognizer:)))
         customViewBtnSave.isUserInteractionEnabled = true
        customViewBtnSave.addGestureRecognizer(tapGestureRecognizerSave)
        
        //Submit
        let tapGestureRecognizerSubmit = UITapGestureRecognizer(target: self, action: #selector(Submit(tapGestureRecognizer:)))
         customViewBtnSubmit.isUserInteractionEnabled = true
        customViewBtnSubmit.addGestureRecognizer(tapGestureRecognizerSubmit)
        
        //Back
        let tapGestureRecognizerBack = UITapGestureRecognizer(target: self, action: #selector(CustomBack(tapGestureRecognizer:)))
         customViewBtnBack.isUserInteractionEnabled = true
        customViewBtnBack.addGestureRecognizer(tapGestureRecognizerBack)
        
        loadData()
    }
    
    //Save
     @objc func Save(tapGestureRecognizer: UITapGestureRecognizer){
       save_submit(task_status: "Saved")
         
     }
    //Back
     @objc func CustomBack(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "odloglist", sender: nil)
         
     }
    
    @objc func Submit(tapGestureRecognizer: UITapGestureRecognizer){
        if (OutdoorDutyLogListViewController.od_status == "STOP" ||
                OutdoorDutyLogListViewController.od_status == "NA"){
            save_submit(task_status: "Submitted")
        }else{
            // Alert dialog, code starts
            let dialogMessage = UIAlertController(title: "Alert", message: "You cannot submit today's task(s) until OD Duty is stopped.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                dialogMessage.dismiss(animated: true, completion: nil)
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)

            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            // Alert dialog, code ends
        }
        
    }
    
    //Submit
    //------function to save/submit, starts------
    func save_submit(task_status: String){
        let url = "\(BASE_URL)od/task/save"
        print("save_url-=>",url)
        //---code to format date, starts----
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        let showDate = inputFormatter.date(from: OutdoorDutyLogListViewController.Log_task_date!)
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultStringTaskDate = inputFormatter.string(from: showDate!)
        //---code to format date, ends---
        
        var getData = [String:AnyObject]()
        for i in 0..<tableChildData.count{
            getData.updateValue(tableChildData[i].od_duty_task_head_id! as AnyObject, forKey: "od_duty_task_head_id")
            getData.updateValue(tableChildData[i].task_name! as AnyObject, forKey: "task_name")
            getData.updateValue(tableChildData[i].task_description! as AnyObject, forKey: "task_description")
            getData.updateValue(tableChildData[i].saved_from_mobile_app! as AnyObject, forKey: "saved_from_mobile_app")
            collectUpdatedDetailsData.append(getData)
        }
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "od_duty_task_head_id": OdDutyLogEmployeeTaskViewController.od_duty_task_head_id,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].intValue,
            "task_date": resultStringTaskDate,
            "od_request_id": OutdoorDutyLogListViewController.od_request_id!,
            "task_status": task_status,
            "entry_user": LoginViewController.entry_user,
            "saved_from_mobile_app": 1,
            "task_detail": collectUpdatedDetailsData
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
                                if self.tableChildData.count > 0 {
                                    self.tableChildData.removeAll()
                                    self.collectUpdatedDetailsData.removeAll()
                                    self.loadData()
                                }
                                
//                                self.tableViewEmpTask.reloadData()
                                
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
    
    
    //--------function to load data using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
//        if tableChildData.count > 0 {
//            tableChildData.removeAll()
//        }
       
        //---code to format date, starts----
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        let showDate = inputFormatter.date(from: OutdoorDutyLogListViewController.Log_task_date!)
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        //---code to format date, ends---
        let url = "\(BASE_URL)od/task/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(resultString)/\(OutdoorDutyLogListViewController.od_request_id!)/\(OutdoorDutyLogListViewController.Log_employee_id!)/"
        print("odDutyEmpTaskurl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log Emp description: \(swiftyJsonVar)")
                   
                OdDutyLogEmployeeTaskViewController.od_duty_task_head_id = swiftyJsonVar["od_duty_task_head_id"].intValue
                OdDutyLogEmployeeTaskViewController.task_status = swiftyJsonVar["task_status"].stringValue
                self.NavBarName.text = swiftyJsonVar["employee_name"].stringValue
                self.NavBarTaskDate.text = "Task Details of \(swiftyJsonVar["task_date"].stringValue)"
                self.labelSupervisorName.text = "By \(swiftyJsonVar["action_taken_by_name"].stringValue)"
                self.tvSupervisorRemark.text = swiftyJsonVar["supervisor_remark"].stringValue
                self.tvSupervisorRemark.textColor = UIColor(hexFromString: "#b2b2b2")
                self.tvSupervisorRemark.isEditable = false
                self.tvSupervisorRemark.isUserInteractionEnabled = false
                
                if swiftyJsonVar["task_status"] == "Saved" {
                    self.labelStatus.text = swiftyJsonVar["task_status"].stringValue
                    
                    self.viewLine.isHidden = true
                    self.labelSupervisorName.isHidden = true
                    self.labelSupervisorRemark.isHidden = true
                    self.labelSupervisorRemarkHeightConstraint.constant = 0
                    self.tvSupervisorRemark.isHidden = true
                    self.tvSupervisorRemarkHeight.constant = 0
                }else if swiftyJsonVar["task_status"] == "Submitted" {
                    self.navbtnNewTask.isHidden = true
                    self.navbtnNewTask.isUserInteractionEnabled = false
                    self.navbtnNewTask.isEnabled = false
                    
                    self.labelStatus.text = swiftyJsonVar["task_status"].stringValue
                    
                    self.viewLine.isHidden = true
                    self.labelSupervisorName.isHidden = true
                    self.labelSupervisorRemark.isHidden = true
                    self.labelSupervisorRemarkHeightConstraint.constant = 0
                    self.tvSupervisorRemark.isHidden = true
                    self.tvSupervisorRemarkHeight.constant = 0
                    
                    self.customViewBtnSave.isUserInteractionEnabled = false
                    self.customViewBtnSave.alpha = 0.6
                    
                    self.customViewBtnSubmit.isUserInteractionEnabled = false
                    self.customViewBtnSubmit.alpha = 0.6
                } else if swiftyJsonVar["task_status"] == "Approved" {
                    self.navbtnNewTask.isHidden = true
                    self.navbtnNewTask.isUserInteractionEnabled = false
                    self.navbtnNewTask.isEnabled = false
                    
                    self.labelStatus.text = swiftyJsonVar["task_status"].stringValue
                    
                    self.viewLine.isHidden = false
                    self.labelSupervisorName.isHidden = false
                    self.labelSupervisorRemark.isHidden = false
//                    self.labelSupervisorRemarkHeightConstraint.constant = 0
                    self.tvSupervisorRemark.isHidden = false
//                    self.tvSupervisorRemarkHeight.constant = 0
                    
                    self.customViewBtnSave.isUserInteractionEnabled = false
                    self.customViewBtnSave.alpha = 0.6
                    
                    self.customViewBtnSubmit.isUserInteractionEnabled = false
                    self.customViewBtnSubmit.alpha = 0.6
                } else if swiftyJsonVar["task_status"] == "Returned" {
                    self.navbtnNewTask.isHidden = true
                    self.navbtnNewTask.isUserInteractionEnabled = false
                    self.navbtnNewTask.isEnabled = false
                    
                    self.labelStatus.text = swiftyJsonVar["task_status"].stringValue
                    
                    self.viewLine.isHidden = false
                    self.labelSupervisorName.isHidden = false
                    self.labelSupervisorRemark.isHidden = false
//                    self.labelSupervisorRemarkHeightConstraint.constant = 0
                    self.tvSupervisorRemark.isHidden = false
//                    self.tvSupervisorRemarkHeight.constant = 0
                    
                    self.customViewBtnSave.isUserInteractionEnabled = false
                    self.customViewBtnSave.alpha = 0.6
                    
                } else if swiftyJsonVar["task_status"] == "Cancelled" {
                    self.navbtnNewTask.isHidden = true
                    self.navbtnNewTask.isUserInteractionEnabled = false
                    self.navbtnNewTask.isEnabled = false
                    
                    self.labelStatus.text = swiftyJsonVar["task_status"].stringValue
                    
                    self.viewLine.isHidden = false
                    self.labelSupervisorName.isHidden = false
                    self.labelSupervisorRemark.isHidden = false
//                    self.labelSupervisorRemarkHeightConstraint.constant = 0
                    self.tvSupervisorRemark.isHidden = false
//                    self.tvSupervisorRemarkHeight.constant = 0
                    
                    self.customViewBtnSave.isUserInteractionEnabled = false
                    self.customViewBtnSave.alpha = 0.6
                    
                    self.customViewBtnSubmit.isUserInteractionEnabled = false
                    self.customViewBtnSubmit.alpha = 0.6
                } else if swiftyJsonVar["task_status"] == "" {
                    self.labelStatus.text = swiftyJsonVar["task_status"].stringValue
                    
                    self.viewLine.isHidden = true
                    self.labelSupervisorName.isHidden = true
                    self.labelSupervisorRemark.isHidden = true
                    self.labelSupervisorRemarkHeightConstraint.constant = 0
                    self.tvSupervisorRemark.isHidden = true
                    self.tvSupervisorRemarkHeight.constant = 0
                    
                    if self.tableChildData.count == 0 {
                        self.customViewBtnSave.isUserInteractionEnabled = false
                        self.customViewBtnSave.alpha = 0.6
                        
                        self.customViewBtnSubmit.isUserInteractionEnabled = false
                        self.customViewBtnSubmit.alpha = 0.6
                    }
                }
                if swiftyJsonVar["task_status"] != ""{
                    for (key,value) in  swiftyJsonVar["tasks"]{
                        var data = TaskDetails()
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
    @IBAction func btnNewTask(_ sender: Any) {
        //---code to format given date, starts----
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        let showDate = inputFormatter.date(from: OutdoorDutyLogListViewController.Log_task_date!)
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultStringGivenDate = inputFormatter.string(from: showDate!)
        //---code to format given date, ends---
        
        //----code to format current date, starts--
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
        var CurrentDate = dateFormatter.string(from: todaysDate as Date)
        //----code to format current date, ends--
        
        let dayDiff = daysBetween(start: resultStringGivenDate, end: CurrentDate)
        if dayDiff > 0{
            print("test Date Expired")
            let dialogMessage = UIAlertController(title: "", message: "You cannot add task for a expired OD Duty", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
//                                print("Ok button tapped")
                
//                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
                
               
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)

            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
        }else{
            openFormNewTaskPopup()
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "odloglist", sender: nil)
    }
    
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
    //---New Task
   /* @objc func NewTaskView(tapGestureRecognizer: UITapGestureRecognizer){
      
//        print("tapped")
        
    }*/
    
    
    //----------tableview code starts------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableChildData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OdDutyLogEmpTaskTableViewCell
//        rowIndex = indexPath.row
        
        cell.delegate = self
        
        let dict = tableChildData[indexPath.row]
        
        cell.labelTaskName.text = dict.task_name
        cell.labelTaskDescription.text = dict.task_description
       
        if  OdDutyLogEmployeeTaskViewController.task_status == "Returned"{
            cell.imgviewDeleteRecord.isHidden = true
            cell.imgViewEditRecordTrailingConstraint.constant = -40
        }
        if  OdDutyLogEmployeeTaskViewController.task_status == "Submitted"{
            cell.imgviewDeleteRecord.isHidden = true
            cell.imgViewEditRecord.isHidden = true
        }
        if  OdDutyLogEmployeeTaskViewController.task_status == "Cancelled"{
            cell.imgviewDeleteRecord.isHidden = true
            cell.imgViewEditRecord.isHidden = true
        }
        if  OdDutyLogEmployeeTaskViewController.task_status == "Approved"{
            cell.imgviewDeleteRecord.isHidden = true
            cell.imgViewEditRecord.isHidden = true
        }
       
        
        return cell
        
    }
    
    func OdDutyLogEmpTaskTableViewCellDidTapDeleteTask(_ sender: OdDutyLogEmpTaskTableViewCell) {
        guard let tappedIndexPath = tableViewEmpTask.indexPath(for: sender) else {return}
        let rowData = tableChildData[tappedIndexPath.row]
        tableChildData.remove(at: tappedIndexPath.row)
        tableViewEmpTask.reloadData()
    }
    static var indexPath: Int!
    func OdDutyLogEmpTaskTableViewCellDidTapEditTask(_ sender: OdDutyLogEmpTaskTableViewCell) {
        guard let tappedIndexPath = tableViewEmpTask.indexPath(for: sender) else {return}
        OdDutyLogEmployeeTaskViewController.indexPath = tappedIndexPath.row
        
        let rowData = tableChildData[tappedIndexPath.row]
        let taskName = rowData.task_name!
        let taskDescription = rowData.task_description!
        print("Task name-=>",taskName)
        print("Task Desc-=>",taskDescription)
        openFormModifyTaskPopup(taskName: taskName, taskDescription: taskDescription)
    }
    //----------tableview code ends------------
    //-----------dismiss keyboard on touching anywhere in the screen code starts-----------
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
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
    
    //-------Form NewTask disalog, code starts-----
    @IBOutlet var viewNewTask: UIView!
    @IBOutlet weak var txtViewTaskName: UITextView!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBAction func btnAddTask(_ sender: Any) {
        var data = TaskDetails()
        data.od_duty_task_head_id = OdDutyLogEmployeeTaskViewController.od_duty_task_head_id
        data.od_duty_task_detail_id = OdDutyLogEmployeeTaskViewController.od_duty_task_head_id
        data.task_name = txtViewTaskName.text
        data.task_description = txtViewDescription.text
        data.saved_from_mobile_app = 1
        data.Task_delete_api_call = 0
        tableChildData.append(data)
        
        
        
        if self.tableChildData.count > 0 {
            self.customViewBtnSave.isUserInteractionEnabled = true
            self.customViewBtnSave.alpha = 1.0
            
            self.customViewBtnSubmit.isUserInteractionEnabled = true
            self.customViewBtnSubmit.alpha = 1.0
        }
        
        cancelFormNewTasktPopup()
        tableViewEmpTask.reloadData()
    }
    @IBAction func btnCancel(_ sender: Any) {
        cancelFormNewTasktPopup()
    }
    func openFormNewTaskPopup(){
        blurEffect()
        self.view.addSubview(viewNewTask)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        viewNewTask.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewNewTask.center = self.view.center
        viewNewTask.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewNewTask.alpha = 0
        viewNewTask.sizeToFit()
        
        txtViewTaskName.text = ""
        txtViewDescription.text = ""
        txtViewTaskName.backgroundColor = UIColor(hexFromString: "ffffff")
        txtViewDescription.backgroundColor = UIColor(hexFromString: "ffffff")
        

      /*  stackViewButtonborder.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        view_custom_btn_punchout.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)*/
        
        
        
        
        UIView.animate(withDuration: 0.3){
            self.viewNewTask.alpha = 1
            self.viewNewTask.transform = CGAffineTransform.identity
        }
        
    }
    
    func cancelFormNewTasktPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewNewTask.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewNewTask.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewNewTask.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //-------Form NewTask disalog, code ends-----
    
    //---------Form ModifyTask dialog, code starts-------
    @IBOutlet var viewModifyTask: UIView!
    @IBOutlet weak var txtViewModifyTaskName: UITextView!
    @IBOutlet weak var txtViewModifyDescription: UITextView!
    @IBAction func btnModifyTask(_ sender: Any) {
        print("Indexpath test-=>",OdDutyLogEmployeeTaskViewController.indexPath)
        tableChildData[OdDutyLogEmployeeTaskViewController.indexPath].task_name = txtViewModifyTaskName.text
        tableChildData[OdDutyLogEmployeeTaskViewController.indexPath].task_description = txtViewModifyDescription.text
        tableChildData.remove(at: OdDutyLogEmployeeTaskViewController.indexPath+1)
        
        cancelFormModifyTasktPopup()
        
        if OdDutyLogEmployeeTaskViewController.task_status == "Returned"{
            self.customViewBtnSave.isUserInteractionEnabled = false
            self.customViewBtnSave.alpha = 0.6
        }
        tableViewEmpTask.reloadData()
        
    }
    @IBAction func btnModifyTaskCancel(_ sender: Any) {
        cancelFormModifyTasktPopup()
    }
    func openFormModifyTaskPopup(taskName: String, taskDescription: String){
        blurEffect()
        self.view.addSubview(viewModifyTask)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        viewModifyTask.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewModifyTask.center = self.view.center
        viewModifyTask.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewModifyTask.alpha = 0
        viewModifyTask.sizeToFit()
        
        txtViewModifyTaskName.backgroundColor = UIColor(hexFromString: "ffffff")
        txtViewModifyDescription.backgroundColor = UIColor(hexFromString: "ffffff")

      /*  stackViewButtonborder.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        view_custom_btn_punchout.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)*/
        
        txtViewModifyTaskName.text = taskName
        txtViewModifyDescription.text = taskDescription
        
        
        UIView.animate(withDuration: 0.3){
            self.viewModifyTask.alpha = 1
            self.viewModifyTask.transform = CGAffineTransform.identity
        }
        
    }
    
    func cancelFormModifyTasktPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewModifyTask.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewModifyTask.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewModifyTask.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //---------Form ModifyTask dialog, code ends-------
    
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
