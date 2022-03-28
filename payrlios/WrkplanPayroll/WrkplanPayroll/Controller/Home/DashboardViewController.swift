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

class DashboardViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ViewEmpDetails: UIView!
    @IBOutlet weak var LabelEmpName: UILabel!
    @IBOutlet weak var LabelDesignation: UILabel!
    @IBOutlet weak var LabelDepartment: UILabel!
    @IBOutlet weak var LabelSupervisor1: UILabel!
    @IBOutlet weak var LabelSupervisor2: UILabel!
    
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
    
    //---Attendance variables, ends----
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    @IBOutlet weak var LabelCorpId: UILabel!
    @IBOutlet weak var ViewCalendar: UIView!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        LoadEmployeeDetails()
        LoadCalendarDetails()
        ChangeStatusBarColor()
        
        LoadAttendanceData()
        
    }
    func LoadEmployeeDetails(){
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        self.LabelEmpName.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        self.LabelDesignation.text = swiftyJsonvar1["employee"]["designation_name"].stringValue
        self.LabelDepartment.text = swiftyJsonvar1["company"]["company_name"].stringValue
        self.LabelSupervisor1.text = swiftyJsonvar1["employee"]["supervisor_1_name"].stringValue
        self.LabelSupervisor2.text = swiftyJsonvar1["employee"]["supervisor_2_name"].stringValue
        self.LabelCorpId.text = swiftyJsonvar1["company"]["corporate_id"].stringValue
    }
    
    func LoadCalendarDetails(){
       
    }
    
    //===================Code for Attendance section, starts============
    
    func LoadAttendanceData(){
        TxtViewWFH.backgroundColor = UIColor(hexFromString: "ffffff")
        btnCheckBox.setImage(UIImage(named:"check_box_empty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"check_box"), for: .selected)
        
        TxtViewWFHHeightConstraint.constant = 0
        self.TxtViewWFH.layer.borderColor = UIColor.lightGray.cgColor
        self.TxtViewWFH.layer.borderWidth = 1
        
        //-----code to get current date and show date in the label, starts-----
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        label_date_today.text = formatter.string(from: date)
        //-----code to get current date and show date in the label, starts-----
        
        //---camera
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.allowsEditing = false
        
        
        //MyAttendanceLog OnClick
        let tapGestureRecognizerInOutbtn = UITapGestureRecognizer(target: self, action: #selector(ViewBtn(tapGestureRecognizer:)))
        ViewBtnInOut.isUserInteractionEnabled = true
        ViewBtnInOut.addGestureRecognizer(tapGestureRecognizerInOutbtn)
        
        load_data_check_od_duty()
    }
    //---ViewBtnInOut OnClick
    @objc func ViewBtn(tapGestureRecognizer: UITapGestureRecognizer){
        if LabelInOut.text == "IN" {
            TimesheetMyAttendanceViewController.in_out = "IN"
            TimesheetMyAttendanceViewController.work_frm_home_flag = work_from_home_flag
            TimesheetMyAttendanceViewController.work_from_home_detail = self.TxtViewWFH.text!
            TimesheetMyAttendanceViewController.message_in_out = "Attendance IN time recorded"
            
    //        self.save_in_out_data(in_out: "IN", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.tv_wrk_frm_home.text!, message_in_out: "Attendance IN time recorded",imageBase64: "") //--previously work from home flag was 1, but it gives some problem //--commented on 31st may temp
            if swiftyJsonvar1["company"]["attendance_with_selfie_yn"].intValue == 1 {
            openSelfieConfirmationPopup()
            }else{
                self.save_in_out_data(in_out: "IN", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.TxtViewWFH.text!, message_in_out: "Attendance IN time recorded",imageBase64: "")
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
                            openSelfieConfirmationPopup()
                            }else{
                                self.save_in_out_data(in_out: "OUT", work_frm_home_flag: work_from_home_flag, work_from_home_detail: self.TxtViewWFH.text!, message_in_out: "Attendance OUT time recorded",imageBase64: "")
                            }
    //                        load_data_check_od_duty()
                            
                            self.TxtViewWFHHeightConstraint.constant = 0
                            self.btnCheckBox.isHidden = true
                          }
        }
    }
    @IBAction func checkMarkedTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                if(!sender.isSelected){
                    sender.isSelected = true
                    sender.transform = .identity
                    self.checkBtnYN = 1
                    self.TxtViewWFHHeightConstraint.constant = 44
                    print("checked", self.checkBtnYN)
                    self.work_from_home_flag = 1
                }else{
                    sender.isSelected = false
                    sender.transform = .identity
                    self.checkBtnYN = 0
                    self.TxtViewWFHHeightConstraint.constant = 0
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
            
            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "FF0000")
            self.LabelInOut.text = "OUT"
            
        }else if message_in_out == "OUT" {
            /*self.btn_out.isEnabled = false
            self.btn_out.alpha = CGFloat(0.6)*/
            
            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "0276FD")
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
                        self.load_data_check_od_duty()
                    }
                }
                
                break
                
            case .failure(let error):
                
                print(error)
            }
            
        }
    }
    
    //========function to save data for IN/OUT, code ends=======
    
    //===========Code for getting time_in and time_out, starts==========
    func load_data_check_od_duty(){
        self.loaderStart()
        let url = "\(BASE_URL)timesheet/log/today/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)"
        //        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
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
                    
                        self.LabelInTime.text = dateFormatterPrint.string(from: TimeIn)
                    }
                    if let TimeOut = dateFormatterGet.date(from: swiftyJsonVar["time_out"].stringValue){
                        self.LabelOutTime.text = dateFormatterPrint.string(from: TimeOut)
                    }
                    
                    print("timesheet_id-=>",self.timesheet_id!)
                    print("work_from_home_flag-=>",self.work_from_home_flag!)
                    if self.timesheet_id! != 0 {
                        if self.work_from_home_flag == 1 {
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            self.btnCheckBox.isSelected = true
                            self.btnCheckBox.isEnabled = false
                            
                            self.TxtViewWFHHeightConstraint.constant = 44
                            self.TxtViewWFH.text = self.work_from_home_detail
                            self.TxtViewWFH.isEditable = true
                            
                            
                        } else if self.work_from_home_flag == 0 {
                            self.btnCheckBox.isHidden = true
                            self.label_wrk_from_home.isHidden = true
                            self.TxtViewWFHHeightConstraint.constant = 0
                            
                        }else{
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            self.btnCheckBox.isEnabled = true
                            
                            self.TxtViewWFHHeightConstraint.constant = 44
                            
                        }
                    }
                    if(swiftyJsonVar["timesheet_in_out_action"].exists()) {
                        if swiftyJsonVar["timesheet_in_out_action"].stringValue == "IN" {
                            self.btnCheckBox.isHidden = false
                            
                          /*  self.btn_in.isHidden = false
                            self.btn_out.isHidden = true*/
                            self.ViewBtnInOut.isHidden = false
                            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "0276FD")
                            self.LabelInOut.text = "IN"
                            
                            
                        } else if swiftyJsonVar["timesheet_in_out_action"].stringValue == "OUT" {
                            self.btnCheckBox.isHidden = false
                            self.label_wrk_from_home.isHidden = false
                            
                           /* self.btn_in.isHidden = true
                            self.btn_out.isHidden = false */
                            
                            self.ViewBtnInOut.isHidden = false
                            self.ViewBtnInOut.backgroundColor = UIColor(hexFromString: "FF0000")
                            self.LabelInOut.text = "OUT"
                            
                        } else {
                            self.btnCheckBox.isHidden = true
                            self.label_wrk_from_home.isHidden = true
                            
                           /* self.btn_in.isHidden = true
                            self.btn_out.isHidden = true*/
                            
                            self.ViewBtnInOut.isHidden = true
                            
                        }
                    }else {
                        self.btnCheckBox.isHidden = true
                        self.label_wrk_from_home.isHidden = true
                        
                       /* self.btn_in.isHidden = true
                        self.btn_out.isHidden = true */
                        
                        self.ViewBtnInOut.isHidden = true
                        
                    }
                    
                }
            }
            
        }
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
    
    //===============Selfie Confirmation Popup code starts(added on 31st may)===================
    @IBOutlet weak var btnPopupYes: UIButton!
    @IBOutlet weak var btnPopupNo: UIButton!
    @IBAction func btnPopupYes(_ sender: Any) {
        closeSelfieConfirmationPopup()
//        self.performSegue(withIdentifier: "dashboard", sender: nil)
//        self.DeleteImage(stringCheck: "DeleteFacesResult")
        present(imagePicker, animated: true, completion: nil)
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
        viewSelfie.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewSelfie.center = self.view.center
        viewSelfie.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewSelfie.alpha = 0
        viewSelfie.sizeToFit()
        
        stackViewEnrollPopupButton.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
//        view_custom_btn_punchout.addBorder(side: .top, color: UIColor(hexFromString: "4f4f4f"), width: 1)
        btnPopupYes.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        
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
    //===============Selfie Confirmation Popup code ends(added on 31st may)===================
    
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
    //===================Code for Attendance section, starts============
    
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
