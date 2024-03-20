//
//  LeaveViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 25/11/20.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

struct YearDetails {
    var calender_year:String!
    var financial_year_code:String!
}


class LeaveViewController: UIViewController {
    
    let dropDown = DropDown()
    var arres = [String:AnyObject]()
    var year_details = [YearDetails]()
    
    
    @IBOutlet weak var label_casual_leave_hours: UILabel!
    @IBOutlet weak var label_casual_leave: UILabel!
    @IBOutlet weak var label_earned_leave: UILabel!
    @IBOutlet weak var label_sick_leave: UILabel!
    @IBOutlet weak var label_comp_off: UILabel!
    @IBOutlet weak var label_maternal_leave: UILabel!
    @IBOutlet weak var label_paternal_leave: UILabel!
    @IBOutlet weak var designable_btn_leave_appltn: DesignableButton!
    @IBOutlet weak var designable_btn_subordinate_leave_appltn: DesignableButton!
    @IBOutlet weak var StackViewButtons: UIStackView!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color

        // Do any additional setup after loading the view.
        //-----code to add button border, starts------
        StackViewButtons.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        designable_btn_subordinate_leave_appltn.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        //-----code to add button border, ends------
        
//        print("hometesting-=>",swiftyJsonvar1["employee"]["father_husband_name"].stringValue)
        self.get_Year_details()
        
    }
    @IBAction func designable_btn_leave_appltn(_ sender: Any) {
        self.performSegue(withIdentifier: "myleaveappltn", sender: self)
    }
 
    
    @IBAction func designable_btn_subordinate_leave_appltn(_ sender: Any) {
        self.performSegue(withIdentifier: "subleaveappltn", sender: self)
    }
    @IBAction func btn_home(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    @IBAction func btn_dropdown_year(_ sender: UIButton) {
//        dropDown.dataSource = ["Tomato soup", "Mini burgers", "Onion rings", "Baked potato", "Salad"]//4
        dropDown.dataSource = year
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("year-=>",item)
                self!.loadData(year: self!.year_details[index].financial_year_code)
            }
          }
    
    
    
    //--------function to get year using Alamofire and Json Swifty------------
    var year = [String]()
        func get_Year_details(){
            loaderStart()
            if !year_details.isEmpty{
                year_details.removeAll(keepingCapacity: true)
            }
            if !year.isEmpty {
                year.removeAll(keepingCapacity: true)
            }
            let url = "\(BASE_URL)finyear/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)"
            print("yearyrl-=>",url)
            AF.request(url).responseJSON{ (responseData) -> Void in
                self.loaderEnd()
                if((responseData.value) != nil){
                    let swiftyJsonVar=JSON(responseData.value!)
                    print("Calendar description: \(swiftyJsonVar)")
                    
                    for i in 0..<swiftyJsonVar["fin_years"].count{
//                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
//                        print("Calendar-=>",self.year)
                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
                        
                        
                    }
                    for(key,value) in swiftyJsonVar["fin_years"]{
                        var k = YearDetails()
                        k.calender_year = value["calender_year"].stringValue
                        k.financial_year_code = value["financial_year_code"].stringValue
                        self.year_details.append(k)
                    }

                    
                }
                
            }
        }
        //--------function to get year using Alamofire and Json Swifty code ends------------
    
    //--------function to loadData using Alamofire and Json Swifty code starts----------
    func loadData(year:String?){
        loaderStart()
        let url = "\(BASE_URL)leave/balance/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(year!)"
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
                self.loaderEnd()
            print("responseData-=>",responseData)
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                    print("Year description: \(swiftyJsonVar)")
            
                self.label_casual_leave.text = "\(swiftyJsonVar["leave_balance"]["casual_leave"].stringValue) H"
                self.label_casual_leave_hours.text = "  (0 Day(s))"
                self.label_earned_leave.text = swiftyJsonVar["leave_balance"]["earn_leave"].stringValue
                self.label_sick_leave.text = swiftyJsonVar["leave_balance"]["sick_leave"].stringValue
                self.label_maternal_leave.text = swiftyJsonVar["leave_balance"]["maternal_leave"].stringValue
                self.label_paternal_leave.text = swiftyJsonVar["leave_balance"]["paternal_leave"].stringValue
                self.label_comp_off.text = swiftyJsonVar["leave_balance"]["comp_off"].stringValue
                
                
                if let casualLeaveString = swiftyJsonVar["leave_balance"]["casual_leave"].string {
                    if let casualLeaveDouble = Double(casualLeaveString) {
                        let dividedResult = casualLeaveDouble / 8.0
                        let resultString = String(format: "%.2f", dividedResult)
                        self.label_casual_leave_hours.text = "  (\(resultString) Day(s))"
                    } else {
                        // Handle the case where the string couldn't be converted to a double
                        print("Error: Unable to convert earn_leave string to double")
                    }
                } else {
                    // Handle the case where earn_leave string is nil
                    print("Error: earn_leave string is nil")
                }
                
                    
                }

                
            }
            
        }
    //--------function to loadData using Alamofire and Json Swifty code ends----------

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
