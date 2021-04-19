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

class SubordinateMyAttendanceLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableviewSubordinateMyAttendanceLog: UITableView!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_prev: UIButton!
    
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var month_number:Int?
    var year:Int?
    
    let dropDown = DropDown()
    var name = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
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
//            self!.loadData(year: item)
            
            //--adeded on 24th feb, starts
            self!.btn_next.isHidden = false
            self!.btn_prev.isHidden = false
            self!.label_date.isHidden = false
            
            self!.loadData(month_number: self!.month_number!, year: self!.year!)
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
            
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
        else{
            cell.label_status.isHidden = true
            cell.label_status.backgroundColor = UIColor(hexFromString: "#ffffff")
            cell.label_status.cornerRadius = 5
        }
        return cell
        
    }
    //----------tableview code ends------------
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(month_number:Int, year:Int){
           loaderStart()
        let url = "\(BASE_URL)timesheet/log/monthly/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(month_number)/\(year)"
//        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                self.label_date.text = "\(swiftyJsonVar["month_name"].stringValue), \(swiftyJsonVar["year"].stringValue)"
                
                
                   if let resData = swiftyJsonVar["day_wise_logs"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.tableviewSubordinateMyAttendanceLog.reloadData()
                   }else{
                       self.tableviewSubordinateMyAttendanceLog.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewSubordinateMyAttendanceLog.bounds.size.width, height: self.tableviewSubordinateMyAttendanceLog.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.tableviewSubordinateMyAttendanceLog.backgroundView  = noDataLabel
                       self.tableviewSubordinateMyAttendanceLog.separatorStyle  = .none
                       
                   }
               }
               
           }
       }
       //--------function to show log details using Alamofire and Json Swifty code ends------------
    
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
