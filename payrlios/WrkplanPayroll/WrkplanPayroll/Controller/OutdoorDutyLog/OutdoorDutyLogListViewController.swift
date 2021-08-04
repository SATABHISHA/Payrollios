//
//  OutdoorDutyLogListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/03/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Toast_Swift

class OutdoorDutyLogListViewController: UIViewController, CLLocationManagerDelegate,  UITableViewDelegate, UITableViewDataSource, OdDutyLogListTableViewCellDelegate  {
    
    
    @IBOutlet weak var view_start_stop: UIView!
    @IBOutlet weak var view_start_stop_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var img_start_stop: UIImageView!
    @IBOutlet weak var view_start_stop_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var label_start_stop: UILabel!
    
    @IBOutlet weak var view_pause: UIView!
    @IBOutlet weak var view_pause_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var view_pause_top_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var label_todays_od_duty: UILabel!
    @IBOutlet weak var label_todays_od_duty_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var label_date: UILabel!
    
    @IBOutlet weak var view_border_line: UIView!
    @IBOutlet weak var view_border_line_top_constraint: NSLayoutConstraint!
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var tableviewOdDutyLog: UITableView!
    @IBOutlet weak var tableviewOdDutyLog_top_constraint: NSLayoutConstraint!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var arrRes = [[String:AnyObject]]()
    
    static var currentlatitude:Double = 0.0
    static var currentLongitude:Double = 0.0
    static var currentAddress:String = ""
    static var od_request_id_current_activity:Int?
    static var od_status:String = ""
    
    static var Log_employee_id: Int!
    static var Log_task_employee_name: String!
    static var Log_task_date: String!
    static var log_task_status: Int! //-----added by Satabhisha(log_task_status is used to identify supervisor and subordinate for task detail section)
    static var od_request_id: Int!
    
    
    @IBOutlet weak var CustomLabelSubordinateOdDutyLog: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor()
        
        self.tableviewOdDutyLog.delegate = self
        self.tableviewOdDutyLog.dataSource = self
        
        self.tableviewOdDutyLog.backgroundColor = UIColor(hexFromString: "ffffff")
        
        //        determineMyCurrentLocation()
        determineMyCurrentLocation(status: "Start")
        // Do any additional setup after loading the view.
        check_od_duty_log_status()
        
        loadData()
        
        //Start/Stop
        let tapGestureRecognizerStartStopView = UITapGestureRecognizer(target: self, action: #selector(StartStopView(tapGestureRecognizer:)))
        view_start_stop.isUserInteractionEnabled = true
        view_start_stop.addGestureRecognizer(tapGestureRecognizerStartStopView)
        
        //Pause
        let tapGestureRecognizerPauseView = UITapGestureRecognizer(target: self, action: #selector(PauseView(tapGestureRecognizer:)))
        view_pause.isUserInteractionEnabled = true
        view_pause.addGestureRecognizer(tapGestureRecognizerPauseView)
        
        //SubordinateOdDutyLog
        let tapGestureRecognizerSubordinateOdDutyLogView = UITapGestureRecognizer(target: self, action: #selector(SubordinateOdDutyLogView(tapGestureRecognizer:)))
        CustomLabelSubordinateOdDutyLog.isUserInteractionEnabled = true
        CustomLabelSubordinateOdDutyLog.addGestureRecognizer(tapGestureRecognizerSubordinateOdDutyLogView)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    
    //Subordinate
    //---Start/Stop
    @objc func SubordinateOdDutyLogView(tapGestureRecognizer: UITapGestureRecognizer){
        determineMyCurrentLocation(status: "Stop")
        self.performSegue(withIdentifier: "subodlog", sender: self)
        
    }
    
    //---Start/Stop
    @objc func StartStopView(tapGestureRecognizer: UITapGestureRecognizer){
        determineMyCurrentLocation(status: "Start")
        if OutdoorDutyLogListViewController.od_status == "START"{
            print("Start")
            SaveData(log_action: "START", message: "Outdoor Duty Started")
        }else if OutdoorDutyLogListViewController.od_status == "PAUSE"{
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Alert", message: "Do you really want to stop today's outdoor duty? Once stopped cannot be started again. Proceed?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                //                                print("Ok button tapped")
                
                //                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
                self.SaveData(log_action: "STOP", message: "Outdoor Duty Stopped")
                dialogMessage.dismiss(animated: true, completion: nil)
                
                
            })
            let cancel = UIAlertAction(title: "No", style: .destructive, handler: { (action) -> Void in
                //                                print("Ok button tapped")
                
                //                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
                
                
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            //            SaveData(log_action: "STOP", message: "Outdoor Duty Stopped")
            //            print("Stop")
        }
        
    }
    //---Pause
    @objc func PauseView(tapGestureRecognizer: UITapGestureRecognizer){
        determineMyCurrentLocation(status: "Start")
        //        self.performSegue(withIdentifier: "empinfo", sender: nil)
        SaveData(log_action: "PAUSE", message: "Outdoor Duty Paused")
        
    }
    
    //----------tableview code starts------------
    //    var rowIndex: Int! // --for instant delete delaring the variable
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OdDutyLogListTableViewCell
        //        rowIndex = indexPath.row
        
        cell.delegate = self
        
        let dict = arrRes[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        //        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        //        dateFormatterGet.dateFormat = "dd-MM-yyyy hh:mm:ss" //--for test version
        
        dateFormatterGet.dateFormat = "dd-MMM-yyyy" //--format changed in ios on 24th feb
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        //        let date = dateFormatterGet.date(from: (dict["date"] as? String)!)
        //                labelDate.text = eventData[i].date
        //        cell.label_date.text = dateFormatterPrint.string(from: date!)
        
        cell.label_date.text = dict["od_duty_log_date"] as? String
        cell.label_time_log.text = "View \n Time Log"
        
        
        return cell
        
    }
    
    func OdDutyLogListTableViewCellDidTapView(_ sender: OdDutyLogListTableViewCell) {
        guard let tappedIndexPath = tableviewOdDutyLog.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        
        OutdoorDutyLogListViewController.Log_employee_id = rowData["employee_id"] as? Int
        OutdoorDutyLogListViewController.Log_task_employee_name = rowData["employee_name"] as? String
        OutdoorDutyLogListViewController.Log_task_date = rowData["od_duty_log_date"] as? String
        OutdoorDutyLogListViewController.od_request_id = rowData["od_request_id"] as? Int
        OutdoorDutyLogListViewController.log_task_status = 0
        
        
        self.performSegue(withIdentifier: "odlogtask", sender: nil)
        determineMyCurrentLocation(status: "Stop")
        
    }
    
    //---for tiem log
    func OdDutyLogListTableViewCellDidTapViewTimeLog(_ sender: OdDutyLogListTableViewCell) {
        guard let tappedIndexPath = tableviewOdDutyLog.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        
        OutdoorDutyLogListViewController.Log_employee_id = rowData["employee_id"] as? Int
        OutdoorDutyLogListViewController.Log_task_employee_name = rowData["employee_name"] as? String
        OutdoorDutyLogListViewController.Log_task_date = rowData["od_duty_log_date"] as? String
        OutdoorDutyLogListViewController.od_request_id = rowData["od_request_id"] as? Int
        OutdoorDutyLogListViewController.log_task_status = 0
        
        
        self.performSegue(withIdentifier: "odDutyTimeLog", sender: nil)
        determineMyCurrentLocation(status: "Stop")
    }
    //----------tableview code ends------------
    
    
    //-------Location, code starts
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
        OutdoorDutyLogListViewController.currentlatitude = userLocation.coordinate.latitude
        OutdoorDutyLogListViewController.currentLongitude = userLocation.coordinate.longitude
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
                                            OutdoorDutyLogListViewController.currentAddress = addressString
                                        }
                                    })
        
    }
    //-------Location code ends
    
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
                OutdoorDutyLogListViewController.od_request_id_current_activity = swiftyJsonVar["od_request_id"].intValue
                if swiftyJsonVar["status"] == "true"{
                    //                    self.info_img.isHidden = false
                    if swiftyJsonVar["next_action"] == "START"{
                        OutdoorDutyLogListViewController.od_status = "START"
                        self.view_start_stop.backgroundColor = UIColor(hexFromString: "#dce9ab")
                        self.view_start_stop.isUserInteractionEnabled = true
                        self.img_start_stop.image = UIImage(named: "od_start")
                        self.view_pause.isHidden = true
                        self.label_start_stop.text = "START"
                        //                        self.img_start_stop.image =
                    }else if swiftyJsonVar["next_action"] == "PAUSE"{
                        OutdoorDutyLogListViewController.od_status = "PAUSE"
                        self.view_start_stop.backgroundColor = UIColor(hexFromString: "#febbaf")
                        self.view_start_stop.isUserInteractionEnabled = true
                        self.img_start_stop.image = UIImage(named: "od_stop")
                        self.label_start_stop.text = "STOP"
                        self.view_pause.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "STOP"{
                        OutdoorDutyLogListViewController.od_status = "STOP"
                        self.view_start_stop.backgroundColor = UIColor(hexFromString: "#febbaf")
                        self.view_start_stop.isUserInteractionEnabled = true
                        self.img_start_stop.image = UIImage(named: "od_stop")
                        self.label_start_stop.text = "STOP"
                        self.view_pause.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "NA"{
                        OutdoorDutyLogListViewController.od_status = "NA"
                        self.view_pause.isHidden = true
                        self.view_start_stop.isHidden = true
                        self.label_date.isHidden = true
                        self.label_todays_od_duty.isHidden = true
                        self.view_border_line.isHidden = true
                        
                        self.view_start_stop_top_constraint.constant = 0
                        self.view_start_stop_height_constraint.constant = 0
                        
                        self.view_pause_top_constraint.constant = 0
                        self.view_pause_height_constraint.constant = 0
                        
                        self.label_todays_od_duty_top_constraint.constant = 0
                        self.view_border_line_top_constraint.constant = 0
                        
                        self.tableviewOdDutyLog_top_constraint.constant = 0
                    }
                }else if swiftyJsonVar["status"] == "false"{
                    OutdoorDutyLogListViewController.od_status = "NA"
                    self.view_pause.isHidden = true
                    self.view_start_stop.isHidden = true
                    self.label_date.isHidden = true
                    self.label_todays_od_duty.isHidden = true
                    self.view_border_line.isHidden = true
                    
                    self.view_start_stop_top_constraint.constant = 0
                    self.view_start_stop_height_constraint.constant = 0
                    
                    self.view_pause_top_constraint.constant = 0
                    self.view_pause_height_constraint.constant = 0
                    
                    self.label_todays_od_duty_top_constraint.constant = 0
                    self.view_border_line_top_constraint.constant = 0
                    
                    self.tableviewOdDutyLog_top_constraint.constant = 0
                }
                
            }
            
        }
    }
    //----function to get data to check od_duty_status from api using Alamofire and Swiftyjson to load data,code ends-----
    
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        
        let url = "\(BASE_URL)od/log/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("odDutylisturl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                if let resData = swiftyJsonVar["items"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.tableviewOdDutyLog.reloadData()
                }else{
                    self.tableviewOdDutyLog.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewOdDutyLog.bounds.size.width, height: self.tableviewOdDutyLog.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.tableviewOdDutyLog.backgroundView  = noDataLabel
                    self.tableviewOdDutyLog.separatorStyle  = .none
                    
                }
            }
            
        }
    }
    //--------function to show log details using Alamofire and Json Swifty code ends------------
    
    //-----function to save data, code starts---
    func SaveData(log_action: String, message: String){
        let url = "\(BASE_URL)od/log/save"
        print("savelog_url-=>",url)
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "od_duty_log_date": Date().string(format: "yyyy-MM-dd"),
            "od_request_id": OutdoorDutyLogListViewController.od_request_id_current_activity!,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].intValue,
            "log_action": log_action,
            "log_datetime": Date().string(format: "yyyy-MM-dd HH:mm:ss.SSS"),
            "latitude":String(format: "%.6f", OutdoorDutyLogListViewController.currentlatitude),
            "longitude": String(format: "%.6f", OutdoorDutyLogListViewController.currentLongitude),
            //            "latitude": String(OutdoorDutyLogListViewController.currentlatitude),
            //            "longitude": String(OutdoorDutyLogListViewController.currentLongitude),
            "location_address": String(OutdoorDutyLogListViewController.currentAddress),
            "entry_user": LoginViewController.entry_user,
            
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
                    let dialogMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                        //                                print("Ok button tapped")
                        
                        //                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
                        
                        self.loadData()
                        self.check_od_duty_log_status()
                        self.determineMyCurrentLocation(status: "Stop")
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
                    
                    self.determineMyCurrentLocation(status: "Stop")
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
                self.determineMyCurrentLocation(status: "Stop")
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
};

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
