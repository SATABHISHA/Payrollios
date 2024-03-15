//
//  DashboardViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 25/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Toast_Swift
import FSCalendar
import DropDown
import UserNotifications
import CoreData
import AVFoundation
import Lottie
import SwiftUI

struct NavigationDashboardMenuData{
    var imageData:UIImage!
    var menuItm:String!
}

//---added on 27-Feb-2024, code starts
// Define a structure to represent the data
struct LocationData: Decodable {
    let validFrom: String
    let validUpto: String
    let latitude: Double
    let longitude: Double
}
//---added on 27-Feb-2024, code ends

class DashboardViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate, AVCaptureMetadataOutputObjectsDelegate {

    
    
    @IBOutlet weak var NavView: UIView! //---added on 12-Mar-2024
    
    //---added on 27-Feb-2024, code starts
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    //---added on 27-Feb-2024, code ends
    
    @IBOutlet weak var ScrollViewContainer: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    //----Menubar variables, starts-----
    @IBOutlet weak var ImgLogoutMenuBar: UIImageView!
    let sharedpreferences = UserDefaults.standard
    //----Menubar variables, ends-----
    
    //-----Notification variable, starts-----
    let userNotificationCenter = UNUserNotificationCenter.current() 
    let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
    
    var db: OpaquePointer? //---added on 09-Mar-2022
    var arrResNotification = [[String:Any]]()
    
    static var NotificationYN: Bool = false
    @IBOutlet weak var NotificationImageView: UIImageView!
    //-----Notification variable, ends-----
    
    //---------variables for navigation drawer starts-------
    @IBOutlet weak var navigationLogoCompany: UIImageView!
    @IBOutlet weak var navigationDesignation: UILabel!
    @IBOutlet weak var navigationProfileImg: UIImageView!
    @IBOutlet weak var navigationDrawer: UIView!
    @IBOutlet weak var navigationEmployeeName: UILabel!
    @IBOutlet weak var navigationCompanyName: UILabel!
    @IBOutlet weak var tableViewNavigation: UITableView!
    @IBOutlet weak var navigationDrawerTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var navigationDrawerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationDrawerHeight: NSLayoutConstraint!
    
    var menuIsMenuShow = false
    var navigationDrawerData = [NavigationDashboardMenuData]()
    
    
    //---------variables for navigation drawer ends-------
    
    //----EmployeeDetail variables, starts----
    @IBOutlet weak var ViewEmpDetails: UIView!
    @IBOutlet weak var ViewChild: UIView!
    @IBOutlet weak var LabelEmpName: UILabel!
    @IBOutlet weak var LabelDesignation: UILabel!
    @IBOutlet weak var LabelDepartment: UILabel!
    @IBOutlet weak var LabelSupervisor1: UILabel!
    @IBOutlet weak var LabelSupervisor2: UILabel!
    //----EmployeeDetail variables, ends----
    
    //---Attendance variables, starts----
    @IBOutlet weak var label_wrk_from_home: UILabel!
    @IBOutlet weak var ViewAttendance: UIView!
    @IBOutlet weak var ViewChildAttendance: UIView!
    @IBOutlet weak var LabelInTime: UILabel!
    @IBOutlet weak var LabelOutTime: UILabel!
    @IBOutlet weak var TxtViewWFH: UITextView!
    @IBOutlet weak var TxtViewWFHHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var ViewBtnInOut: UIView!
    @IBOutlet weak var LabelInOut: UILabel!
    @IBOutlet weak var label_date_today: UILabel!
    @IBOutlet weak var ViewInTime: UIView!
    @IBOutlet weak var ViewOutTime: UIView!
    @IBOutlet weak var LabelInTimeAbbrebiation: UILabel!
    @IBOutlet weak var LabelOutTimeAbbrebiation: UILabel!
    @IBOutlet weak var LabelInTitle: UILabel!
    @IBOutlet weak var LabelOutTitle: UILabel!
    
    @IBOutlet weak var ViewWfh: UIView!
    
    @IBOutlet weak var ImgViewAttendanceComplt: UIImageView!
    
    
    
    var checkBtnYN = 0
    var work_from_home_flag: Int!
    
    var timesheet_id: Int!
    var work_from_home_detail: String!
    
    var locationManager:CLLocationManager!
    static var currentlatitude:Double = 0.0
    static var currentLongitude:Double = 0.0
    static var currentAddress:String = ""
    
    //-----camera variables
    let imagePicker = UIImagePickerController()
    var base64String:String!
    
    //----added variables on 31st may for selfie
    static var in_out: String!, work_frm_home_flag: Int!, work_from_home_detail: String!, message_in_out: String!
    var crossButton: UIButton!
    
    //---Attendance variables, ends----
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    @IBOutlet weak var LabelCorpId: UILabel!
    
    //-------Calendar variable, starts----
    @IBOutlet weak var ViewCalendar: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    var arrResCaledar = [[String:AnyObject]]()
    @IBOutlet weak var LabelCalendarDate: UILabel!
    @IBOutlet weak var LabelCalendarDay: UILabel!
    @IBOutlet weak var LabelCalendarHoliday: UILabel!
    @IBOutlet weak var ViewCustomBtnApplyForLeave: UIView!
    @IBOutlet weak var ViewCustomBtnApplyForOD: UIView!
    static var DashboardToMyLeaveApplicationRequestNewCreateYN: Bool = false
    static var DashboardToMyODApplicationRequestNewCreateYN: Bool = false
    
    // first date in the range
    var firstDate: Date?
    // last date in the range
    var lastDate: Date?
    
    static var FirstDate: String!, LastDate: String!
     var datesRange: [Date]?
    
    //-------Calendar variable, ends----
    
    
    //------PaySlip variable, starts-----
    let dropDown = DropDown()
    var year_details = [YearDetails]()
    
    @IBOutlet weak var ViewPaySlip: UIView!
    @IBOutlet weak var BtnMonth: UIButton!
    @IBOutlet weak var ViewChildPaySlip: UIView!
    static var report_html: String!, year: String!, month_name: String!
    //------Payslip variable, ends-----
    
    //-----Pending Item(s) variable, starts-----
    
    @IBOutlet weak var ViewPendingItems: UIView!
    @IBOutlet weak var ViewChildPendingItems: UIView!
    @IBOutlet weak var TableViewPendingItems: UITableView!
    var arrResPendingItems = [[String:AnyObject]]()
    static var event_id: String!, event_owner_id: String!
    static var NotificationPendingItemsYN: Bool = false
    static var LeaveType: String = ""
    
    //-----Pending Item(s) variable, ends-----
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        openAttendanceConfirmationPopup(AttendanceConfirmationMsg: "Attendance IN time recorded") //---added temporary
        // Do any additional setup after loading the view.
//        ViewBtnInOut.setCornerRadius(cornerRadius: 10, topLeft: false, bottomLeft: false, topRight: true, bottomRight: true, leftBorder: false, rightBorder: true, topBorder: true, bottomBorder: true, borderColor: UIColor.gray)
//        ViewBtnInOut.roundCorners(corners: [.topRight, .bottomRight], radius: 10)
        /*NavView.clipsToBounds = true
        NavView.layer.masksToBounds = true*/
//        NavView.backgroundColor = UIColor.red
       
    
//        NavView.layer.bounds.size.width = UIScreen.main.bounds.width
        /*NavView.applyGradient(view: NavView,
            colors: [UIColor(hexFromString: "#084F95"), UIColor(hexFromString: "#64B5F6")],
                    startPoint: CGPoint(x: 0, y: 0),
                    endPoint: CGPoint(x: 1, y: 1)
                )*/
        //---added on 13-Mar-2024, code starts
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)),name: UIApplication.didBecomeActiveNotification,object: nil)
        //---added on 13-Mar-2024, code ends
        
        
        LoadSwipeGuesture()
        LoadNotificationDetails()
        LoadNavigationBarData()
        LoadNavigationDrawerData()
        ChangeStatusBarColor()
        LoadEmployeeDetails()
        LoadAttendanceData()
        LoadCalendarDetails()
        LoadPendingItemDetails()
        LoadSalaryData()
        
    }
    
    
    //---added on 13-Mar-2024, code starts
    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        load_data_check_od_duty()
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    //---added on 13-Mar-2024, code ends
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TxtViewWFH.delegate = self    // Give TextViewMessage delegate Method
        
        TxtViewWFH.text = "Type Work From Home Reason"
        TxtViewWFH.textColor = UIColor.lightGray
    }
    
    //===========///----Swipe Guesture, code starts----///========
    func LoadSwipeGuesture(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
                
            leftSwipe.direction = .left
            rightSwipe.direction = .right

            view.addGestureRecognizer(leftSwipe)
            view.addGestureRecognizer(rightSwipe)
    }
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
            
        if (sender.direction == .left) {
            menuShow()
        }
       /* if (sender.direction == .right) {
            menuShow()
        }*/
    }
    //===========///----Swipe Guesture, code ends----///========
   
    //=============///---FormDialog Change Password code starts--/////===========
    
    @IBOutlet var viewFormDialogChangePassword: UIView!
    
    @IBOutlet weak var btnPasswordChangeSubmit: UIButton!
    @IBOutlet weak var labelPasswordCheck: UILabel!
    @IBOutlet weak var tvCurrentPassword: UITextField!
    @IBOutlet weak var tvNewPassword: UITextField!
    @IBAction func tvRetypeNewPassword(_ sender: Any) {
        labelPasswordCheck.isHidden = false
        if tvNewPassword.text! == ""{
            labelPasswordCheck.text = "Please enter your new password first"
            tvRetypeNewPassword.text = ""
        }else if tvNewPassword.text! != ""{
            if tvNewPassword.text! == tvRetypeNewPassword.text! {
                labelPasswordCheck.text = "Correct Password"
                btnPasswordChangeSubmit.alpha = 1
                btnPasswordChangeSubmit.isEnabled = true
                btnPasswordChangeSubmit.isUserInteractionEnabled = true
            }else{
                labelPasswordCheck.text = "Incorrect Password"
                btnPasswordChangeSubmit.alpha = 0.3
                btnPasswordChangeSubmit.isEnabled = false
                btnPasswordChangeSubmit.isUserInteractionEnabled = false
            }
        }
    }
    @IBOutlet weak var tvRetypeNewPassword: UITextField!
    @IBOutlet weak var tvPasswordHint: UITextField!
    @IBAction func tvPasswordHint(_ sender: Any) {
        if (tvCurrentPassword.text! != "" && tvRetypeNewPassword.text! != "" && tvPasswordHint.text! != ""){
            btnPasswordChangeSubmit.alpha = 1
            btnPasswordChangeSubmit.isEnabled = true
            btnPasswordChangeSubmit.isUserInteractionEnabled = true
        }else if(tvCurrentPassword.text! == "" || tvRetypeNewPassword.text! == "" || tvPasswordHint.text! == ""){
            btnPasswordChangeSubmit.alpha = 0.3
            btnPasswordChangeSubmit.isEnabled = false
            btnPasswordChangeSubmit.isUserInteractionEnabled = false
        }
    }
    
    func openPasswordChangePopup(){
        blurEffect()
        self.view.addSubview(viewFormDialogChangePassword)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewFormDialogChangePassword.layer.masksToBounds = true
        viewFormDialogChangePassword.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewFormDialogChangePassword.center = self.view.center
        viewFormDialogChangePassword.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewFormDialogChangePassword.alpha = 0
        viewFormDialogChangePassword.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.viewFormDialogChangePassword.alpha = 1
            self.viewFormDialogChangePassword.transform = CGAffineTransform.identity
        }
        labelPasswordCheck.isHidden = true
        btnPasswordChangeSubmit.alpha = 0.3
        btnPasswordChangeSubmit.isEnabled = false
        btnPasswordChangeSubmit.isUserInteractionEnabled = false
        tvCurrentPassword.resignFirstResponder()
        tvNewPassword.resignFirstResponder()
        tvRetypeNewPassword.resignFirstResponder()
        //        tvPasswordHint.resignFirstResponder()
    }
    
    func cancelPasswordChangePopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewFormDialogChangePassword.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewFormDialogChangePassword.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewFormDialogChangePassword.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    @IBAction func btnPasswordChangeSubmit(_ sender: Any) {
        print("tapped")
        ChangePassword()
    }
    @IBAction func btnPasswordChangeCancel(_ sender: Any) {
        cancelPasswordChangePopup()
    }
    
    //-----function to chnage password data, code starts---
    func ChangePassword(){
        let url = "\(BASE_URL)user/change-password"
        print("savelog_url-=>",url)
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].intValue,
            "old_pwd": tvCurrentPassword.text!,
            "new_pwd": tvNewPassword.text!
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
                    self.cancelPasswordChangePopup()
                    self.sharedpreferences.removeObject(forKey: "UserID")
                    self.sharedpreferences.synchronize()
                    self.performSegue(withIdentifier: "login", sender: self)
                    
                    let dialogMessage = UIAlertController(title: "", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                        
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
    
    //-----function to change password data, code ends---
    //=============////----FormDialog Change Password code ends--/////===========
    
    
    //-------/////---Notification, code starts--////-----
    func LoadNotificationDetails(){
        NotificationImageView.isHidden = true
        if fetchNotificationCount(employeeId: swiftyJsonvar1["employee"]["employee_id"].stringValue) == true {
            NotificationImageView.isHidden = false
        }else if fetchNotificationCount(employeeId: swiftyJsonvar1["employee"]["employee_id"].stringValue) == false{
            NotificationImageView.isHidden = true
        }
        
        self.userNotificationCenter.delegate = self
        
        self.requestNotificationAuthorization()
        
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
                // Do what you need to do repeatedly
            self.LoadNotificationData()
            }
        
        //NotificationView
        let tapGestureRecognizerImgNotification = UITapGestureRecognizer(target: self, action: #selector(ImgNotification(tapGestureRecognizer:)))
        NotificationImageView.isUserInteractionEnabled = true
        NotificationImageView.addGestureRecognizer(tapGestureRecognizerImgNotification)
    }
    //---Lta
    @objc func ImgNotification(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "notification", sender: nil)
    }  
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(title: String, body: String) {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.badge = NSNumber(value: 3)
        
        // Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "done",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "done",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func fetchNotificationCount(employeeId: String)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotification")
//            fetchRequest.predicate = NSPredicate(format: "companyOffice == %@ AND employNo == %@", companyOffice, employNo)
        fetchRequest.predicate = NSPredicate(format: "employeeid == %@", employeeId)

            let res = try! context.fetch(fetchRequest)
        print("countHome-=>", res)
            return !res.isEmpty
    }
    
    func CustomNotificationUpdate(notificationId: Int){
        let url = "\(BASE_URL)notification/custom/update"
        
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "notification_id": notificationId
        ]
        
        print("SentData-=>",sentData)
        
        AF.request(url, method: .post, parameters: sentData, encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in
            switch response.result{
                
            case .success:
                //                        self.loaderEnd()
                let swiftyJsonVar = JSON(response.value!)
                print("Return notifictaion response: ", swiftyJsonVar)
                
                
                break
                
            case .failure(let error):
                //                        self.loaderEnd()
                print("Error: ", error)
            }
        }
        
    }
    func LoadNotificationData(){
        let url = "\(BASE_URL)notification/custom/fetch/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("NotificationUrl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            //               self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log Notification description: \(swiftyJsonVar)")
                
                if !self.arrResNotification.isEmpty{
                    self.arrResNotification.removeAll()
                }
                
                if let resData = swiftyJsonVar["notifications"].arrayObject{
                    self.arrResNotification = resData as! [[String:AnyObject]]
                }
                if swiftyJsonVar["response"]["status"] == "true"{
                    print("Eureka")
                    if self.arrResNotification.count > 0 {
                        //Storing core data
                        //----code to insert data, starts---
//                        self.resetAllRecords(in: "UserNotification") //---commented on 11-Mar-2022
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let UserNotification = NSEntityDescription.insertNewObject(forEntityName: "UserNotification", into: context)
                        for items in self.arrResNotification{
                            UserNotification.setValue("\(self.swiftyJsonvar1["employee"]["employee_id"].stringValue)", forKey: "employeeid")
                            UserNotification.setValue("\(items)", forKey: "jsondata")
                            
                            var title: String = items["title"] as! String
                            
                            let body : String = items["body"] as! String
                            let fullbodyNotificationArr : [String] = body.components(separatedBy: "::")
                            var notificationId : String = fullbodyNotificationArr[0]
                            let fullbodyNotificationIdArray: [String] = notificationId.components(separatedBy: "=")
                            var notification_id_output : String = fullbodyNotificationIdArray[1]
                            
                            var event_name : String = fullbodyNotificationArr[1]
                            let fullbodyEventNameArray: [String] = event_name.components(separatedBy: "=")
                            var event_name_output : String = fullbodyEventNameArray[1]
                            
                            var event_id : String = fullbodyNotificationArr[2]
                            let fullbodyEventIdArray: [String] = event_id.components(separatedBy: "=")
                            var event_id_output : String = fullbodyEventIdArray[1]
                            
                            var event_owner : String = fullbodyNotificationArr[3]
                            let fullbodyEventOwnerArray: [String] = event_owner.components(separatedBy: "=")
                            var event_owner_output : String = fullbodyEventOwnerArray[1]
                            
                            var event_owner_id : String = fullbodyNotificationArr[4]
                            let fullbodyEventOwnerIdArray: [String] = event_owner_id.components(separatedBy: "=")
                            var event_owner_id_output : String = fullbodyEventOwnerIdArray[1]
                            
                            var message : String = fullbodyNotificationArr[5]
                            let fullbodyMessageArray: [String] = message.components(separatedBy: "=")
                            var message_output : String = fullbodyMessageArray[1]
                            
                            UserNotification.setValue("\(event_id_output)", forKey: "event_id")
                            UserNotification.setValue("\(event_name_output)", forKey: "event_name")
                            UserNotification.setValue("\(event_owner_output)", forKey: "event_owner")
                            UserNotification.setValue("\(event_owner_id_output)", forKey: "event_owner_id")
                            UserNotification.setValue("\(message_output)", forKey: "message")
                            UserNotification.setValue("\(title)", forKey: "title")
                            UserNotification.setValue("\(notification_id_output)", forKey: "notificationid")
                            UserNotification.setValue("N", forKey: "readyn")
                            do{
                               try context.save()
                                print("Saved")
                            }catch{
                                print("Error in saving data")
                            }
                        }
                       
                            
                            //---code to fetch data, starts
                            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotification")
                            request.returnsObjectsAsFaults = false
                            do{
                                let results = try context.fetch(request)
                                if results.count > 0
                                {
                                    for result in results as! [NSManagedObject]
                                    {
                                        if let jsonData = result.value(forKey: "jsondata") as? String{
                                            print("jsonNotificationData-=>", jsonData)
                                            
                                        }
                                       
                                        print("All results: ",result)
                                    }
                                          if let items = swiftyJsonVar["notifications"].array {
                                              for item in items {
                                                 /* if let title = item["title"].string {
                                                      print(title)
                                                  }*/
                                                  var title: String = item["title"].stringValue
                                                  let body : String = item["body"].stringValue
                                                  let fullbodyArr : [String] = body.components(separatedBy: "::")
                                                  
                                                  var message : String = fullbodyArr[5]
                                                  var fullMessageArr: [String] = message.components(separatedBy: "=")
                                                  var messageOutput : String = fullMessageArr[1]
                                                  
                                                  var event_id: String = fullbodyArr[0]
                                                  let fullbodyEventIdArray: [String] = event_id.components(separatedBy: "=")
                                                  var event_id_output : String = fullbodyEventIdArray[1]
                                                  print("Message-=>", messageOutput)
                                                  print("EventId-=>", event_id_output)
                                                  
                                                  self.sendNotification(title: title, body: messageOutput)
                                                  self.CustomNotificationUpdate(notificationId: Int(event_id_output)!)
                                              }
                                          }
                                    
                                    self.update(readyn: "N")
                                     }
                                   
//                            self.update(readyn: "N")
                            
                            
                        }catch{
                            //PROCESS ERROR
                        }
                        //----code to insert data, ends---
                    }
                }else if swiftyJsonVar["status"] == "false"{
                    print("false")
                }
                
            }
            
        }
    }
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
            print("Database cleaned")
        }
        catch
        {
            print ("There was an error")
        }
    }
    func update(readyn:String){
        
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "UserNotification")
        
        // 3
        let predicate = NSPredicate(format: "%K == %@", "readyn", readyn)
        fetchRequest.predicate = predicate
        
        //3
        
        do {
            let  rs = try managedContext.fetch(fetchRequest)
            
            for result in rs as [NSManagedObject] {
                
                // update
                do {
                    var managedObject = rs[0]
                    managedObject.setValue("Y", forKey: "readyn")
                    
                    try managedContext.save()
                    print("update successfull")
                    
                    
                } catch let error as NSError {
                    print("Could not Update. \(error), \(error.userInfo)")
                }
                //end update
                
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //-------/////---Notification, code ends--////-----
    
    
    //-------///////--Navigation Drawer, code starts--///////-----
    func LoadNavigationDrawerData(){
        navigationLogoCompany.isHidden = true
        navigationProfileImg.isHidden = true
        
        tableViewNavigation.dataSource = self
        tableViewNavigation.delegate = self
        tableViewNavigation.backgroundColor = UIColor.white
        
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        
        navigationDrawerLeadingConstraint.constant = -(navigationDrawer.frame.size.width)
        //        navigationDrawerLeadingConstraint.constant = 0
        navigationDrawerTrailingConstant.constant = view.frame.size.width
        print("navigationframe-=>",navigationDrawerLeadingConstraint.constant)
        print("navigationTrailing-=>", navigationDrawerTrailingConstant.constant)
        
        var k = NavigationDashboardMenuData()
        k.imageData = UIImage(named: "eminfo.png")
        k.menuItm = "Employee Information"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "leave.png")
        k.menuItm = "Leave"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "facilities.png")
        k.menuItm = "Employee Facilities"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "employeedocs.png")
        k.menuItm = "Employee Documents"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "organizationdocs.png")
        k.menuItm = "Company Documents"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "insurance.png")
        k.menuItm = "Insurance Detail"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "holiday.png")
        k.menuItm = "Holiday Detail"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "od_request")
        k.menuItm = "Outdoor Duty Request"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "od_duty")
        k.menuItm = "Outdoor Duty"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "timesheet")
        k.menuItm = "Attendance"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "advance")
        k.menuItm = "Advance"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "mediclaim")
        k.menuItm = "Medical Reimbursement"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "lta")
        k.menuItm = "LTA"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "reports")
        k.menuItm = "Reports"
        navigationDrawerData.append(k)
        
        k.imageData = UIImage(named: "password.png")
        k.menuItm = "Change Password"
        navigationDrawerData.append(k)
        k.imageData = UIImage(named: "logout.png")
        k.menuItm = "Logout"
        navigationDrawerData.append(k)
    }
    //--------tableview code starts--------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue:Int!
        if tableView == tableViewNavigation{
            returnValue = navigationDrawerData.count
        }else if tableView == TableViewPendingItems{
            returnValue = arrResPendingItems.count
        }
        return returnValue
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewNavigation {
        let cell = tableViewNavigation.dequeueReusableCell(withIdentifier: "cell") as! HomeNavigationControllerTableViewCell
        tableView.separatorColor = UIColor.white
        
            let dict = navigationDrawerData[indexPath.row]
        if dict.menuItm! == "Reports"{
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRect(x: 0.0, y: 43.0, width: cell.contentView.frame.size.width, height: 1.0)
            bottomBorder.backgroundColor = UIColor(hexFromString: "#c2c2c2").cgColor
            cell.contentView.layer.addSublayer(bottomBorder)
        }else{
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRect(x: 0.0, y: 43.0, width: cell.contentView.frame.size.width, height: 1.0)
            bottomBorder.backgroundColor = UIColor(hexFromString: "#ffffff").cgColor
            cell.contentView.layer.addSublayer(bottomBorder)
        }
        cell.imageViewMenu.image = dict.imageData
        cell.labelMenuItem.text = dict.menuItm
        return cell
        } else if tableView == TableViewPendingItems {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DashboardPendingItemsTableViewCell
            let dictPendingItems = arrResPendingItems[indexPath.row]
            cell.LabelEventStatus.text = dictPendingItems["event_status"] as? String
            cell.LabelEventType.text = dictPendingItems["event_type"] as? String
            cell.LabelEventOwnerName.text = dictPendingItems["event_owner_name"] as? String
            
            if dictPendingItems["event_status"] as! String == "Submitted"{
                cell.LabelEventStatus.textColor = UIColor(hexFromString: "aa1667")
            }else if dictPendingItems["event_status"] as! String == "Returned"{
                cell.LabelEventStatus.textColor = UIColor(hexFromString: "fd3d3d")
            }
            
          /*  if dictPendingItems["event_type"] as! String == "Casual Leave"{
                cell.LabelEventType.textColor = UIColor(hexFromString: "362c86")
            }else if dictPendingItems["event_type"] as! String == "Sick Leave"{
                cell.LabelEventType.textColor = UIColor(hexFromString: "4e4c4c")
            }else{
                cell.LabelEventType.textColor = UIColor(hexFromString: "4e4c4c")
            }*/
            cell.ViewEventNameAbbreviation.layer.cornerRadius = 3.0
            if dictPendingItems["event_name"] as! String == "Leave Application"{
                cell.LabelEventNameAbbreviation.text = "LA"
                cell.ViewEventNameAbbreviation.backgroundColor = UIColor(hexFromString: "9cc1e4")
            }else if dictPendingItems["event_name"] as! String == "OD Application" {
                cell.LabelEventNameAbbreviation.text = "OD"
                cell.ViewEventNameAbbreviation.backgroundColor = UIColor(hexFromString: "febf83")
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewNavigation{
            var row = navigationDrawerData[indexPath.row]
            if row.menuItm == "Employee Information"{
                menuClose()
                self.performSegue(withIdentifier: "empinfo", sender: nil)
            }else if row.menuItm == "Leave"{
                menuClose()
                self.performSegue(withIdentifier: "leave", sender: nil)
            }else if row.menuItm == "Employee Documents"{
                menuClose()
                self.performSegue(withIdentifier: "empdocs", sender: nil)
            }else if row.menuItm == "Employee Facilities"{
                menuClose()
                self.performSegue(withIdentifier: "empfacilities", sender: nil)
            }else if row.menuItm == "Company Documents"{
                menuClose()
                self.performSegue(withIdentifier: "companydoc", sender: nil)
            }else if row.menuItm == "Insurance Detail"{
                menuClose()
                self.performSegue(withIdentifier: "insurance", sender: nil)
            }else if row.menuItm == "Holiday Detail"{
                menuClose()
                self.performSegue(withIdentifier: "holiday", sender: self)
            }
            else if row.menuItm == "Outdoor Duty Request"{
                menuClose()
                self.performSegue(withIdentifier: "outdoordutylist", sender: self)
            }
            else if row.menuItm == "Outdoor Duty"{
                menuClose()
                self.performSegue(withIdentifier: "odloglist", sender: self)
            }
            else if row.menuItm == "Attendance"{
                menuClose()
                self.performSegue(withIdentifier: "timesheet", sender: self)
                
            }else if row.menuItm == "Advance"{
                menuClose()
                self.performSegue(withIdentifier: "advancerequisition", sender: nil)
                
            }else if row.menuItm == "Reports"{
                menuClose()
                self.performSegue(withIdentifier: "reports", sender: self)
            }else if row.menuItm == "Medical Reimbursement"{
                menuClose()
                self.performSegue(withIdentifier: "mediclaimlist", sender: self)
            }else if row.menuItm == "LTA"{
                menuClose()
                self.performSegue(withIdentifier: "lta", sender: self)
            } else if row.menuItm == "Change Password"{
                menuClose()
                openPasswordChangePopup()
            }else if row.menuItm == "Logout"{
                menuClose()
                openLogoutFormPopup()
            }
        } else if tableView == TableViewPendingItems{
            let dictPendingItems = arrResPendingItems[indexPath.row]
            print("Selected-=>", dictPendingItems["event_name"] as! String)
            if dictPendingItems["event_name"] as! String == "Leave Application"{
                DashboardViewController.event_id = String(dictPendingItems["event_id"] as! Int)
                DashboardViewController.event_owner_id = String(dictPendingItems["event_owner_id"] as! Int)
                DashboardViewController.NotificationPendingItemsYN = true
                DashboardViewController.LeaveType = dictPendingItems["event_type"] as! String
//                self.performSegue(withIdentifier: "subleaveappltn", sender: nil)
                self.performSegue(withIdentifier: "la", sender: nil)
            }else if dictPendingItems["event_name"] as! String == "OD Application" {
                print("EventId-=>",dictPendingItems["event_id"] as? Int)
                DashboardViewController.event_id = String(dictPendingItems["event_id"] as! Int)
                DashboardViewController.event_owner_id = String(dictPendingItems["event_owner_id"] as! Int)
                DashboardViewController.NotificationPendingItemsYN = true
                DashboardViewController.LeaveType = dictPendingItems["event_type"] as! String
                
                self.performSegue(withIdentifier: "od", sender: nil)
            }
        }
    }
    //--------tableview code ends--------
    //-----------function for navigation drawer code, starts-----------
    func menuShow(){
        if menuIsMenuShow{
            navigationLogoCompany.isHidden = true
            navigationProfileImg.isHidden = true
//            self.canelBlurEffect()
            ScrollView.isScrollEnabled = true
            //            self.view.removeFromSuperview()
            self.navigationDrawerLeadingConstraint.constant = -(navigationDrawer.frame.size.width)
            self.navigationDrawerTrailingConstant.constant = view.frame.size.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
//            blurEffect()
            navigationLogoCompany.isHidden = false
            navigationProfileImg.isHidden = false
            ScrollView.isScrollEnabled = false
            self.view.addSubview(navigationDrawer)
          
            let url = swiftyJsonvar1["employee"]["employee_image"].stringValue
            if url == "" {
                if swiftyJsonvar1["employee"]["gender"].stringValue == "M"{
                     self.navigationProfileImg.image = UIImage(named: "employeemale")
                 }else if swiftyJsonvar1["employee"]["gender"].stringValue == "F"{
                     self.navigationProfileImg.image = UIImage(named: "woman")
                 }
            }
            if url != "" {
            let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let finalurl = URL(string: encodedURL)
            

                // Fetch Image Data
                if let data = try? Data(contentsOf: finalurl!) {
                    // Create Image and Update Image View
                    self.navigationProfileImg.image = UIImage(data: data)
                    self.navigationProfileImg.layer.cornerRadius = self.navigationProfileImg.bounds.width/2
//                    self.navigationProfileImg.clipsToBounds = true
                    self.navigationProfileImg.layer.masksToBounds = true
                }
            }
        
           
            self.navigationDesignation.text = swiftyJsonvar1["employee"]["designation_name"].stringValue
            self.navigationEmployeeName.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
            self.navigationCompanyName.text = swiftyJsonvar1["company"]["company_name"].stringValue
            self.navigationDrawerLeadingConstraint.constant = 0
            self.navigationDrawerTrailingConstant.constant = 60
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        }
        menuIsMenuShow = !menuIsMenuShow
    }
    //-------menuClose function is for other sections(except menu bnutton), code starts------
    func menuClose(){
//        self.canelBlurEffect()
        navigationLogoCompany.isHidden = true
        navigationProfileImg.isHidden = true
        
        ScrollView.isScrollEnabled = true
        //            self.view.removeFromSuperview()
        navigationDrawerLeadingConstraint.constant = -(navigationDrawer.frame.size.width)
        navigationDrawerTrailingConstant.constant = ScrollView.frame.size.width
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    //-------menuClose function is for other sections(except menu bnutton), code ends------
    
    @IBAction func menuBth(_ sender: Any) {
        menuShow()
    }
    //-------/////--Navigation Drawer, code ends--//////-----
    
    //--------MenuBar and Navigation Drawer, code starts------
    func LoadNavigationBarData(){
        //LogoutMenuBar
        let tapGestureRecognizerImgLogoutMenuBar = UITapGestureRecognizer(target: self, action: #selector(ImgLogoutMenu(tapGestureRecognizer:)))
        ImgLogoutMenuBar.isUserInteractionEnabled = true
        ImgLogoutMenuBar.addGestureRecognizer(tapGestureRecognizerImgLogoutMenuBar)
    }
    //---MenuBarLogout
    @objc func ImgLogoutMenu(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "notification", sender: nil)
        openLogoutFormPopup()
    }
    
    //==============////--FormDialog Logout code starts--/////================
    @IBOutlet var viewFormLogoutPopup: UIView!
    
    func openLogoutFormPopup(){
        blurEffect()
        self.view.addSubview(viewFormLogoutPopup)
        ScrollView.isScrollEnabled = false
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewFormLogoutPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewFormLogoutPopup.center = self.view.center
        viewFormLogoutPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewFormLogoutPopup.alpha = 0
        viewFormLogoutPopup.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.viewFormLogoutPopup.alpha = 1
            self.viewFormLogoutPopup.transform = CGAffineTransform.identity
        }
    }
    func cancelLogoutFormPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewFormLogoutPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewFormLogoutPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewFormLogoutPopup.removeFromSuperview();
            self.canelBlurEffect()
            self.ScrollView.isScrollEnabled = true
        }
    }
    
    @IBAction func btnLogoutPopupYes(_ sender: Any) {
        cancelLogoutFormPopup()
        sharedpreferences.removeObject(forKey: "UserId")
        sharedpreferences.synchronize()
       
//        self.resetAllRecords(in: "UserNotification")
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil) //---this code is to dismiss the stack history

        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func btnLogoutPopupNo(_ sender: Any) {
        cancelLogoutFormPopup()
    }
    //==============////--FormDialog Logout code ends--/////================
    //--------MenuBar and Navigation Drawer, code ends------
    
    func LoadEmployeeDetails(){
        self.ViewChild.clipsToBounds = true
        self.ViewChild.layer.cornerRadius = 10
        self.ViewChild.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //---added obn 11-March-2024, code starts
        self.ViewEmpDetails.layer.shadowColor = UIColor.gray.cgColor
        self.ViewEmpDetails.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.ViewEmpDetails.layer.shadowOpacity = 3
        self.ViewEmpDetails.layer.shadowRadius = 3.0
        //---added obn 11-March-2024, code ends
        
        
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        self.LabelEmpName.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        self.LabelDesignation.text = swiftyJsonvar1["employee"]["designation_name"].stringValue
        self.LabelDepartment.text = swiftyJsonvar1["company"]["company_name"].stringValue
        self.LabelSupervisor1.text = swiftyJsonvar1["employee"]["supervisor_1_name"].stringValue
        self.LabelSupervisor2.text = swiftyJsonvar1["employee"]["supervisor_2_name"].stringValue
        self.LabelCorpId.text = swiftyJsonvar1["employee"]["employee_code"].stringValue
        self.LabelCorpId.layer.cornerRadius = 3
        self.LabelCorpId.layer.masksToBounds = true
    }
    
    //=============Code for Pending Items section, starts========
    func LoadPendingItemDetails(){
        self.ViewChildPendingItems.clipsToBounds = true
        self.ViewChildPendingItems.layer.cornerRadius = 10
        self.ViewChildPendingItems.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        //---added obn 12-March-2024, code starts
        self.TableViewPendingItems.clipsToBounds = true
        self.TableViewPendingItems.layer.cornerRadius = 10
        self.TableViewPendingItems.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.ViewPendingItems.layer.shadowColor = UIColor.gray.cgColor
        self.ViewPendingItems.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.ViewPendingItems.layer.shadowOpacity = 3
        self.ViewPendingItems.layer.shadowRadius = 3.0
        //---added obn 12-March-2024, code ends
        
        self.TableViewPendingItems.delegate = self
        self.TableViewPendingItems.dataSource = self
        self.TableViewPendingItems.backgroundColor = UIColor.white
        
        LoadPendingData()
    }
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func LoadPendingData(){
//        let url = "\(BASE_URL)timesheet/log/monthly/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(month_number)/\(year)"
        let url = "\(BASE_URL)pending_actions/fetch/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)"
        print("PendingItemsDetails-=>",url)
        
        //        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
        AF.request(url).responseJSON{ (responseData) -> Void in
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                
                if let resData = swiftyJsonVar["pending_actions"].arrayObject{
                    self.arrResPendingItems = resData as! [[String:AnyObject]]
                }
                print("Count--=>", self.arrResPendingItems.count)
                if self.arrResPendingItems.count>0 {
                    self.TableViewPendingItems.reloadData()
                }else{
                    self.TableViewPendingItems.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewPendingItems.bounds.size.width, height: self.TableViewPendingItems.bounds.size.height))
                    noDataLabel.text          = "No Pending Actions"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.TableViewPendingItems.backgroundView  = noDataLabel
                    self.TableViewPendingItems.separatorStyle  = .none
                    
                }
            }else{
                self.TableViewPendingItems.reloadData()
                //                    Toast(text: "No data", duration: Delay.short).show()
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewPendingItems.bounds.size.width, height: self.TableViewPendingItems.bounds.size.height))
                noDataLabel.text          = "No Pending Actions"
                noDataLabel.font = UIFont.systemFont(ofSize: 14)
                noDataLabel.textColor     = UIColor(hexFromString: "767575")
                noDataLabel.textAlignment = .center
                self.TableViewPendingItems.backgroundView  = noDataLabel
                self.TableViewPendingItems.separatorStyle  = .none
            }
            
        }
    }
    //--------function to show log details using Alamofire and Json Swifty code ends------------
    //=============Code for Pending Items section, ends========
    
    
    //===================Code for Attendance section, starts============
    
    func LoadAttendanceData(){
//        self.ViewChildAttendance.roundCorners([.topLeft, .topRight], radius: 10)
        self.ViewChildAttendance.clipsToBounds = true
        self.ViewChildAttendance.layer.cornerRadius = 10
        self.ViewChildAttendance.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        //---added obn 12-March-2024, code starts
        self.ViewAttendance.layer.shadowColor = UIColor.gray.cgColor
        self.ViewAttendance.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.ViewAttendance.layer.shadowOpacity = 3
        self.ViewAttendance.layer.shadowRadius = 3.0
        //---added obn 12-March-2024, code ends
        
//        LabelInTitle.addBorder(side: .right, color: UIColor(hexFromString: "A2A2A2"), width: 1) //---commented on 7th march 2024
        ViewInTime.addBorder(side: .right, color: UIColor(hexFromString: "DADADA"), width: 1)
        
       
        ViewWfh.clipsToBounds = true
        ViewWfh.layer.masksToBounds = true
//        ViewWfh.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        ViewWfh.roundCornersNew2024(corners: [.topLeft, .bottomLeft], radius: 10, borderWidth: 1.5, borderColor: UIColor.gray)
       
        TxtViewWFH.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        
        
//        LabelInTitle.clipsToBounds = true
       /* LabelInTitle.roundCorners(corners: [.topLeft], radius: 10)
        LabelInTitle.addBorder(side: .right, color: UIColor(hexFromString: "000000"), width: 1)
        LabelOutTitle.roundCorners(corners: [.topRight], radius: 10)
        
        
        ViewInTime.clipsToBounds = true
        ViewInTime.roundCorners(corners: [.bottomLeft], radius: 10)
        ViewInTime.addBorder(side: .right, color: UIColor(hexFromString: "c2c2c2"), width: 1)
        ViewInTime.addBorder(side: .left, color: UIColor(hexFromString: "c2c2c2"), width: 1)
        ViewInTime.addBorder(side: .bottom, color: UIColor(hexFromString: "c2c2c2"), width: 1)*/
        /*ViewInTime.clipsToBounds = true
        ViewInTime.layer.cornerRadius = 10
        ViewInTime.layer.maskedCorners = [.layerMinXMaxYCorner]*/
        
       /*ViewOutTime.roundCorners(corners: [.bottomRight], radius: 10)
        ViewOutTime.addBorder(side: .right, color: UIColor(hexFromString: "c2c2c2"), width: 1)
        ViewOutTime.addBorder(side: .bottom, color: UIColor(hexFromString: "c2c2c2"), width: 1)*/
        
        
        TxtViewWFH.backgroundColor = UIColor(hexFromString: "ffffff")
        btnCheckBox.setImage(UIImage(named:"check_box_empty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"check_box"), for: .selected)
        
//        TxtViewWFHHeightConstraint.constant = 0
        TxtViewWFH.isUserInteractionEnabled = false
//        self.TxtViewWFH.layer.borderColor = UIColor.lightGray.cgColor
//        self.TxtViewWFH.layer.borderWidth = 1
        
        //-----code to get current date and show date in the label, starts-----
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        label_date_today.text = formatter.string(from: date)
        label_date_today.layer.cornerRadius = 3
        label_date_today.layer.masksToBounds = true
        //-----code to get current date and show date in the label, starts-----
        
        //---camera
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.allowsEditing = false
        
        
        //MyAttendanceLog OnClick
        
        ViewBtnInOut.clipsToBounds = true
        ViewBtnInOut.layer.masksToBounds = true
//        ViewWfh.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        ViewBtnInOut.roundCornersNew2024(corners: [.topRight, .bottomRight], radius: 10, borderWidth: 1.5, borderColor: UIColor.gray)
        
        let tapGestureRecognizerInOutbtn = UITapGestureRecognizer(target: self, action: #selector(ViewBtn(tapGestureRecognizer:)))
        
        ViewBtnInOut.isUserInteractionEnabled = true
        ViewBtnInOut.addGestureRecognizer(tapGestureRecognizerInOutbtn)
        
        load_data_check_od_duty()
    }
    
    
    //---added on 27-Feb-2024, code starts for qr attendance
    // AVCaptureMetadataOutputObjectsDelegate method to handle captured metadata
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if metadataObjects array is not empty and if the first object is a QR code metadata
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               metadataObject.type == .qr,
               let stringValue = metadataObject.stringValue {
                // Handle the QR code data, for example, print it out
                print("QR Code Value: \(stringValue)")
                
                // You can do further processing with the QR code data here
                
                // After getting the QR code data, you might want to stop the capture session
                previewLayer.removeFromSuperlayer()
                captureSession.stopRunning()
                crossButton.removeFromSuperview() //---added on 13-Mar-2024
                
                
                let jsonString = """
                \(stringValue)
                """
                
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let locationData = try JSONDecoder().decode(LocationData.self, from: jsonData)
                        
                        // Convert string representations of dates into Date objects
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        guard let validFromDate = dateFormatter.date(from: locationData.validFrom),
                              let validUptoDate = dateFormatter.date(from: locationData.validUpto) else {
                            fatalError("Failed to convert date strings to Date objects")
                        }
                        
                        // Get the current date and time
                        let currentDate = Date()
                        
                        // Check if the current date and time fall within the valid range
//                        currentDate >= validFromDate &&  //---commented on 5th March 2024 due to time mismatch
                        if currentDate <= validUptoDate {
                            print("Current date and time are within the valid range.")
                            
                            // Get current location
                            let currentLocation = CLLocation(latitude: TimesheetMyAttendanceViewController.currentlatitude, longitude: TimesheetMyAttendanceViewController.currentLongitude)
                            
                            // Check if current location is within 50 meters of the provided latitude and longitude
                            let targetLocation = CLLocation(latitude: locationData.latitude, longitude: locationData.longitude)
                            let distance = currentLocation.distance(from: targetLocation)
                            
                            if distance <= 50 {
                                print("Current location is within 50 meters of the provided latitude and longitude.")
                                if LabelInOut.text == "IN" {
                                    TimesheetMyAttendanceViewController.in_out = "IN"
                                    TimesheetMyAttendanceViewController.work_frm_home_flag = work_from_home_flag
                                    TimesheetMyAttendanceViewController.work_from_home_detail = self.TxtViewWFH.text!
                                    TimesheetMyAttendanceViewController.message_in_out = "Attendance IN time recorded"
                                    
                    
                                    self.save_in_out_data(in_out: "IN", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.TxtViewWFH.text!, message_in_out: "Attendance IN time recorded",imageBase64: "")
                                }else if LabelInOut.text == "OUT"{
                                    TimesheetMyAttendanceViewController.in_out = "OUT"
                                    TimesheetMyAttendanceViewController.work_frm_home_flag = work_from_home_flag
                                    TimesheetMyAttendanceViewController.work_from_home_detail = self.TxtViewWFH.text!
                                    TimesheetMyAttendanceViewController.message_in_out = "Attendance OUT time recorded"
                                    
                                    self.save_in_out_data(in_out: "OUT", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.TxtViewWFH.text!, message_in_out: "Attendance OUT time recorded",imageBase64: "")
                                    self.TxtViewWFH.isUserInteractionEnabled = false
      //                            self.btnCheckBox.isHidden = true
                                    self.btnCheckBox.isUserInteractionEnabled = false
                                    
                                }
                            } else {
//                                print("Current location is more than 50 meters away from the provided latitude and longitude.")
                                var style = ToastStyle()
                                
                                // this is just one of many style options
                                style.messageColor = .white
                                
                                self.view.makeToast("Sorry! You are not in range. Your location should be within 10m from office", duration: 3.0, position: .bottom, style: style)
                            }
                        } else {
//                            print("Current date and time are outside the valid range.")
                            var style = ToastStyle()
                            
                        
                            // this is just one of many style options
                            style.messageColor = .white
                            
                            self.view.makeToast("Sorry! Your current date and time are outside the valid range.", duration: 3.0, position: .bottom, style: style)
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                }
                
                
            }
        }
        
        // Optionally, you may override viewDidLayoutSubviews to update the previewLayer's frame
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            previewLayer?.frame = view.layer.bounds
        }
    //---added on 27-Feb-2024, code ends for qr attendance
    
    //---ViewBtnInOut OnClick
    @objc func ViewBtn(tapGestureRecognizer: UITapGestureRecognizer){
        
        //---added on 247-feb-2024, code starts
        // Initialize capture session
               captureSession = AVCaptureSession()
               
               // Get the default AVCaptureDevice for video
               guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
               
               do {
                   // Create an input for the capture session using the video device
                   let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                   
                   // Add the input to the capture session
                   captureSession.addInput(videoInput)
               } catch {
                   // If an error occurs, print it out and return
                   print(error)
                   return
               }
               
               // Initialize a AVCaptureMetadataOutput object and add it as an output
               let metadataOutput = AVCaptureMetadataOutput()
               captureSession.addOutput(metadataOutput)
               
               // Set the delegate to self and specify the dispatch queue for metadata output handling
               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               metadataOutput.metadataObjectTypes = [.qr]
               
               // Initialize a AVCaptureVideoPreviewLayer object and add it as a sublayer
               previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
               previewLayer.frame = view.layer.bounds
               previewLayer.videoGravity = .resizeAspectFill
               view.layer.addSublayer(previewLayer)
               
               // Start the capture session
               captureSession.startRunning()
        //---added on 247-feb-2024, code ends
        
        
        //---cross btn, added on 13-Mar-2024, code starts
        // Add cross button
                crossButton = UIButton(type: .custom)
                crossButton.setImage(UIImage(named: "cross"), for: .normal)
                crossButton.frame = CGRect(x: UIScreen.main.bounds.width-50, y: 10, width: 40, height: 40)
                crossButton.addTarget(self, action: #selector(cancelSession), for: .touchUpInside)
                view.addSubview(crossButton)
                
        //---cross btn, added on 13-Mar-2024, code ends
        
        determineMyCurrentLocation(status: "Start") //---function to get lat/long
       /* if LabelInOut.text == "IN" {
            TimesheetMyAttendanceViewController.in_out = "IN"
            TimesheetMyAttendanceViewController.work_frm_home_flag = work_from_home_flag
            TimesheetMyAttendanceViewController.work_from_home_detail = self.TxtViewWFH.text!
            TimesheetMyAttendanceViewController.message_in_out = "Attendance IN time recorded"
            
    //        self.save_in_out_data(in_out: "IN", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.tv_wrk_frm_home.text!, message_in_out: "Attendance IN time recorded",imageBase64: "") //--previously work from home flag was 1, but it gives some problem //--commented on 31st may temp
            if swiftyJsonvar1["company"]["attendance_with_selfie_yn"].intValue == 1 {
//            openSelfieConfirmationPopup() //---commenetd on 27-Feb-2024
            }else{
//                self.save_in_out_data(in_out: "IN", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.TxtViewWFH.text!, message_in_out: "Attendance IN time recorded",imageBase64: "")
                //---commented on 27-Feb-2024
            }
        }else if LabelInOut.text == "OUT"{
            if((work_from_home_flag == 1) && self.TxtViewWFH.text!.isEmpty){

                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                self.view.makeToast("Cannot save without work from home details", duration: 3.0, position: .bottom, style: style)

                          }else{
                            
                            TimesheetMyAttendanceViewController.in_out = "OUT"
                            TimesheetMyAttendanceViewController.work_frm_home_flag = work_from_home_flag
                            TimesheetMyAttendanceViewController.work_from_home_detail = self.TxtViewWFH.text!
                            TimesheetMyAttendanceViewController.message_in_out = "Attendance OUT time recorded"
    //                        self.save_in_out_data(in_out: "OUT", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.tv_wrk_frm_home.text!, message_in_out: "Attendance OUT time recorded")  //---commented on 31st may temp
                            if swiftyJsonvar1["company"]["attendance_with_selfie_yn"].intValue == 1 {
//                            openSelfieConfirmationPopup() //---commented on 27-Feb0-2024
                            }else{
//                                self.save_in_out_data(in_out: "OUT", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.TxtViewWFH.text!, message_in_out: "Attendance OUT time recorded",imageBase64: "")
                                //---commented on 27-Feb-2024
                            }
    //                        load_data_check_od_duty()
                            
//                            self.TxtViewWFHHeightConstraint.constant = 0
                              self.TxtViewWFH.isUserInteractionEnabled = false
//                            self.btnCheckBox.isHidden = true
                              self.btnCheckBox.isUserInteractionEnabled = false
                          }
        } */
    }
    
    //---added cross btn function on 13-Mar-2024, code starts
    @objc func cancelSession() {
            captureSession.stopRunning()
            previewLayer.removeFromSuperlayer()
            crossButton.removeFromSuperview()
        }
    //---added cross btn function on 13-Mar-2024, code ends
    @IBAction func checkMarkedTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                if(!sender.isSelected){
                    sender.isSelected = true
                    sender.transform = .identity
                    self.checkBtnYN = 1
//                    self.TxtViewWFHHeightConstraint.constant = 44
                    self.TxtViewWFH.isUserInteractionEnabled = true
                    print("checked", self.checkBtnYN)
                    self.work_from_home_flag = 1
                }else{
                    sender.isSelected = false
                    sender.transform = .identity
                    self.checkBtnYN = 0
//                    self.TxtViewWFHHeightConstraint.constant = 0
                    self.TxtViewWFH.isUserInteractionEnabled = false
                    print("Un checked")
                    self.work_from_home_flag = 0
                }
            }, completion: nil)
        }
        
    }
    
    //========function to save data for IN/OUT, code starts=======
    func save_in_out_data(in_out: String, work_frm_home_flag: Int, work_from_home_detail: String, message_in_out: String, imageBase64: String){
        if message_in_out == "IN"{
           /* self.btn_in.isEnabled = false
            self.btn_in.alpha = CGFloat(0.6) */
            //            self.btn_in.backgroundColor = UIColor(hexFromString: "#EEEEEE")
            
//            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "fb4e4e")
//            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "FB4E4E")
            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "254F95")
            self.LabelInOut.text = "OUT"
            
        }else if message_in_out == "OUT" {
            /*self.btn_out.isEnabled = false
            self.btn_out.alpha = CGFloat(0.6)*/
            
//            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "0276FD")
            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "EE0012")
            self.LabelInOut.text = "IN"
        }
        
        //--commented on 28th May
       /* let jsonObject: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "timesheet_id": self.timesheet_id!,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].stringValue,
            "in_out_action": message_in_out,
            "work_from_home_flag": work_frm_home_flag,
            "work_from_home_detail": tv_wrk_frm_home.text!
        ] */
        
        //---added on 12-Mar-2024, code starts
        if TxtViewWFH.text == "Type Work From Home Reason"{
            TxtViewWFH.text = ""
        }
        //---added on 12-Mar-2024, code ends
        
        //--added on 28th May, starts
        let jsonObject: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].stringValue,
            "work_from_home_flag": work_frm_home_flag,
            "work_from_home_detail": TxtViewWFH.text!,
            "latitude":String(format: "%.6f", TimesheetMyAttendanceViewController.currentlatitude),
            "longitude": String(format: "%.6f", TimesheetMyAttendanceViewController.currentLongitude),
            "address": TimesheetMyAttendanceViewController.currentAddress,
            "imageBase64": imageBase64
        ]
        //--added on 28th May, ends
        print("jsonlocation-=>",jsonObject)
        if let data=try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let str=String(data: data, encoding: .utf8){
            //                        print("Latest value-->",str)
            //                        employeeTimesheetReturnAPICall(stringCheck: "ReturnTimeSheet", jsonObjectData: str)
            
        }
//        let apiurl="\(BASE_URL)timesheet/save"
        let apiurl="\(BASE_URL)timesheet/save-with-geo-location"
        AF.request(apiurl, method: .post, parameters: jsonObject,encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in
            
            switch response.result{
            case .success:
                //                        let swiftyJsonVar=JSON(response.result)
                //                        print(swiftyJsonVar)
                if((response.value) != nil){
                    let swiftyJsonVar=JSON(response.value!)
                    print("Save description: \(swiftyJsonVar)")
                    if swiftyJsonVar["status"].stringValue == "true"{
                        self.determineMyCurrentLocation(status: "Stop")
                        self.load_data_check_od_duty()
                        
                        self.openAttendanceConfirmationPopup(AttendanceConfirmationMsg: message_in_out) //---added on 15-Mar-2024
                    }
                }
                
                break
                
            case .failure(let error):
                self.determineMyCurrentLocation(status: "Stop")
                print(error)
            }
            
        }
    }
    
    //========function to save data for IN/OUT, code ends=======
    
    //===========Code for getting time_in and time_out, starts==========
    func load_data_check_od_duty(){
        self.ImgViewAttendanceComplt.isHidden = true
//        self.loaderStart() //---commented on 14-Mar-2024
        let url = "\(BASE_URL)timesheet/log/today/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)"
        //        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
        AF.request(url).responseJSON{ (responseData) -> Void in
//            self.loaderEnd() //---commented on 14-Mar-2024
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                if swiftyJsonVar["response"]["status"].stringValue == "true"{
                    self.timesheet_id = swiftyJsonVar["timesheet_id"].intValue
                    self.work_from_home_flag = swiftyJsonVar["work_from_home_flag"].intValue
                    self.work_from_home_detail = swiftyJsonVar["work_from_home_detail"].stringValue
                    
                    let dateFormatterGet = DateFormatter()
            //        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss a"
                    dateFormatterGet.dateFormat = "YYYY-MM-DD HH:mm:ss.SSS" //--for test version
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "hh:mma"
//                    print("RawTime-=>", swiftyJsonVar["time_in"].stringValue)
                    
                    if let TimeIn = dateFormatterGet.date(from: swiftyJsonVar["time_in"].stringValue){
//                    print("Time-=>", dateFormatterPrint.string(from: date!))
                    
                        
                        let TimeInAbbrFormattedText = dateFormatterPrint.string(from: TimeIn)
                        var TimeInAbbrFormattedTextChars = Set([Character]("AMPM"))
//                        self.LabelInTime.text = dateFormatterPrint.string(from: TimeIn)
                        self.LabelInTime.text = "IN : \(String(dateFormatterPrint.string(from: TimeIn).dropLast(2)))"
                        self.LabelInTimeAbbrebiation.text = self.removeCharactersNotInSetFromText(text: TimeInAbbrFormattedText, set: TimeInAbbrFormattedTextChars).lowercased()
                        
                    }
                    if let TimeOut = dateFormatterGet.date(from: swiftyJsonVar["time_out"].stringValue){
//                        self.LabelOutTime.text = dateFormatterPrint.string(from: TimeOut)
                        
                        let TimeOutAbbrFormattedText = dateFormatterPrint.string(from: TimeOut)
                        var TimeOutAbbrFormattedTextChars = Set([Character]("AMPM"))
//                        self.LabelInTime.text = dateFormatterPrint.string(from: TimeIn)
                        self.LabelOutTime.text = "OUT : \(String(dateFormatterPrint.string(from: TimeOut).dropLast(2)))"
                        self.LabelOutTimeAbbrebiation.text = self.removeCharactersNotInSetFromText(text: TimeOutAbbrFormattedText, set: TimeOutAbbrFormattedTextChars).lowercased()
                    }
                    
                    print("timesheet_id-=>",self.timesheet_id!)
                    print("work_from_home_flag-=>",self.work_from_home_flag!)
                    if self.timesheet_id! != 0 {
                        if self.work_from_home_flag == 1 {
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            self.btnCheckBox.isUserInteractionEnabled = true
                            self.btnCheckBox.isSelected = true
                            self.btnCheckBox.isEnabled = false
                            
//                            self.TxtViewWFHHeightConstraint.constant = 44
                            self.TxtViewWFH.isUserInteractionEnabled = true
                            self.TxtViewWFH.text = self.work_from_home_detail
                            self.TxtViewWFH.isEditable = true
                            
                            
                        } else if self.work_from_home_flag == 0 {
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            
                            self.btnCheckBox.isUserInteractionEnabled = false
//                            self.TxtViewWFHHeightConstraint.constant = 0
                            self.TxtViewWFH.isUserInteractionEnabled = false
                            
                        }else{
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            self.btnCheckBox.isEnabled = true
                            self.btnCheckBox.isUserInteractionEnabled = true
                            
//                            self.TxtViewWFHHeightConstraint.constant = 44
                            self.TxtViewWFH.isUserInteractionEnabled = true
                            
                        }
                    }
                    if(swiftyJsonVar["timesheet_in_out_action"].exists()) {
                        if swiftyJsonVar["timesheet_in_out_action"].stringValue == "IN" {
                            self.btnCheckBox.isHidden = false
                            self.btnCheckBox.isUserInteractionEnabled = true
                            
                            self.TxtViewWFH.isUserInteractionEnabled = true //--added
                            
                          /*  self.btn_in.isHidden = false
                            self.btn_out.isHidden = true*/
                            self.ImgViewAttendanceComplt.isHidden = true
                            self.ViewBtnInOut.isHidden = false
                            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "0276FD")
                            self.LabelInOut.text = "IN"
                            
                            
                        } else if swiftyJsonVar["timesheet_in_out_action"].stringValue == "OUT" {
                            self.ImgViewAttendanceComplt.isHidden = true
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            
                            self.btnCheckBox.isUserInteractionEnabled = true
                            
                            self.TxtViewWFH.isUserInteractionEnabled = true //--added
                            
                            
                           /* self.btn_in.isHidden = true
                            self.btn_out.isHidden = false */
                            
                            self.ViewBtnInOut.isHidden = false
//                            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "FF0000")
                            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "FB4E4E")
                            self.LabelInOut.text = "OUT"
                            
                        } else {
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            
                            self.btnCheckBox.isUserInteractionEnabled = false
                            
                            self.TxtViewWFH.isUserInteractionEnabled = false //--added
                            
                           /* self.btn_in.isHidden = true
                            self.btn_out.isHidden = true*/
                            
//                            self.ImgViewAttendanceComplt.isHidden = true
//                            self.ViewBtnInOut.isHidden = true //---commented on 15-Mar-2024
//                            self.ViewBtnInOut.isUserInteractionEnabled = false
//                            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "8BC45B")
                            
                            //---added on 15-Mar-2024, code starts
                            self.ViewBtnInOut.isHidden = false
                            self.ViewBtnInOut.isUserInteractionEnabled = false
                            self.ViewBtnInOut.backgroundColor = UIColor.clear
                            self.ImgViewAttendanceComplt.isHidden = false
                            self.LabelInOut.isHidden = true
                            //---added on 15-Mar-2024, code ends
                            
                        }
                    }else {
                        self.btnCheckBox.isHidden = false
                        self.label_wrk_from_home.isHidden = false
                        
                        self.btnCheckBox.isUserInteractionEnabled = false
                        
                        self.TxtViewWFH.isUserInteractionEnabled = false //--added
                        
                       /* self.btn_in.isHidden = true
                        self.btn_out.isHidden = true */
                        
                        self.ViewBtnInOut.isHidden = false
                        self.ViewBtnInOut.isUserInteractionEnabled = false
                        self.ViewBtnInOut.backgroundColor = UIColor.clear
                        self.ImgViewAttendanceComplt.isHidden = false
                        self.LabelInOut.isHidden = true
                        
                    }
                    
                }
            }
            
        }
    }
    
    func removeCharactersNotInSetFromText(text: String, set: Set<Character>) -> String {
      return String(text.filter { set.contains( $0) })
    }
    //===========Code for getting time_in and time_out, ends==========
    //-------Location, code starts(added on 28th May)
    func determineMyCurrentLocation(status: String) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                if status == "Start"{
                locationManager.startUpdatingLocation()
                } else if status == "Stop"{
                    locationManager.stopUpdatingLocation()
                }
                //locationManager.startUpdatingHeading()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let userLocation:CLLocation = locations[0] as CLLocation
            
            // Call stopUpdatingLocation() to stop listening for location updates,
            // other wise this function will be called every time when user location changes.
            
           // manager.stopUpdatingLocation()
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            TimesheetMyAttendanceViewController.currentlatitude = userLocation.coordinate.latitude
            TimesheetMyAttendanceViewController.currentLongitude = userLocation.coordinate.longitude
            getAddressFromLatLon(pdblLatitude: userLocation.coordinate.latitude, withLongitude: userLocation.coordinate.longitude)
//            print("user Address = \(userLocation.)")
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error \(error)")
        }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = (placemarks ?? []) as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                       /* print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare) */
                        var addressString : String = ""
                        if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                        }
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print("Address-=>",addressString)
                        TimesheetMyAttendanceViewController.currentAddress = addressString
                  }
            })

        }
    //-------Location code ends(added on 28th May)
    //==========Attendance Confirmation Popup, code starts(added on 15-Mar-2024)
    
    @IBOutlet weak var LabelAttendanceConfirmationMsg: UILabel!
    @IBOutlet weak var btnAttendanceConfirmationOk: UIButton!
    @IBAction func btnAttendanceConfirmationOk(_ sender: Any) {
        closeAttendanceConfirmationPopup()
    }
    
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet var viewAttendanceConfirmationPopup: UIView!
    func openAttendanceConfirmationPopup(AttendanceConfirmationMsg : String){
        blurEffect()
        self.view.addSubview(viewAttendanceConfirmationPopup)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewAttendanceConfirmationPopup.layer.masksToBounds = true
        viewAttendanceConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewAttendanceConfirmationPopup.center = self.view.center
        viewAttendanceConfirmationPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewAttendanceConfirmationPopup.alpha = 0
        viewAttendanceConfirmationPopup.sizeToFit()
        
        btnAttendanceConfirmationOk.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
//        view_custom_btn_punchout.addBorder(side: .top, color: UIColor(hexFromString: "4f4f4f"), width: 1)
//        btnPopupCancel.titleLabel?.textColor = .black
//        btnPopupYes.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
//        btnPopupNo.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        
        // Load animation
        // 1. Set animation content mode
        
          
        animationView.contentMode = .scaleAspectFit
          
          // 2. Set animation loop mode
          
        animationView.loopMode = .loop
          
          // 3. Adjust animation speed
          
        animationView.animationSpeed = 0.8
          
          // 4. Play animation
        animationView.play()
        
        LabelAttendanceConfirmationMsg.text = AttendanceConfirmationMsg
        
        UIView.animate(withDuration: 0.3){
            self.viewAttendanceConfirmationPopup.alpha = 1
            self.viewAttendanceConfirmationPopup.transform = CGAffineTransform.identity
        }
        
        
        //        self.confidencelabel.text = confidence!
        
        
    }
    func closeAttendanceConfirmationPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewAttendanceConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewAttendanceConfirmationPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewAttendanceConfirmationPopup.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //==========Attendance Confirmation Popup, code ends(added on 15-Mar-2024)
    //===============Selfie Confirmation Popup code starts===================
    @IBOutlet weak var btnPopupCancel: UIButton!
    @IBOutlet weak var btnPopupYes: UIButton!
    @IBOutlet weak var btnPopupNo: UIButton!
    @IBAction func btnPopupYes(_ sender: Any) {
        closeSelfieConfirmationPopup()
//        self.performSegue(withIdentifier: "dashboard", sender: nil)
//        self.DeleteImage(stringCheck: "DeleteFacesResult")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnPopupCancel(_ sender: Any) {
        closeSelfieConfirmationPopup()
    }
    @IBAction func btnPopupNo(_ sender: Any) {
        closeSelfieConfirmationPopup()
        self.save_in_out_data(in_out: TimesheetMyAttendanceViewController.in_out, work_frm_home_flag: TimesheetMyAttendanceViewController.work_frm_home_flag, work_from_home_detail: TimesheetMyAttendanceViewController.work_from_home_detail, message_in_out: TimesheetMyAttendanceViewController.message_in_out, imageBase64: "")
    }
    
    @IBOutlet weak var stackViewEnrollPopupButton: UIStackView!
    @IBOutlet var viewSelfie: UIView!
    func openSelfieConfirmationPopup(){
        blurEffect()
        self.view.addSubview(viewSelfie)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewSelfie.layer.masksToBounds = true
        viewSelfie.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewSelfie.center = self.view.center
        viewSelfie.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewSelfie.alpha = 0
        viewSelfie.sizeToFit()
        
        stackViewEnrollPopupButton.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
//        view_custom_btn_punchout.addBorder(side: .top, color: UIColor(hexFromString: "4f4f4f"), width: 1)
        btnPopupCancel.titleLabel?.textColor = .black
        btnPopupYes.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        btnPopupNo.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        
        UIView.animate(withDuration: 0.3){
            self.viewSelfie.alpha = 1
            self.viewSelfie.transform = CGAffineTransform.identity
        }
        
        
        //        self.confidencelabel.text = confidence!
        
        
    }
    func closeSelfieConfirmationPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewSelfie.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewSelfie.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewSelfie.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //===============Selfie Confirmation Popup code ends===================
    
    //------camera code, starts(added on 31st may)------
    public static var image_to_base64:String?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePicker.dismiss(animated: true, completion: nil)
            //                   loaderStart()
            
            //            var imageData = UIImagePNGRepresentation(pickedImage)
            var imageData = pickedImage.jpegData(compressionQuality: 0.2)
            base64String = imageData?.base64EncodedString()
            print("base64-=>",base64String!)
            
            self.save_in_out_data(in_out: TimesheetMyAttendanceViewController.in_out, work_frm_home_flag: TimesheetMyAttendanceViewController.work_frm_home_flag, work_from_home_detail: TimesheetMyAttendanceViewController.work_from_home_detail, message_in_out: TimesheetMyAttendanceViewController.message_in_out, imageBase64: base64String!)
//            loaderStart() //--commented on 4t jan 21
//            EnrollImage(stringCheck: "IndexFacesResult", base64ImageString: base64String!)
        }
        
    }
    //------camera code, ends(added on 31st may)------
    //===================Code for Attendance section, ends============
    
    
    
    
    
    //============Calender code starts===========
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "MM-dd-yyyy"
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    //--------function to show holiday details using Alamofire and Json Swifty------------
       func LoadCalendarDataFromApi(){
//           loaderStart()
        let url = "\(BASE_URL)holidays/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1"
//        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
//               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Holiday description: \(swiftyJsonVar)")
                   if let resData = swiftyJsonVar["holidays"].arrayObject{
                       self.arrResCaledar = resData as! [[String:AnyObject]]
                   }
                if self.arrResCaledar.count>0{
                    self.calendar.delegate = self
                    self.calendar.dataSource = self
                    self.calendar.reloadData()
                }
               }
               
           }
       }
       //--------function to show holiday details using Alamofire and Json Swifty code ends------------
    
    func LoadCalendarDetails(){
        
        //---added obn 12-March-2024, code starts
        self.ViewCalendar.layer.shadowColor = UIColor.gray.cgColor
        self.ViewCalendar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.ViewCalendar.layer.shadowOpacity = 3
        self.ViewCalendar.layer.shadowRadius = 3.0
        //---added obn 12-March-2024, code ends
        
        LoadCalendarDataFromApi()
        LabelCalendarDate.text = ""
        LabelCalendarDay.text = ""
        
        calendar.allowsMultipleSelection = true
        calendar.select(Date())
        calendar.appearance.todaySelectionColor = UIColor(hexFromString: "ff9933")
        LabelCalendarDate.text = getCustomDateFormat(date: Date())
        LabelCalendarDay.text = Date().dayNameOfWeek()
        calendar.headerHeight = 45.0
        calendar.weekdayHeight = 35.0
        calendar.rowHeight = 25.0
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 0.0, weight: .regular)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 18.0)
//        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 17)
        calendar.scrollDirection = .horizontal
//        calendar.appearance.todayColor = .red
        //        calender.calendarHeaderView.backgroundColor = UIColorRGB(r: 75, g: 153.0, b: 224.0)
        calendar.calendarHeaderView.backgroundColor = UIColor(hexFromString: "BFBFBF")
        calendar.calendarWeekdayView.backgroundColor = UIColor(hexFromString: "f2f2f2")
        calendar.appearance.titleWeekendColor = UIColor(hexFromString: "FB4E4E")
//        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleColor = UIColor(hexFromString: "787878")
        calendar.appearance.weekdayTextColor = UIColor(hexFromString: "0260D2")
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.borderRadius = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 10
        calendar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        
        calendar.addBorderFSCCalendar(side: .bottom, color: UIColor(hexFromString: "BFBFBF"), width: 1)

        
        //---added on 12-March-2024, code starts
       
        //---added on 12-March-2024, code ends
//        calender.appearance.separators = .interRows
        
        
        
        //ApplyForLeave OnClick
        let tapGestureRecognizerApplyForLeavebtn = UITapGestureRecognizer(target: self, action: #selector(ViewApplyForLeaveBtn(tapGestureRecognizer:)))
        ViewCustomBtnApplyForLeave.isUserInteractionEnabled = true
        ViewCustomBtnApplyForLeave.addGestureRecognizer(tapGestureRecognizerApplyForLeavebtn)
        
        //ApplyForODDuty OnClick
        let tapGestureRecognizerApplyForODbtn = UITapGestureRecognizer(target: self, action: #selector(ViewApplyForODBtn(tapGestureRecognizer:)))
        ViewCustomBtnApplyForOD.isUserInteractionEnabled = true
        ViewCustomBtnApplyForOD.addGestureRecognizer(tapGestureRecognizerApplyForODbtn)
    }
    
    //---ViewBtnApplyForLeave OnClick
    @objc func ViewApplyForLeaveBtn(tapGestureRecognizer: UITapGestureRecognizer){
        DashboardViewController.DashboardToMyLeaveApplicationRequestNewCreateYN = true
        self.performSegue(withIdentifier: "LeaveRqst", sender: nil)
    }
    
    //---ViewBtnApplyForOD OnClick
    @objc func ViewApplyForODBtn(tapGestureRecognizer: UITapGestureRecognizer){
        DashboardViewController.DashboardToMyODApplicationRequestNewCreateYN = true
        self.performSegue(withIdentifier: "odrqst", sender: nil)
    }
    
    
    //---added on 12-Mar-2024, code starts
    
       
    //---added on 12-Mar-2024, code ends
    
    
    //===========Calender code ends============
    
    
    //===============///////////PaySlip, code starts-////////==================
    func LoadSalaryData(){
        self.ViewChildPaySlip.clipsToBounds = true
        self.ViewChildPaySlip.layer.cornerRadius = 10
        self.ViewChildPaySlip.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //---added obn 12-March-2024, code starts
        
        self.ViewPaySlip.layer.shadowColor = UIColor.gray.cgColor
        self.ViewPaySlip.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.ViewPaySlip.layer.shadowOpacity = 3
        self.ViewPaySlip.layer.shadowRadius = 3.0
        //---added obn 12-March-2024, code ends
        
        
        self.BtnMonth.addBorder(side: .right, color: UIColor(hexFromString: "B08F1C"), width: 1.0)
       get_month_details()
       get_Year_details()
    }
    //--------function to get year using Alamofire and Json Swifty------------
    var year = [String]()
        func get_Year_details(){
//            loaderStart()
            if year.count > 0{
                year.removeAll()
            }
            if !year_details.isEmpty{
                year_details.removeAll(keepingCapacity: true)
            }
            let url = "\(BASE_URL)finyear/list/reports/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1"
            print("urlYear-=>",url)
            AF.request(url).responseJSON{ (responseData) -> Void in
//                self.loaderEnd()
                if((responseData.value) != nil){
                    let swiftyJsonVar=JSON(responseData.value!)
//                    print("Calendar description: \(swiftyJsonVar)")
                    
                    for i in 0..<swiftyJsonVar["fin_years"].count{
//                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
//                        print("Calendar-=>",self.year)
                        self.year.append(swiftyJsonVar["fin_years"][i]["financial_year_code"].stringValue)
                        
                    }

                    for(key,value) in swiftyJsonVar["fin_years"]{
                        var k = YearDetails()
                        k.calender_year = value["financial_year_code"].stringValue
                        k.financial_year_code = value["financial_year_id"].stringValue
                        self.year_details.append(k)
                    }
                    
                }
                
            }
        }
        //--------function to get year using Alamofire and Json Swifty code ends------------
    var month = [String]()
    func get_month_details(){
        if self.month.isEmpty == false {
            self.month.removeAll()
        }
        self.month.append("--Select Month--")
        self.month.append("January")
        self.month.append("February")
        self.month.append("March")
        self.month.append("April")
        self.month.append("May")
        self.month.append("June")
        self.month.append("July")
        self.month.append("August")
        self.month.append("September")
        self.month.append("October")
        self.month.append("November")
        self.month.append("December")
    }
    
    let dropDownSelectSalarySlipYear = DropDown()
    @IBAction func btn_select_salary_slip_year(_ sender: UIButton) {
        dropDownSelectSalarySlipYear.dataSource = year
        dropDownSelectSalarySlipYear.anchorView = sender //5
        dropDownSelectSalarySlipYear.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDownSelectSalarySlipYear.show() //7
        dropDownSelectSalarySlipYear.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("year-=>",item)
            DashboardViewController.year = self!.year_details[index].financial_year_code
//                self!.loadPopupLeaveData(year: self!.year_details[index].financial_year_code)
            if index > 0{
//                self?.custom_btn_ok_salary_slip_popup.isUserInteractionEnabled = true
//                self?.custom_btn_ok_salary_slip_popup.alpha = 1.0
            }else if index == 0 {
//                self?.custom_btn_ok_salary_slip_popup.isUserInteractionEnabled = false
//                self?.custom_btn_ok_salary_slip_popup.alpha = 0.6
            }
            }
    }
    
    let dropDownSalarySlipMonth = DropDown()
    @IBAction func btn_select_salary_slip_month(_ sender: UIButton) {
        dropDownSalarySlipMonth.dataSource = month
        dropDownSalarySlipMonth.anchorView = sender //5
        dropDownSalarySlipMonth.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDownSalarySlipMonth.show() //7
        dropDownSalarySlipMonth.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("month-=>",item)
            DashboardViewController.month_name = item
           /* ReportsViewController.year = self!.year_details[index].financial_year_code
            if index > 0{
                self?.custom_btn_ok_salary_slip_popup.isUserInteractionEnabled = true
                self?.custom_btn_ok_salary_slip_popup.alpha = 1.0
            }else if index == 0 {
                self?.custom_btn_ok_salary_slip_popup.isUserInteractionEnabled = false
                self?.custom_btn_ok_salary_slip_popup.alpha = 0.6
            }*/
            }
    }
    
    @IBAction func BtnViewSalarySlip(_ sender: Any) {
        if let year = DashboardViewController.year, let month_name = DashboardViewController.month_name {
        loadHtmlStringSalarySlipData(year: year, month_name: month_name)
        }else {
//            print("Please Select month or year")
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .white
            self.view.makeToast("Please Select Month/Year", duration: 3.0, position: .bottom, style: style)
        }

    }
    
    //--------function to load popup salary slip data using Alamofire and Json Swifty code starts(added on 13th Dec 2021)----------
    func loadHtmlStringSalarySlipData(year:String?, month_name: String?){
//        loaderStart()
//        let url = "\(BASE_URL)reports/pf-deduction/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(year!)" //--commented on 18-Aug-2021
      
        let url = "\(BASE_URL)reports/pay-slip/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(month_name!)/\(year!)/\(swiftyJsonvar1["employee"]["branch_office_id"].intValue)/ALL"  //--added on 18-Aug-2021(added two parameters)
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
//                self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                    print("Year description: \(swiftyJsonVar)")
                if(swiftyJsonVar["response"]["status"].stringValue == "true"){
                    DashboardViewController.report_html = swiftyJsonVar["report_html"].stringValue
                    self.performSegue(withIdentifier: "salarypdf", sender: nil)
               
                }else{
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageColor = .white
                    self.view.makeToast(swiftyJsonVar["response"]["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                   
//                    self.loaderEnd()
                }
                    
                }

                
            }
       
            
        }
    //--------function to load popup salary slip data using Alamofire and Json Swifty code ends(added on 13th Dec 2021)----------
    //===============///////////PaySlip, code ends-////////==================
    
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
//        ScrollView.addSubview(blurEffectView)
        // screen roted and size resize automatic
        blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        
    }
    func canelBlurEffect() {
        self.blurEffectView.removeFromSuperview();
    }
    // ====================== Blur Effect END ================= \\
};

extension DashboardViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //----code for holiday, starts-----
        let dateString = self.formatter.string(from: date)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let SelectedDate = dateFormatterGet.date(from: dateString)
        
        LabelCalendarDate.text = dateFormatterPrint.string(from: SelectedDate!)
        
        for i in  0..<arrResCaledar.count{
            let dict = arrResCaledar[i]
//                   LabelCalendarHoliday.text = dict["holiday_name"] as? String
//                   print("HolidayName-=>", dict["holiday_name"] as! String)
            if dict["from_date"] as? String == dateString{
//                label_date.isHidden = false
//                label_holiday_name.isHidden = false
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd/MM/yyyy"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                
                let date = dateFormatterGet.date(from: dict["from_date"] as! String)
//                labelDate.text = eventData[i].date
                LabelCalendarDate.text = dateFormatterPrint.string(from: date!)
                LabelCalendarHoliday.text = dict["holiday_name"] as? String
                print("HolidayName-=>", dict["holiday_name"] as! String)
            }
        }
        //----code for holiday, ends-----
        
        
        //----code for date range select, starts-----
        // nothing selected:
        LabelCalendarDate.text = getCustomDateFormat(date: date)
        LabelCalendarDay.text = date.dayNameOfWeek()
           if firstDate == nil {
               firstDate = date
               datesRange = [firstDate!]

               print("first date: \(getCustomDateFormat(date: firstDate!))")
               print("datesRange contains: \(datesRange!)")
               DashboardViewController.FirstDate = getCustomDateFormat(date: firstDate!)

               return
           }

           // only first date is selected:
           if firstDate != nil && lastDate == nil {
               // handle the case of if the last date is less than the first date:
               if date <= firstDate! {
                   calendar.deselect(firstDate!)
                   firstDate = date
                   datesRange = [firstDate!]

                   print("datesRange contains: \(datesRange!)")

                   return
               }

               let range = datesRange(from: firstDate!, to: date)

               lastDate = range.last

               for d in range {
                   calendar.select(d)
               }

               datesRange = range

               print("last date: \(getCustomDateFormat(date: lastDate!))")
               print("datesRange contains: \(datesRange!)")
               
               DashboardViewController.LastDate = getCustomDateFormat(date: lastDate!)

               LabelCalendarDate.text = "\(DashboardViewController.FirstDate!) to \(DashboardViewController.LastDate!)"
               LabelCalendarDay.text = ""
               LabelCalendarHoliday.text = ""
               return
           }

           // both are selected:
           if firstDate != nil && lastDate != nil {
               for d in calendar.selectedDates {
                   calendar.deselect(d)
               }

               lastDate = nil
               firstDate = nil

               datesRange = []
               
               DashboardViewController.FirstDate = ""
               DashboardViewController.LastDate = ""

               print("datesRange contains: \(datesRange!)")
           }/*else{
               LabelCalendarDate.text = getCustomDateFormat(date: date)
           }*/
        
        //----code for date range select, ends-----
        
       
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        LabelCalendarDate.text = ""
        LabelCalendarDay.text = ""
        LabelCalendarHoliday.text = ""
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            DashboardViewController.FirstDate = ""
            DashboardViewController.LastDate = ""
            print("datesRange contains: \(datesRange!)")
        }
    }
    func getCustomDateFormat(date: Date) -> String{
        let dateString = self.formatter.string(from: date)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        let SelectedDate = dateFormatterGet.date(from: dateString)
        return dateFormatterPrint.string(from: SelectedDate!)
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        label_date.isHidden = true
//        label_holiday_name.isHidden = true
    }
    
    /// Maximum Date
    ///
    /// - Parameter calendar: Calendar Properties
    /// - Returns: Date
    func maximumDate(for calendar: FSCalendar) -> Date {
//        return self.formatter.date(from: "12-31-2021")!
        return Calendar.current.date(byAdding: .year, value: 10, to: Date())!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
//        return self.formatter.date(from: "01-01-2018")!
        return Calendar.current.date(byAdding: .year, value: -2, to: Date())!
    }
    
    
    
    /// Fill Color of Selected Dates
    ///
    /// - Parameters:
    ///   - calendar: Calendar Properties
    ///   - appearance: Fill Color of Each Date
    ///   - date: Date
    /// - Returns: Color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = self.formatter.string(from: date)
        var returnColor:UIColor = .clear
        for i in  0..<arrResCaledar.count{
            let dict = arrResCaledar[i]
            
            if dict["from_date"] as? String == dateString{
                returnColor = UIColor(hexFromString: "#E4FCAD")
                print("matched date",dict["from_date"] as! String)
                break
            }else{
                print("not matched date")
                returnColor = .clear
            }
            
        }
        return returnColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let dateString = self.formatter.string(from: date)
        var returnColor:UIColor = .clear
        for i in  0..<arrResCaledar.count{
            let dict = arrResCaledar[i]
            
            if dict["from_date"] as? String == dateString{
                returnColor = UIColor(hexFromString: "#E4FCAD")
                print("matched date",dict["from_date"] as! String)
                break
            }else{
                returnColor = .clear
                print("not matched")
            }
            
        }
        return returnColor
        
        
    }
    
};

extension FSCalendar {

    public enum BorderSide {
        case top, bottom, left, right
    }

    public func addBorderFSCCalendar(side: BorderSide, color: UIColor, width: CGFloat) {
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
extension Date {
    func dayNameOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
};
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    func roundCornersNew2024(corners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        // Create a shape layer for the border
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}

// MARK: - UITextViewDelegate
extension DashboardViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if !TxtViewWFH.text!.isEmpty && TxtViewWFH.text! == "Type Work From Home Reason" {
            TxtViewWFH.text = ""
            TxtViewWFH.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
    
        if TxtViewWFH.text.isEmpty {
            TxtViewWFH.text = "Type Work From Home Reason"
            TxtViewWFH.textColor = UIColor.lightGray
        }
    }
}
/*extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}*/


extension UIView{
    
    func applyGradient(view: UIView, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
            // Create gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            
            // Add gradient layer to the view's layer
//           layer.insertSublayer(gradientLayer, at: 0)
           view.layer.insertSublayer(gradientLayer, at: 0)
        }
    
    
    func setCornerRadius(cornerRadius: CGFloat, topLeft: Bool, bottomLeft: Bool, topRight: Bool, bottomRight: Bool, leftBorder: Bool, rightBorder: Bool, topBorder: Bool, bottomBorder: Bool, borderColor: UIColor? = nil) {
           var maskedCorners: CACornerMask = []
           if topLeft {
               maskedCorners.insert(.layerMinXMinYCorner)
           }
           if bottomLeft {
               maskedCorners.insert(.layerMinXMaxYCorner)
           }
           if topRight {
               maskedCorners.insert(.layerMaxXMinYCorner)
           }
           if bottomRight {
               maskedCorners.insert(.layerMaxXMaxYCorner)
           }

        self.layer.layoutIfNeeded()
           // Apply the corner radius
          self.layer.cornerRadius = cornerRadius
          self.layer.maskedCorners = maskedCorners
          self.clipsToBounds = true // This ensures the corner radius is applied correctly
        
        if topBorder, let borderColor = borderColor{
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
            topBorder.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(topBorder)
           
        }
        
        if bottomBorder, let borderColor = borderColor{
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
            bottomBorder.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(bottomBorder)
            
        }
        
        if rightBorder, let borderColor = borderColor{
            let rightBorder = CALayer()
            rightBorder.frame = CGRect(x: self.frame.size.width - 1, y: 0, width: 1, height: self.frame.size.height)
            rightBorder.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(rightBorder)
            
        }
        
        if leftBorder, let borderColor = borderColor{
            let leftBorder = CALayer()
            leftBorder.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.size.height)
            leftBorder.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(leftBorder)
        }
        
    
        
       }
   }

