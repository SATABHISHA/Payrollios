//
//  ReportsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Toast_Swift

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReportsTableViewCellDelegate {
   

    @IBOutlet weak var TanleViewReports: UITableView!
    var arrRes = [[String:Any]]()
    let dropDown = DropDown()
    var year_details = [YearDetails]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    static var report_html: String!, year: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color

        // Do any additional setup after loading the view.
        TanleViewReports.delegate = self
        TanleViewReports.dataSource = self
        TanleViewReports.backgroundColor = UIColor(hexFromString: "ffffff")
        
        loadReportsData()
        
        
        //------LeavePopup Ok
        let tapGestureRecognizerLeavePopupOk = UITapGestureRecognizer(target: self, action: #selector(LeavePopupOk(tapGestureRecognizer:)))
        custom_btn_ok_leave_popup.isUserInteractionEnabled = true
        custom_btn_ok_leave_popup.addGestureRecognizer(tapGestureRecognizerLeavePopupOk)
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    
    
    func loadReportsData(){
        let dict:[[String:Any]] = [["id":0,"title":"PF Deduction"]]
        self.arrRes = dict
    }
    
    //------tableview code, starts-----
    func ReportsItemTableViewCellDidTapView(_ sender: ReportsTableViewCell) {
        guard let tappedIndexPath = TanleViewReports.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        
        openReportsPopup()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReportsTableViewCell
        
        cell.delegate = self
        
        let dict = arrRes[indexPath.row]
        cell.LabelTitle.text = dict["title"] as? String
        
        return cell
        
    }
    //------tableview code, ends-----
    
    
    //============================-Form Leave Balance dialog, code starts============================
    @IBOutlet var viewReports: UIView!
    
   
    @IBOutlet weak var btn_select_year: UIButton!
    @IBOutlet weak var custom_btn_ok_leave_popup: UIView!
    
    let dropDownSelectYear = DropDown()
    
   
    @IBAction func btn_select_year(_ sender: UIButton) {
        dropDownSelectYear.dataSource = year
        dropDownSelectYear.anchorView = sender //5
        dropDownSelectYear.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDownSelectYear.show() //7
        dropDownSelectYear.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("year-=>",item)
            ReportsViewController.year = self!.year_details[index].financial_year_code
//                self!.loadPopupLeaveData(year: self!.year_details[index].financial_year_code)
            }
    }
    func openReportsPopup(){
        self.get_Year_details()
        blurEffect()
        self.view.addSubview(viewReports)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        viewReports.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewReports.center = self.view.center
        viewReports.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewReports.alpha = 0
        viewReports.sizeToFit()
        

        custom_btn_ok_leave_popup.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.5)
      /*  stackViewButtonborder.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        view_custom_btn_punchout.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)*/
        
        
        
        
        UIView.animate(withDuration: 0.3){
            self.viewReports.alpha = 1
            self.viewReports.transform = CGAffineTransform.identity
        }
        
    }
    
    func cancelLeaveBalancePopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewReports.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewReports.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewReports.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    //--------function to get year using Alamofire and Json Swifty------------
    var year = [String]()
        func get_Year_details(){
            loaderStart()
            if year.count > 0{
                year.removeAll()
            }
            if !year_details.isEmpty{
                year_details.removeAll(keepingCapacity: true)
            }
            let url = "\(BASE_URL)finyear/list/reports/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1"
            AF.request(url).responseJSON{ (responseData) -> Void in
                self.loaderEnd()
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
    
    //--------function to load popup leave data using Alamofire and Json Swifty code starts----------
    func loadHtmlStringData(year:String?){
//        loaderStart()
        let url = "\(BASE_URL)reports/pf-deduction/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(year!)"
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
//                self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                    print("Year description: \(swiftyJsonVar)")
                if(swiftyJsonVar["response"]["status"].stringValue == "true"){
                    ReportsViewController.report_html = swiftyJsonVar["report_html"].stringValue
                    self.performSegue(withIdentifier: "pdf", sender: nil)
                }else{
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageColor = .white
                    self.view.makeToast(swiftyJsonVar["response"]["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                    self.loaderEnd()
                }
                    
                }

                
            }
            
        }
    //---Leave PopupOk
    @objc func LeavePopupOk(tapGestureRecognizer: UITapGestureRecognizer){
        cancelLeaveBalancePopup()
        loadHtmlStringData(year: ReportsViewController.year)
        
    }
    //--------function to load popup leave data using Alamofire and Json Swifty code ends----------
    //============================Form Leave Balance dialog, code ends============================
    
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
