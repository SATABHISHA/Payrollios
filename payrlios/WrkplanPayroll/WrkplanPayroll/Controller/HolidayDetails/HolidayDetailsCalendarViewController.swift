//
//  HolidayDetailsCalendarViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/12/20.
//

import UIKit
import FSCalendar
import Alamofire
import SwiftyJSON

class HolidayDetailsCalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_holiday_name: UILabel!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        label_date.text = ""
        label_holiday_name.text = ""
        //------calender code starts--------
        calendar.headerHeight = 45.0
        calendar.weekdayHeight = 35.0
        calendar.rowHeight = 25.0
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 0.0, weight: .regular)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 18.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 22)
        calendar.scrollDirection = .horizontal
        calendar.appearance.todayColor = .purple
        //        calender.calendarHeaderView.backgroundColor = UIColorRGB(r: 75, g: 153.0, b: 224.0)
        calendar.calendarHeaderView.backgroundColor = UIColor(hexFromString: "ffffff")
        calendar.calendarWeekdayView.backgroundColor = UIColor(hexFromString: "ffffff")
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = UIColor(hexFromString: "898989")
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.borderRadius = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0
//        calender.appearance.separators = .interRows
        //-------calender code ends----------
        
        
    }
    
    //============Calender code starts===========
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "MM-dd-yyyy"
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    //===========Calender code ends============

    @IBAction func btn_home(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    //--------function to show holiday details using Alamofire and Json Swifty------------
       func loadData(){
           loaderStart()
        let url = "\(BASE_URL)holidays/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1"
//        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Holiday description: \(swiftyJsonVar)")
                   if let resData = swiftyJsonVar["holidays"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                if self.arrRes.count>0{
                    self.calendar.delegate = self
                    self.calendar.dataSource = self
                    self.calendar.reloadData()
                }
                  /* if self.arrRes.count>0 {
                       self.tableviewHolidayDetail.reloadData()
                   }else{
                       self.tableviewHolidayDetail.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewHolidayDetail.bounds.size.width, height: self.tableviewHolidayDetail.bounds.size.height))
                       noDataLabel.text          = "No holiday(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.tableviewHolidayDetail.backgroundView  = noDataLabel
                       self.tableviewHolidayDetail.separatorStyle  = .none
                       
                   }*/
               }
               
           }
       }
       //--------function to show holiday details using Alamofire and Json Swifty code ends------------
    
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
// MARK: - FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance
extension HolidayDetailsCalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.formatter.string(from: date)
        for i in  0..<arrRes.count{
            let dict = arrRes[i]
            
            if dict["from_date"] as? String == dateString{
                label_date.isHidden = false
                label_holiday_name.isHidden = false
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd/MM/yyyy"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                
                let date = dateFormatterGet.date(from: dict["from_date"] as! String)
//                labelDate.text = eventData[i].date
                label_date.text = dateFormatterPrint.string(from: date!)
                label_holiday_name.text = dict["holiday_name"] as? String
            }
        }
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        label_date.isHidden = true
        label_holiday_name.isHidden = true
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
        for i in  0..<arrRes.count{
            let dict = arrRes[i]
            
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
        for i in  0..<arrRes.count{
            let dict = arrRes[i]
            
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
    
}
