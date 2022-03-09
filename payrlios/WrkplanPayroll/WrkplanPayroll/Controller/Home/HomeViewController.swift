//
//  HomeViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 17/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import UserNotifications
import SQLite3

struct NavigationMenuData{
    var imageData:UIImage!
    var menuItm:String!
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var NotificationImageView: UIImageView!
    @IBOutlet weak var ScrollViewContainer: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var EmployeeInformationView: UIView!
    @IBOutlet weak var labelEmployeeInformation: UILabel!
    @IBOutlet weak var EmployeeInformationImg: UIImageView!
    
    @IBOutlet weak var LeaveView: UIView!
    @IBOutlet weak var LeaveImg: UIImageView!
    @IBOutlet weak var labelLeave: UILabel!
    
    @IBOutlet weak var EmployeeFacilitiesView: UIView!
    @IBOutlet weak var EmployeeFacilitiesImg: UIImageView!
    @IBOutlet weak var labelEmployeeFacilities: UILabel!
    
    @IBOutlet weak var EmployeeDocImg: UIImageView!
    @IBOutlet weak var EmployeeDocView: UIView!
    @IBOutlet weak var labelEmployeeDoc: UILabel!
    
    @IBOutlet weak var CompanyDocImg: UIImageView!
    @IBOutlet weak var CompanyDocView: UIView!
    @IBOutlet weak var labelCompanyDoc: UILabel!
    
    @IBOutlet weak var InsuranceImg: UIImageView!
    @IBOutlet weak var InsuranceView: UIView!
    @IBOutlet weak var labelInsurance: UILabel!
    
    @IBOutlet weak var HolidayView: UIView!
    @IBOutlet weak var HolidayImg: UIImageView!
    @IBOutlet weak var labelHoliday: UILabel!
    
    @IBOutlet weak var TimesheetView: UIView!
    @IBOutlet weak var TimesheetImg: UIImageView!
    @IBOutlet weak var labelTimesheet: UILabel!
    
    @IBOutlet weak var ODdutyRequestView: UIView!
    @IBOutlet weak var ODdutyRequestImg: UIImageView!
    @IBOutlet weak var labelODdutyRequest: UILabel!
    
    @IBOutlet weak var ODdutyView: UIView!
    @IBOutlet weak var ODdutyImage: UIImageView!
    @IBOutlet weak var labelODduty: UILabel!
    
    @IBOutlet weak var AdvanceView: UIView!
    @IBOutlet weak var AdvanceImage: UIImageView!
    @IBOutlet weak var labelAdvance: UILabel!
    
    
    @IBOutlet weak var ReportsView: UIView!
    @IBOutlet weak var ReportsImage: UIImageView!
    @IBOutlet weak var labelReports: UILabel!
    
    @IBOutlet weak var MediclaimView: UIView!
    @IBOutlet weak var MediclaimImage: UIImageView!
    @IBOutlet weak var LabelMediclaim: UILabel!
    
    @IBOutlet weak var LtaView: UIView!
    @IBOutlet weak var LtaImage: UIImageView!
    @IBOutlet weak var LabelLta: UILabel!
    
    @IBOutlet weak var info_img: UIView!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    //---------variables for navigation drawer starts-------
    @IBOutlet weak var navigationDrawer: UIView!
    @IBOutlet weak var navigationEmployeeName: UILabel!
    @IBOutlet weak var navigationCompanyName: UILabel!
    @IBOutlet weak var tableViewNavigation: UITableView!
    @IBOutlet weak var navigationDrawerTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var navigationDrawerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationDrawerHeight: NSLayoutConstraint!
    
    var menuIsMenuShow = false
    var navigationDrawerData = [NavigationMenuData]()
    
    
    //---------variables for navigation drawer ends-------
    
    
    //---Declaring shared preferences----
    let sharedpreferences = UserDefaults.standard
    
    let userNotificationCenter = UNUserNotificationCenter.current() //---added on 08-Mar-2022
    let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound) //---added on 08-Mar-2022
    
    var db: OpaquePointer? //---added on 09-Mar-2022
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        //---added on 09-Mar-2022, code starts---
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent("WrkplanPayrollNotification.sqlite") //---added on 09-Mar-2022
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS WrkplanPayrollNotification (id INTEGER PRIMARY KEY AUTOINCREMENT, jsonResponse TEXT)", nil, nil, nil) != SQLITE_OK {
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("error creating table: \(errmsg)")
               }
        //---added on 09-Mar-2022, code ends----
        
        //---added on 08-Mar-2022, code starts----
        // Assing self delegate on userNotificationCenter
            self.userNotificationCenter.delegate = self

            self.requestNotificationAuthorization()
            self.sendNotification()
        //---added on 08-Mar-2022, code ends----
       
        tableViewNavigation.dataSource = self
        tableViewNavigation.delegate = self
        tableViewNavigation.backgroundColor = UIColor.white
        
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        print("hometesting-=>",swiftyJsonvar1["employee"]["father_husband_name"].stringValue)
//        print("test-=>",swiftyJsonvar1.stringValue)
        // Do any additional setup after loading the view.
        
        //----------view and label border code styarts--------
        EmployeeInformationView.layer.borderWidth = 1
        EmployeeInformationView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        LeaveView.layer.borderWidth = 1
        LeaveView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        EmployeeFacilitiesView.layer.borderWidth = 1
        EmployeeFacilitiesView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        EmployeeDocView.layer.borderWidth = 1
        EmployeeDocView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        CompanyDocView.layer.borderWidth = 1
        CompanyDocView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        InsuranceView.layer.borderWidth = 1
        InsuranceView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        HolidayView.layer.borderWidth = 1
        HolidayView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        ODdutyRequestView.layer.borderWidth = 1
        ODdutyRequestView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        ODdutyView.layer.borderWidth = 1
        ODdutyView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        TimesheetView.layer.borderWidth = 1
        TimesheetView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        AdvanceView.layer.borderWidth = 1
        AdvanceView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        ReportsView.layer.borderWidth = 1
        ReportsView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        MediclaimView.layer.borderWidth = 1
        MediclaimView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        LtaView.layer.borderWidth = 1
        LtaView.layer.borderColor = UIColor(hexFromString: "D8D7D7").cgColor
        
        labelEmployeeInformation.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelLeave.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelEmployeeFacilities.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelEmployeeDoc.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelCompanyDoc.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelInsurance.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelHoliday.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelODdutyRequest.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelODduty.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelTimesheet.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelAdvance.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        labelReports.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        LabelMediclaim.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        LabelLta.layer.addBorder(edge: UIRectEdge.top, color: UIColor(hexFromString: "D8D7D7"), thickness: 1.0)
        //----------view and label border code styarts--------
        
        
        //-----------code for navigation drawer starts-----------
//        self.navBar.accessibilityFrame = CGRect(x: 0, y: 0, width: Int(view.frame.size.width), height: Int(view.frame.size.height))
        navigationDrawerLeadingConstraint.constant = -(navigationDrawer.frame.size.width)
//        navigationDrawerLeadingConstraint.constant = 0
        navigationDrawerTrailingConstant.constant = view.frame.size.width
        print("navigationframe-=>",navigationDrawerLeadingConstraint.constant)
        //-----------code for navigation drawer ends-----------
        
        //-----------Navigation Drawer code starts-----------
//        navigationLabelEmpName.text = UserSingletonModel.sharedInstance.EmpName
//        navigationLabelCompNAme.text = UserSingletonModel.sharedInstance.CompanyName
        var k = NavigationMenuData()
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
//        menuShow()
        //-----------Navigation Drawer code ends-----------
        
        //EmployeeInformation
        let tapGestureRecognizerEmployeeInformationView = UITapGestureRecognizer(target: self, action: #selector(EmployeeInformationView(tapGestureRecognizer:)))
        EmployeeInformationView.isUserInteractionEnabled = true
        EmployeeInformationView.addGestureRecognizer(tapGestureRecognizerEmployeeInformationView)
        
        let tapGestureRecognizerEmployeeInformationImg = UITapGestureRecognizer(target: self, action: #selector(EmployeeInformationImg(tapGestureRecognizer:)))
        EmployeeInformationImg.isUserInteractionEnabled = true
        EmployeeInformationImg.addGestureRecognizer(tapGestureRecognizerEmployeeInformationImg)
        
        //Leave
        let tapGestureRecognizerLeaveView = UITapGestureRecognizer(target: self, action: #selector(LeaveView(tapGestureRecognizer:)))
        LeaveView.isUserInteractionEnabled = true
        LeaveView.addGestureRecognizer(tapGestureRecognizerLeaveView)
        
        let tapGestureRecognizerLeaveImg = UITapGestureRecognizer(target: self, action: #selector(LeaveImg(tapGestureRecognizer:)))
        LeaveImg.isUserInteractionEnabled = true
        LeaveImg.addGestureRecognizer(tapGestureRecognizerLeaveImg)
        
        //EmployeeFacilities
        let tapGestureRecognizerEmployeefacilitiesView = UITapGestureRecognizer(target: self, action: #selector(EmployeefacilitiesView(tapGestureRecognizer:)))
        EmployeeFacilitiesView.isUserInteractionEnabled = true
        EmployeeFacilitiesView.addGestureRecognizer(tapGestureRecognizerEmployeefacilitiesView)
        
        let tapGestureRecognizerEmployeefacilitiesImg = UITapGestureRecognizer(target: self, action: #selector(EmployeefacilitiesImg(tapGestureRecognizer:)))
        EmployeeFacilitiesImg.isUserInteractionEnabled = true
        EmployeeFacilitiesImg.addGestureRecognizer(tapGestureRecognizerEmployeefacilitiesImg)
        
        //EmployeeDocuments
        let tapGestureRecognizerEmployeedocView = UITapGestureRecognizer(target: self, action: #selector(EmployeedocView(tapGestureRecognizer:)))
        EmployeeDocView.isUserInteractionEnabled = true
        EmployeeDocView.addGestureRecognizer(tapGestureRecognizerEmployeedocView)
        
        let tapGestureRecognizerEmployeedocImg = UITapGestureRecognizer(target: self, action: #selector(EmployeedocImg(tapGestureRecognizer:)))
        EmployeeDocImg.isUserInteractionEnabled = true
        EmployeeDocImg.addGestureRecognizer(tapGestureRecognizerEmployeedocImg)
        
        //CompanyDocs
        let tapGestureRecognizerCompanydocView = UITapGestureRecognizer(target: self, action: #selector(CompanydocView(tapGestureRecognizer:)))
        CompanyDocView.isUserInteractionEnabled = true
        CompanyDocView.addGestureRecognizer(tapGestureRecognizerCompanydocView)
        
        let tapGestureRecognizerCompanydocImg = UITapGestureRecognizer(target: self, action: #selector(CompanydocImg(tapGestureRecognizer:)))
        CompanyDocImg.isUserInteractionEnabled = true
        CompanyDocImg.addGestureRecognizer(tapGestureRecognizerCompanydocImg)
        
        //InsuranceDetails
        let tapGestureRecognizerInsuranceView = UITapGestureRecognizer(target: self, action: #selector(InsuranceView(tapGestureRecognizer:)))
        InsuranceView.isUserInteractionEnabled = true
        InsuranceView.addGestureRecognizer(tapGestureRecognizerInsuranceView)
        
        let tapGestureRecognizerInsuranceImg = UITapGestureRecognizer(target: self, action: #selector(InsuranceImg(tapGestureRecognizer:)))
        InsuranceImg.isUserInteractionEnabled = true
        InsuranceImg.addGestureRecognizer(tapGestureRecognizerInsuranceImg)
        
        //HolidayDetails
        let tapGestureRecognizerHolidayView = UITapGestureRecognizer(target: self, action: #selector(HolidayView(tapGestureRecognizer:)))
        HolidayView.isUserInteractionEnabled = true
        HolidayView.addGestureRecognizer(tapGestureRecognizerHolidayView)
        
        let tapGestureRecognizerHolidayImg = UITapGestureRecognizer(target: self, action: #selector(HolidayImg(tapGestureRecognizer:)))
        HolidayImg.isUserInteractionEnabled = true
        HolidayImg.addGestureRecognizer(tapGestureRecognizerHolidayImg)
        
        //Timesheet
        let tapGestureRecognizerTimesheetView = UITapGestureRecognizer(target: self, action: #selector(TimesheetView(tapGestureRecognizer:)))
        TimesheetView.isUserInteractionEnabled = true
        TimesheetView.addGestureRecognizer(tapGestureRecognizerTimesheetView)
        
        let tapGestureRecognizerTimesheetImg = UITapGestureRecognizer(target: self, action: #selector(TimesheetImg(tapGestureRecognizer:)))
        TimesheetImg.isUserInteractionEnabled = true
        TimesheetImg.addGestureRecognizer(tapGestureRecognizerTimesheetImg)
        
        //OutdoorDutyRequest
        let tapGestureRecognizerODdutyRequestView = UITapGestureRecognizer(target: self, action: #selector(ODdutyRequestView(tapGestureRecognizer:)))
        ODdutyRequestView.isUserInteractionEnabled = true
        ODdutyRequestView.addGestureRecognizer(tapGestureRecognizerODdutyRequestView)
        
        let tapGestureRecognizerODdutyRequestImg = UITapGestureRecognizer(target: self, action: #selector(ODdutyRequestImg(tapGestureRecognizer:)))
        ODdutyRequestImg.isUserInteractionEnabled = true
        ODdutyRequestImg.addGestureRecognizer(tapGestureRecognizerODdutyRequestImg)
        
        //OutdoorDutyLog
        let tapGestureRecognizerODdutyView = UITapGestureRecognizer(target: self, action: #selector(ODdutyLogView(tapGestureRecognizer:)))
        ODdutyView.isUserInteractionEnabled = true
        ODdutyView.addGestureRecognizer(tapGestureRecognizerODdutyView)
        
        let tapGestureRecognizerODdutyImg = UITapGestureRecognizer(target: self, action: #selector(ODdutyLogViewImg(tapGestureRecognizer:)))
        ODdutyImage.isUserInteractionEnabled = true
        ODdutyImage.addGestureRecognizer(tapGestureRecognizerODdutyImg)
        
        //Reports
        let tapGestureRecognizerReportsImg = UITapGestureRecognizer(target: self, action: #selector(ReportsImg(tapGestureRecognizer:)))
        ReportsImage.isUserInteractionEnabled = true
        ReportsImage.addGestureRecognizer(tapGestureRecognizerReportsImg)
        
        let tapGestureReportsView = UITapGestureRecognizer(target: self, action: #selector(ReportsView(tapGestureRecognizer:)))
        ReportsView.isUserInteractionEnabled = true
        ReportsView.addGestureRecognizer(tapGestureReportsView)
        
        //Advance
        let tapGestureRecognizerAdvanceImg = UITapGestureRecognizer(target: self, action: #selector(AdvanceImg(tapGestureRecognizer:)))
        AdvanceImage.isUserInteractionEnabled = true
        AdvanceImage.addGestureRecognizer(tapGestureRecognizerAdvanceImg)
        
        let tapGestureAdvanceView = UITapGestureRecognizer(target: self, action: #selector(AdvanceView(tapGestureRecognizer:)))
        AdvanceView.isUserInteractionEnabled = true
        AdvanceView.addGestureRecognizer(tapGestureAdvanceView)
        
        //Mediclaim
        let tapGestureRecognizerMediclaimImg = UITapGestureRecognizer(target: self, action: #selector(MediclaimImg(tapGestureRecognizer:)))
        MediclaimImage.isUserInteractionEnabled = true
        MediclaimImage.addGestureRecognizer(tapGestureRecognizerMediclaimImg)
        
        let tapGestureMediclaimView = UITapGestureRecognizer(target: self, action: #selector(MediclaimView(tapGestureRecognizer:)))
        MediclaimView.isUserInteractionEnabled = true
        MediclaimView.addGestureRecognizer(tapGestureMediclaimView)
        
        //Lta
        let tapGestureRecognizerLtaImg = UITapGestureRecognizer(target: self, action: #selector(LtaImg(tapGestureRecognizer:)))
        LtaImage.isUserInteractionEnabled = true
        LtaImage.addGestureRecognizer(tapGestureRecognizerLtaImg)
        
        let tapGestureLtaView = UITapGestureRecognizer(target: self, action: #selector(LtaView(tapGestureRecognizer:)))
        LtaView.isUserInteractionEnabled = true
        LtaView.addGestureRecognizer(tapGestureLtaView)
        
        
        
        check_od_duty_log_status()
    }
    
    //---added on 08-Mar-2022, code starts---
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
    
    func sendNotification() {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()

        // Add the content to the notification content
        notificationContent.title = "Test"
        notificationContent.body = "Test body"
        notificationContent.badge = NSNumber(value: 3)

        // Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "dune",
                                        withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
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
    //---added on 08-Mar-2022, code ends---
    
    //---Lta
    @objc func LtaImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "lta", sender: nil)
    }
    @objc func LtaView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "lta", sender: nil)
    }
    
    //---Mediclaim
    @objc func MediclaimImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
    }
    @objc func MediclaimView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
    }
    
    //---Advance
    @objc func AdvanceImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "advancerequisition", sender: nil)
    }
    @objc func AdvanceView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "advancerequisition", sender: nil)
    }
    
    //---Reports
    @objc func ReportsImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "reports", sender: nil)
    }
    @objc func ReportsView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "reports", sender: nil)
    }
    
    //---EmployeeInformation
    @objc func EmployeeInformationView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empinfo", sender: nil)
    }
    
    @objc func EmployeeInformationImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empinfo", sender: nil)
    }
    

    //---Leave
    @objc func LeaveView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "leave", sender: nil)
    }
    
    @objc func LeaveImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "leave", sender: nil)
    }
    
    //---Employee Facilities
    @objc func EmployeefacilitiesView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "facilities", sender: nil)
    }
    
    @objc func EmployeefacilitiesImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "facilities", sender: nil)
    }
    
    //---Employee Documents
    @objc func EmployeedocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empdoc", sender: nil)
    }
    
    @objc func EmployeedocImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empdoc", sender: nil)
    }
    
    //---Compny Documents
    @objc func CompanydocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "companydoc", sender: nil)
    }
    
    @objc func CompanydocImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "companydoc", sender: nil)
    }
    
    //--Insurance Details
    @objc func InsuranceView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "insurance", sender: nil)
    }
    
    @objc func InsuranceImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "insurance", sender: nil)
    }
    
    //--Holiday Details
    @objc func HolidayView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "holiday", sender: nil)
    }
    
    @objc func HolidayImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "holiday", sender: nil)
    }
    
    //--Timesheet Details
    @objc func TimesheetView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "timesheet", sender: nil)
        print("tapped")
    }
    
    @objc func TimesheetImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "timesheet", sender: nil)
    }
    
    //---OutDoorDutyRequest
    @objc func ODdutyRequestView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "outdoordutylist", sender: nil) //--23rd march temp
    }
    
    @objc func ODdutyRequestImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
    }
    
    //---OutDoorDutyLog
    @objc func ODdutyLogView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "odloglist", sender: nil) //--23rd march temp
    }
    
    @objc func ODdutyLogViewImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "odloglist", sender: nil)
    }
    
    
    //--------tableview code starts--------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        navigationDrawerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewNavigation.dequeueReusableCell(withIdentifier: "cell") as! HomeNavigationControllerTableViewCell
        tableView.separatorColor = UIColor.white
        
        var dict = navigationDrawerData[indexPath.row]
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
            }else if row.menuItm == "Employee Facilities"{
                menuClose()
                self.performSegue(withIdentifier: "empdoc", sender: nil)
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
        }
    }
    //--------tableview code ends--------
    
    //-----------function for navigation drawer code, starts-----------
    func menuShow(){
        if menuIsMenuShow{
            self.canelBlurEffect()
            //            self.view.removeFromSuperview()
            self.navigationDrawerLeadingConstraint.constant = -(navigationDrawer.frame.size.width)
            self.navigationDrawerTrailingConstant.constant = view.frame.size.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            blurEffect()
            self.view.addSubview(navigationDrawer)
//            let screenSize: CGRect = UIScreen.main.bounds
//            self.navigationDrawerHeight.constant = screenSize.height
//            navigationDrawerLeadingConstraint.constant = 0
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
        self.canelBlurEffect()
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
    
    
    //----function to get data to check od_duty_status from api using Alamofire and Swiftyjson to load data,code starts-----
    func check_od_duty_log_status(){
//           loaderStart()
        
        let url = "\(BASE_URL)od/request/check-exist/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("odDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
//               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["request_list"].arrayObject{
//                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                if swiftyJsonVar["status"] == "true"{
                    self.info_img.isHidden = false
                    if swiftyJsonVar["next_action"] == "START"{
                        self.info_img.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "PAUSE"{
                        self.info_img.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "STOP"{
                        self.info_img.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "NA"{
                        self.info_img.isHidden = true
                    }
                }else if swiftyJsonVar["status"] == "false"{
                    self.info_img.isHidden = true
                }
                 
               }
               
           }
       }
    //----function to get data to check od_duty_status from api using Alamofire and Swiftyjson to load data,code ends-----
    
    //=============FormDialog Change Password code starts===========
    
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
    //=============FormDialog Change Password code ends===========
    
    //==============FormDialog Logout code starts================
    @IBOutlet var viewFormLogoutPopup: UIView!
    
    func openLogoutFormPopup(){
        blurEffect()
        self.view.addSubview(viewFormLogoutPopup)
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
        }
    }
    
    @IBAction func btnLogoutPopupYes(_ sender: Any) {
        cancelLogoutFormPopup()
        sharedpreferences.removeObject(forKey: "UserId")
        sharedpreferences.synchronize()
        
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func btnLogoutPopupNo(_ sender: Any) {
        cancelLogoutFormPopup()
    }
    //==============FormDialog Logout code ends================
    
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
            blurEffectView.frame = ScrollView.bounds
            blurEffectView.alpha = 0.9
            ScrollView.addSubview(blurEffectView)
            // screen roted and size resize automatic
            blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
          
        }
        func canelBlurEffect() {
            self.blurEffectView.removeFromSuperview();
        }
        // ====================== Blur Effect END ================= \\

}

//-------------following extension is for own knowledge, code ends-------------
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            if UIScreen.main.nativeBounds.height == 1792{
                border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
            }else{
                border.frame = CGRect(x: 0, y: 0, width: self.bounds.width-20, height: thickness)
            }
            
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.bounds.height - thickness,  width: self.bounds.width, height: thickness)
            
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0,  width: thickness, height: self.bounds.height)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: self.bounds.width - thickness, y: 0,  width: thickness, height: self.bounds.height)
            
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
};

extension UIViewController{
    func ChangeStatusBarColor(){
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
//            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(hexFromString: "3982cb")
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//            statusBar?.backgroundColor = UIColor(hexFromString: "2E5771")
            statusBar?.backgroundColor = UIColor(hexFromString: "3982cb")
        }
    }
}
