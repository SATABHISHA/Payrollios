//
//  HomeViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 17/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

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
    
    @IBOutlet weak var info_img: UIView!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
       
        
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        print("hometesting-=>",swiftyJsonvar1["employee"]["father_husband_name"].stringValue)
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
        //----------view and label border code styarts--------
        
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
        
        check_od_duty_log_status()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
