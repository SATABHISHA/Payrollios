//
//  SubordinateOdDutyLogListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubordinateOdDutyLogListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SubordinateOdDutyLogListTableViewCellDelegate, UISearchBarDelegate {
    
    
    
    
    
    @IBOutlet weak var tableViewSubordinateOdDutyLogList: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    static var Log_employee_id: Int!
    static var Log_task_employee_name: String!
    static var Log_task_date: String!
    static var log_task_status: Int! //-----added by Satabhisha(log_task_status is used to identify supervisor and subordinate for task detail section)
    static var od_request_id: Int!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    var arrRes = [[String:AnyObject]]()
    //---added on 14th April
    var filteredTableData = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor()
        
        self.tableViewSubordinateOdDutyLogList.delegate = self
        self.tableViewSubordinateOdDutyLogList.dataSource = self
        self.searchBar.delegate = self
        
        tableViewSubordinateOdDutyLogList.backgroundColor = UIColor(hexFromString: "ffffff")
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        //        searchBar.searchTextField.borderColor = UIColor.lightGray
        //        searchBar.searchTextField.borderWidth = 1
        //        searchBar.searchTextField.cornerRadius = 10
        searchBar.layer.borderWidth = 10
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        self.tableViewSubordinateOdDutyLogList.backgroundColor = UIColor(hexFromString: "ffffff")
        
        // Do any additional setup after loading the view.
        loadData()
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "odloglist", sender: nil)
    }
    
    //------tableview code starts-----
    //---added on 14th April, code starts
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredTableData = searchText.isEmpty ? arrRes : arrRes.filter({(object) -> Bool in
            guard let employee_name = object["employee_name"] as? String else {return false}
            return employee_name.lowercased().contains(searchText.lowercased())
        })
        
        self.tableViewSubordinateOdDutyLogList.reloadData()
    }
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //---added on 13th April, code ends
    func SubordinateOdDutyLogListTableViewCellDidTapView(_ sender: SubordinateOdDutyLogListTableViewCell) {
        print("tapped")
        guard let tappedIndexPath = tableViewSubordinateOdDutyLogList.indexPath(for: sender) else {return}
        let rowData = filteredTableData[tappedIndexPath.row]
        
        SubordinateOdDutyLogListViewController.Log_employee_id = rowData["employee_id"] as? Int
        SubordinateOdDutyLogListViewController.Log_task_employee_name = rowData["employee_name"] as? String
        SubordinateOdDutyLogListViewController.Log_task_date = rowData["od_duty_log_date"] as? String
        SubordinateOdDutyLogListViewController.od_request_id = rowData["od_request_id"] as? Int
        SubordinateOdDutyLogListViewController.log_task_status = 0
        self.performSegue(withIdentifier: "subordinateodlogtask", sender: nil)
    }
    
    func SubordinateOdDutyLogListTableViewCellDidTapViewTimeLog(_ sender: SubordinateOdDutyLogListTableViewCell) {
        guard let tappedIndexPath = tableViewSubordinateOdDutyLogList.indexPath(for: sender) else {return}
        let rowData = filteredTableData[tappedIndexPath.row]
        
        SubordinateOdDutyLogListViewController.Log_employee_id = rowData["employee_id"] as? Int
        SubordinateOdDutyLogListViewController.Log_task_employee_name = rowData["employee_name"] as? String
        SubordinateOdDutyLogListViewController.Log_task_date = rowData["od_duty_log_date"] as? String
        SubordinateOdDutyLogListViewController.od_request_id = rowData["od_request_id"] as? Int
        SubordinateOdDutyLogListViewController.log_task_status = 0
        self.performSegue(withIdentifier: "odDutyTimeLog", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateOdDutyLogListTableViewCell
        //        rowIndex = indexPath.row
        
        cell.delegate = self
        
        let dict = filteredTableData[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        //        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        //        dateFormatterGet.dateFormat = "dd-MM-yyyy hh:mm:ss" //--for test version
        
        dateFormatterGet.dateFormat = "dd-MMM-yyyy" //--format changed in ios on 24th feb
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        //        let date = dateFormatterGet.date(from: (dict["date"] as? String)!)
        //                labelDate.text = eventData[i].date
        //        cell.label_date.text = dateFormatterPrint.string(from: date!)
        cell.LabelName.text = dict["employee_name"] as? String
        cell.LabelDate.text = dict["od_duty_log_date"] as? String
        cell.label_time_log.text = "View \n Time Log"
        
        
        return cell
    }
    //------tableview code ends-----
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        
        let url = "\(BASE_URL)od/log/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/2/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("odDutylisturl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                if let resData = swiftyJsonVar["items"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                    self.filteredTableData = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.tableViewSubordinateOdDutyLogList.reloadData()
                }else{
                    self.tableViewSubordinateOdDutyLogList.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewSubordinateOdDutyLogList.bounds.size.width, height: self.tableViewSubordinateOdDutyLogList.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.tableViewSubordinateOdDutyLogList.backgroundView  = noDataLabel
                    self.tableViewSubordinateOdDutyLogList.separatorStyle  = .none
                    self.searchBar.isHidden = true
                    
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
