//
//  SubordinateOutdoorDutyRequestListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 08/03/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubordinateOutdoorDutyRequestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    var arrRes = [[String:AnyObject]]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableviewSubordinateDutyRequestList: UITableView!
    @IBOutlet weak var customViewTableView: UIView!
    @IBOutlet weak var customViewSearchBar: UIView!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    public static var od_request_id: String!, supervisor_employee_id: String!
    //---added on 14th April
    var filteredTableData = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.tableviewSubordinateDutyRequestList.delegate = self
        self.tableviewSubordinateDutyRequestList.dataSource = self
        self.searchBar.delegate = self
        
        tableviewSubordinateDutyRequestList.backgroundColor = UIColor(hexFromString: "ffffff")
        /*self.customViewTableView.cornerRadius = 8
        self.customViewTableView.borderColor = UIColor(hexFromString: "DCDCDC")
        self.customViewTableView.borderWidth = 1.0*/
        
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        //        searchBar.searchTextField.borderColor = UIColor.lightGray
        //        searchBar.searchTextField.borderWidth = 1
        //        searchBar.searchTextField.cornerRadius = 10
        searchBar.layer.borderWidth = 10
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        
        loadData()
    }
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
    }
    
    //----------tableview code starts------------
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
        
        self.tableviewSubordinateDutyRequestList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""

        filteredTableData = arrRes

        searchBar.endEditing(true)

        self.tableviewSubordinateDutyRequestList.reloadData()
    }
    
    //---added on 14th April, code ends
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateOutdoorDutyRequestListTableViewCell
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
        
        cell.label_od_duty_no.text = dict["od_request_no"] as? String
        if (dict["total_days"]?.doubleValue)! > 0 {
            cell.label_od_date.text = "\(String(describing: dict["from_date"] as! String)) to \(String(describing: dict["to_date"] as! String))"
        }else{
            cell.label_od_date.text = dict["from_date"] as? String
        }
        
        cell.label_day_count.text = "\(String(describing:dict["total_days"] as! Int))Day(s)"
        cell.label_od_status.text = dict["od_status"] as? String
        cell.label_subordinate_name.text = dict["employee_name"] as? String
        /*cell.label_timeout.text = dict["time_out"] as? String
         cell.label_status.text = dict["attendance_status"] as? String
         cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)*/
        
        if dict["od_status"] as? String == "Approved"{
            cell.label_od_status.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["od_status"] as? String == "Canceled"{
            cell.label_od_status.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["od_status"] as? String == "Return"{
            cell.label_od_status.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["od_status"] as? String == "Submit"{
            cell.label_od_status.textColor = UIColor(hexFromString: "fe52ce")
        }
        return cell
        
    }
    //----------tableview code ends------------
    //---------onClick tableview code starts----------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var row = filteredTableData[indexPath.row]
        print(row)
        print("tap is working")
        
        SubordinateOutdoorDutyRequestListViewController.od_request_id = row["od_request_id"]?.stringValue
        SubordinateOutdoorDutyRequestListViewController.supervisor_employee_id = row["employee_id"]?.stringValue
        
        //            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
        //            print("test-=>",row["od_request_id"]?.stringValue)
        self.performSegue(withIdentifier: "subordinateoutdoordutyrequest", sender: self)
    }
    //---------onClick tableview code ends----------
    
    
    //--------function to show details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        
        let url = "\(BASE_URL)od/request/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/2/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("SubordinateOutDoorDutylisturl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                if let resData = swiftyJsonVar["request_list"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                    self.filteredTableData = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.tableviewSubordinateDutyRequestList.reloadData()
                }else{
                    self.tableviewSubordinateDutyRequestList.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewSubordinateDutyRequestList.bounds.size.width, height: self.tableviewSubordinateDutyRequestList.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.tableviewSubordinateDutyRequestList.backgroundView  = noDataLabel
                    self.tableviewSubordinateDutyRequestList.separatorStyle  = .none
                    self.searchBar.isHidden = true
                    
                }
            }
            
        }
    }
    //--------function to log details using Alamofire and Json Swifty code ends------------
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
