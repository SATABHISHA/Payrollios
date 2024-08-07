//
//  SubordinateMyAttendanceLogViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Lottie

class SubordinateMyAttendanceLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableviewSubordinateMyAttendanceLog: UITableView!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_prev: UIButton!
    @IBOutlet weak var StackViewTableHeader: UIStackView!
    @IBOutlet weak var ViewTableCustomFooter: UIView!
    
    @IBOutlet weak var label_total_hours: UILabel!
    @IBOutlet weak var label_total_present_count: UILabel!
    @IBOutlet weak var SwipeUpAnimationView: LottieAnimationView!
    var month_number:Int?
    var year:Int?
    
    lazy var TotalOfficeWorkingDaysTillDate = 0
    lazy var TotalOfficePresent : Int = 0
    lazy var TotalAbsent : Int = 0
    lazy var TotalLate : Int = 0
    lazy var TotalHoliday : Int = 0
    lazy var TotalLeave : Int = 0
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    
    let dropDown = DropDown()
    var name = [String]()
    static var slno: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        //---TableHeader and TableFooter customization, code starts(added on 27-Mar-2024)
        self.StackViewTableHeader.clipsToBounds = true
        self.StackViewTableHeader.layer.cornerRadius = 10
        self.StackViewTableHeader.backgroundColor = UIColor(hexFromString: "CBCBCB")
        self.StackViewTableHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.StackViewTableHeader.layer.shadowColor = UIColor.gray.cgColor
        self.StackViewTableHeader.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.StackViewTableHeader.layer.shadowOpacity = 3
        self.StackViewTableHeader.layer.shadowRadius = 3.0
        
        self.ViewTableCustomFooter.clipsToBounds = true
        self.ViewTableCustomFooter.layer.cornerRadius = 10
        self.ViewTableCustomFooter.backgroundColor = UIColor(hexFromString: "CBCBCB")
        self.ViewTableCustomFooter.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.ViewTableCustomFooter.layer.shadowColor = UIColor.gray.cgColor
        self.ViewTableCustomFooter.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.ViewTableCustomFooter.layer.shadowOpacity = 3
        self.ViewTableCustomFooter.layer.shadowRadius = 3.0
        
        
        SwipeUpAnimationView.layer.cornerRadius = SwipeUpAnimationView.frame.width / 2
        SwipeUpAnimationView.layer.masksToBounds = true
        
        SwipeUpAnimationView.contentMode = .scaleAspectFit
        SwipeUpAnimationView.loopMode = .loop
        SwipeUpAnimationView.animationSpeed = 0.8
//        SwipeUpAnimationView.transform = CGAffineTransform(scaleX: 1, y: -1)
        SwipeUpAnimationView.play()
        
        let tapGestureRecognizerSwipeUpAttendanceDetails = UITapGestureRecognizer(target: self, action: #selector(swipe_up_attendance_details(tapGestureRecognizer: )))
        SwipeUpAnimationView.isUserInteractionEnabled = true
        SwipeUpAnimationView.addGestureRecognizer(tapGestureRecognizerSwipeUpAttendanceDetails)
        self.tableviewSubordinateMyAttendanceLog.delegate = self
        self.tableviewSubordinateMyAttendanceLog.dataSource = self
        tableviewSubordinateMyAttendanceLog.backgroundColor = UIColor(hexFromString: "ffffff")
        self.tableviewSubordinateMyAttendanceLog.borderWidth = 0.8
        self.tableviewSubordinateMyAttendanceLog.borderColor = UIColor(hexFromString: "CBCBCB")
        
        //---TableHeader and TableFooter customization, code ends(added on 27-Mar-2024)
        
        
        self.tableviewSubordinateMyAttendanceLog.delegate = self
        self.tableviewSubordinateMyAttendanceLog.dataSource = self
        
        tableviewSubordinateMyAttendanceLog.backgroundColor = UIColor(hexFromString: "ffffff")
        
        // Do any additional setup after loading the view.
        month_number = Calendar.current.component(.month, from: Date())
        year = Calendar.current.component(.year, from: Date())
        
        btn_next.isHidden = true
        btn_prev.isHidden = true
        label_date.isHidden = true
        
        
        print("Month_number-=>",month_number!)
        print("Year-=>",year!)
        
        getEmpName()
        print("name-=>",name)
    }
    
    @objc func swipe_up_attendance_details(tapGestureRecognizer: UITapGestureRecognizer){
       openAttendanceDetailsPopup()
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "subordinatelog", sender: nil)
    }
    func getEmpName(){
        for i in 0..<SubordinateLogViewController.subordinate_details.count{
            self.name.append(SubordinateLogViewController.subordinate_details[i].employee_name!)
        }
    }
    @IBAction func btn_dropdown(_ sender: UIButton) {
        print("tappedname-=>",name)
        dropDown.dataSource = name
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
            print("name-=>",SubordinateLogViewController.subordinate_details[index].slno!)
            SubordinateMyAttendanceLogViewController.slno = SubordinateLogViewController.subordinate_details[index].slno!
            //            self!.loadData(year: item)
            
            //--adeded on 24th feb, starts
            self!.btn_next.isHidden = false
            self!.btn_prev.isHidden = false
            self!.label_date.isHidden = false
            
            self!.loadData(month_number: self!.month_number!, year: self!.year!)
            sender.setTitleColor(UIColor(hexFromString: "565555"), for: .normal)
            
            //--adeded on 24th feb, ends
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btn_prev(_ sender: Any) {
        var temp_month_no: Int = month_number!
        var temp_year: Int = year!
        if temp_month_no <= 1 {
            temp_month_no = 12
            temp_year = temp_year-1
        }else{
            temp_month_no = temp_month_no - 1
            temp_year = year!
        }
        month_number = temp_month_no
        year = temp_year
        loadData(month_number: month_number!, year: year!)
        
        
    }
    
    
    @IBAction func btn_next(_ sender: Any) {
        var temp_month_no: Int = month_number!
        var temp_year: Int = year!
        if temp_month_no >= 12 {
            temp_month_no = 1
            temp_year = temp_year+1
        }else{
            temp_month_no = temp_month_no + 1
            temp_year = year!
        }
        month_number = temp_month_no
        year = temp_year
        loadData(month_number: month_number!, year: year!)
    }
    @IBAction func btn_home(_ sender: Any) {
    }
    
    //----------tableview code starts------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyAttendanceLogTableViewCell
        let dict = arrRes[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        //        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        //        dateFormatterGet.dateFormat = "dd-MM-yyyy hh:mm:ss" //--for test version
        dateFormatterGet.dateFormat = "dd-MMM-yyyy" //--format changed in ios on 24th feb
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        let date = dateFormatterGet.date(from: (dict["date"] as? String)!)
        //                labelDate.text = eventData[i].date
        cell.label_date.text = dateFormatterPrint.string(from: date!)
        
        cell.label_timein.text = dict["time_in"] as? String
        cell.label_timeout.text = dict["time_out"] as? String
        cell.label_status.text = dict["attendance_status"] as? String
        cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)
        
        cell.label_status.layer.masksToBounds = true
        
        if dict["attendance_status"] as! String == "Absent"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#ffffff")
            //            cell.label_status.backgroundColor = UIColor(hexFromString: "#FF0000")
            cell.label_status.cornerRadius = 5
        }else if dict["attendance_status"] as! String == "Present" {
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#6E6E6E")
            //            cell.label_status.backgroundColor = UIColor(hexFromString: "#00FF00")
            cell.label_status.cornerRadius = 5
        }else if dict["attendance_status"] as! String == "Present(WFH)"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#6E6E6E")
            //            cell.label_status.backgroundColor = UIColor(hexFromString: "#00FF00")
            cell.label_status.cornerRadius = 5
        }else if dict["attendance_status"] as! String == "WFH"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#ffffff")
            //            cell.label_status.backgroundColor = UIColor(hexFromString: "#00FF00")
            cell.label_status.cornerRadius = 5
        }
        else if dict["attendance_status"] as! String == "Holiday"{
            cell.label_status.isHidden = false
            cell.label_status.textColor = UIColor(hexFromString: "#ffffff")
            //            cell.label_status.backgroundColor = UIColor(hexFromString: "#00FF00")
            cell.label_status.cornerRadius = 5
        }
        else{
            cell.label_status.isHidden = true
            cell.label_status.backgroundColor = UIColor(hexFromString: "#ffffff")
            cell.label_status.cornerRadius = 5
        }
        return cell
        
    }
    //----------tableview code ends------------
    //---code added on 20-May-2024, starts
    // Function to calculate total hours between time_in and time_out
    func calculateTotalHours(timeIn: String, timeOut: String) -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        guard let dateIn = dateFormatter.date(from: timeIn),
              let dateOut = dateFormatter.date(from: timeOut) else {
            return nil
        }
        let timeDifference = dateOut.timeIntervalSince(dateIn)
        let totalHours = timeDifference / 3600 // 3600 seconds in an hour
        return totalHours
    }
    //---code added on 20-May-2024, ends
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(month_number:Int, year:Int){
        loaderStart()
//        let url = "\(BASE_URL)timesheet/log/monthly/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(month_number)/\(year)"
        let url = "\(BASE_URL)timesheet/log/monthly/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(String(describing: SubordinateMyAttendanceLogViewController.slno!))/\(month_number)/\(year)"
        print("SubMnLog-=>",url)
        
        //        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                self.label_date.text = "\(swiftyJsonVar["month_name"].stringValue), \(swiftyJsonVar["year"].stringValue)"
                
                
                /*if let resData = swiftyJsonVar["day_wise_logs"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }*/
                //---added on 20-May-2024, code starts
                //---added on 24-April-2024, code starts
                if let dayWiseLogs = swiftyJsonVar["day_wise_logs"].array {
                     // Filter logs up to the current date
                     let filteredLogs = dayWiseLogs.prefix(while: { log in
                         if let dateString = log["date"].string {
                             let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "dd-MMM-yyyy"
                             if let logDate = dateFormatter.date(from: dateString), logDate <= Date() {
                                 return true
                             }
                         }
                         return false
                     })

                     // Count occurrences of "Holiday" and "Week Off"
                    let holidayCount = filteredLogs.filter {
                        $0["attendance_status"].stringValue == "Holiday"
                    }.count
                     let weekOffCount = filteredLogs.filter { $0["attendance_status"].stringValue == "Week Off" }.count
                     let leaveCount = filteredLogs.filter { $0["attendance_status"].stringValue == "Leave" }.count
                    
                     self.TotalHoliday = holidayCount
                     self.TotalLeave = leaveCount

                     print("Holiday count: \(holidayCount)")
                     print("Week Off count: \(weekOffCount)")
                    
                    // Total count of days up to current date
                     let totalDaysCount = filteredLogs.count
                     print("Total days count: \(totalDaysCount)")
                    self.TotalOfficeWorkingDaysTillDate = (totalDaysCount - (holidayCount+weekOffCount))
                    
                    
                    // Count occurrences of time_in greater than 10:00AM
                    let lateTimeInCount = filteredLogs.filter {
                        let timeIn = $0["time_in"].stringValue
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "h:mma"
                        if let date = timeFormatter.date(from: timeIn), date > timeFormatter.date(from: "10:00AM")! {
                            return true
                        }
                        return false
                    }.count
                    self.TotalLate = lateTimeInCount
                 }
                //---added on 24-April-2024, code ends
                
                var totalPresent = 0
                if let totalPresentCount = swiftyJsonVar["day_wise_logs"].array?.filter({$0["attendance_status"].stringValue == "Present"}).count{
                    totalPresent = totalPresentCount
                }else{
                    totalPresent = 0
                }
                
                print("Total Present-=> \(String(describing: totalPresent))")
                self.label_total_present_count.text = "Total Present: \(totalPresent)"
                self.TotalOfficePresent = totalPresent
                
                guard let totalAbsentCount = swiftyJsonVar["day_wise_logs"].array?.filter({$0["attendance_status"].stringValue == "Absent"}).count else{
                    self.TotalAbsent = 0
                    return
                }
                self.TotalAbsent = totalAbsentCount
                
                if let resData = swiftyJsonVar["day_wise_logs"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                    
                    //---added on 27-Mar-2024, code starts
                    var totalHoursTillNow = 0.00
                    for log in self.arrRes {
                        if let timeIn = log["time_in"] as? String ?? nil,
                           let timeOut = log["time_out"] as? String ?? nil{
                            if let totalHours = self.calculateTotalHours(timeIn: timeIn, timeOut: timeOut) {
                                totalHoursTillNow = totalHoursTillNow + totalHours
                                print("Date: \(log["date"] as? String ?? ""), Total Hours: \(totalHours)")
                            } else {
                                print("Invalid time format for date: \(log["date"] as? String ?? "")")
                            }
                        }
                        
                    }
                    let formattedTotalHoursUptpTwoDecimalNumber = String(format: "%.2f", totalHoursTillNow)
                    self.label_total_hours.text = "Total Hours: \(formattedTotalHoursUptpTwoDecimalNumber)"
                    print("Final Hours-=> \(formattedTotalHoursUptpTwoDecimalNumber)")
                    //---added on 27-Mar-2024, code ends
                }
                //---added on 20-May-2024, code ends
                if self.arrRes.count>0 {
                    self.tableviewSubordinateMyAttendanceLog.reloadData()
                }else{
                    self.tableviewSubordinateMyAttendanceLog.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewSubordinateMyAttendanceLog.bounds.size.width, height: self.tableviewSubordinateMyAttendanceLog.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.tableviewSubordinateMyAttendanceLog.backgroundView  = noDataLabel
                    self.tableviewSubordinateMyAttendanceLog.separatorStyle  = .none
                    
                }
            }
            
        }
    }
    //--------function to show log details using Alamofire and Json Swifty code ends------------
    
    
    //==============////--Attendance Details, code starts(added on 31-Mar-2024)--/////================
    @IBOutlet var viewAttendanceDetailsPopup: UIView!
    @IBOutlet var viewAttendanceDetailsChild: UIView!
    
    @IBOutlet weak var viewAttendanceDetailsClosePopup: LottieAnimationView!
    
    @IBOutlet weak var viewAttendanceDetailsLabelTotalPresent: UILabel!
    @IBOutlet weak var viewAttendanceDetailsLabelTotalOfficeWorkingDaysTillDate: UILabel!
    @IBOutlet weak var viewAttendanceDetailsLabelLate: UILabel!
    @IBOutlet weak var viewAttendanceDetailsLabelAbsent: UILabel!
    @IBOutlet weak var viewAttendanceDetailLabelHoliday: UILabel!
    @IBOutlet weak var viewAttendanceDetailsLeave: UILabel!
    
    
    func openAttendanceDetailsPopup(){
        blurEffect()
        self.view.addSubview(viewAttendanceDetailsPopup)
//        ScrollView.isScrollEnabled = false
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        let initialYPosition = self.view.bounds.height // Initial position below the screen
           
           // Set initial position and scale
           viewAttendanceDetailsPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3).concatenating(CGAffineTransform(translationX: 0, y: initialYPosition))
//        viewAttendanceDetailsPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
//        viewAttendanceDetailsPopup.center = self.view.center
        viewAttendanceDetailsPopup.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height - ((viewAttendanceDetailsPopup.bounds.height / 2)+20))
        viewAttendanceDetailsPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewAttendanceDetailsPopup.alpha = 0
        viewAttendanceDetailsPopup.sizeToFit()
       
        
//        viewAttendanceDetailsClosePopup.layer.cornerRadius = viewAttendanceDetailsClosePopup.frame.width / 2
//        viewAttendanceDetailsClosePopup.layer.masksToBounds = true
        
        viewAttendanceDetailsClosePopup.contentMode = .scaleAspectFit
        viewAttendanceDetailsClosePopup.loopMode = .loop
        viewAttendanceDetailsClosePopup.animationSpeed = 0.8
        viewAttendanceDetailsClosePopup.transform = CGAffineTransform(scaleX: 1, y: -1)
        viewAttendanceDetailsClosePopup.play()
        
        let tapGestureRecognizerSwipeDown = UITapGestureRecognizer(target: self, action: #selector(swipeDown(tapGestureRecognizer: )))
        viewAttendanceDetailsClosePopup.isUserInteractionEnabled = true
        viewAttendanceDetailsClosePopup.addGestureRecognizer(tapGestureRecognizerSwipeDown)
        
        /*UIView.animate(withDuration: 0.3){
            self.viewAttendanceDetailsPopup.alpha = 1
            self.viewAttendanceDetailsPopup.transform = CGAffineTransform.identity
        }*/
        
        //---set childview corner radius, code starts
        self.viewAttendanceDetailsChild.clipsToBounds = true
        self.viewAttendanceDetailsChild.layer.cornerRadius = 10
//        self.viewAttendanceDetailsChild.backgroundColor = UIColor(hexFromString: "CBCBCB")
        self.viewAttendanceDetailsChild.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        //---set childview corner radius, code ends
        
        /*guard let TotalOfficeWorkingDaysTillDate = TotalOfficeWorkingDaysTillDate?.hashValue else{
            self.viewAttendanceDetailsLabelTotalOfficeWorkingDaysTillDate.text = "0"
            return
        }*/
        self.viewAttendanceDetailsLabelTotalOfficeWorkingDaysTillDate.text = String(describing: TotalOfficeWorkingDaysTillDate)
        self.viewAttendanceDetailsLabelTotalPresent.text = String(describing: TotalOfficePresent)
        self.viewAttendanceDetailsLabelAbsent.text = String(describing: TotalAbsent)
        self.viewAttendanceDetailsLabelLate.text = String(describing: TotalLate)
        self.viewAttendanceDetailLabelHoliday.text = String(describing: TotalHoliday)
        self.viewAttendanceDetailsLeave.text = String(describing: TotalLeave)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut], animations: {
//            self.viewAttendanceDetailsPopup.transform = .identity
            self.viewAttendanceDetailsPopup.alpha = 1
            self.viewAttendanceDetailsPopup.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func cancelAttendanceDetailsPopup(){
        let initialYPosition = self.view.bounds.height // Initial position below the screen
           
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut], animations: {
//            self.viewAttendanceDetailsPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            // Set initial position and scale
            self.viewAttendanceDetailsPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3).concatenating(CGAffineTransform(translationX: 0, y: initialYPosition))
            
            self.viewAttendanceDetailsPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewAttendanceDetailsPopup.removeFromSuperview();
            self.canelBlurEffect()
//            self.ScrollView.isScrollEnabled = true
        }
    }
    @objc func swipeDown(tapGestureRecognizer: UITapGestureRecognizer){
        cancelAttendanceDetailsPopup()
    }
    
    //==============////--Attendance Details, code ends(added on 31-Mar-2024)--/////================
    
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
