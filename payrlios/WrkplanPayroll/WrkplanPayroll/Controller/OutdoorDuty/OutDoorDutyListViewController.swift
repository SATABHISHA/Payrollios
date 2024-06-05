//
//  OutDoorDutyListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 01/03/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class OutDoorDutyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OutDoorDutyListTableViewCellDelegate {
    
    
    @IBOutlet weak var label_custom_btn_subordinate_duty_rqst_list: DesignableButton!
    @IBOutlet weak var TableViewOutdoorList: UITableView!
    var arrRes = [[String:AnyObject]]()
    
    @IBOutlet weak var view_new_od_duty_request: UIButton!
    
    @IBOutlet weak var custom_subordibnate_btn_height_constraint: NSLayoutConstraint!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    static var new_create_yn: Bool = false
    static var supervisor_od_request_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change backgrounf statusbar color
        
        self.TableViewOutdoorList.delegate = self
        self.TableViewOutdoorList.dataSource = self
        
        //---added on 30-May-2024, code starts
        self.TableViewOutdoorList.clipsToBounds = true
        self.TableViewOutdoorList.layer.cornerRadius = 10

        self.TableViewOutdoorList.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.TableViewOutdoorList.borderWidth = 1
        self.TableViewOutdoorList.borderColor = UIColor(hexFromString: "CBCBCB")
        
        self.TableViewOutdoorList.layer.shadowColor = UIColor.gray.cgColor
        self.TableViewOutdoorList.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.TableViewOutdoorList.layer.shadowOpacity = 5
        self.TableViewOutdoorList.layer.shadowRadius = 8.0
        //---added on 30-May-2024, code ends
        
        
        //EmployeeInformation
        let tapGestureRecognizer_view_new_od_duty_request = UITapGestureRecognizer(target: self, action: #selector(view_new_od_duty_request(tapGestureRecognizer:)))
        view_new_od_duty_request.isUserInteractionEnabled = true
        view_new_od_duty_request.addGestureRecognizer(tapGestureRecognizer_view_new_od_duty_request)
        
        //Subordinate
        let tapGestureRecognizer_subordinate_duty_rqst_list = UITapGestureRecognizer(target: self, action: #selector(subordinate_duty_rqst_list(tapGestureRecognizer:)))
        label_custom_btn_subordinate_duty_rqst_list.isUserInteractionEnabled = true
        label_custom_btn_subordinate_duty_rqst_list.addGestureRecognizer(tapGestureRecognizer_subordinate_duty_rqst_list)
        
        // Do any additional setup after loading the view.
        //---added on 05-06-2024, code starts
        if swiftyJsonvar1["user"]["user_type"].stringValue == "Employee"{
            self.custom_subordibnate_btn_height_constraint.constant = 0
        }else if swiftyJsonvar1["user"]["user_type"].stringValue == "Supervisor"{
            self.custom_subordibnate_btn_height_constraint.constant = 50
        }
        //---added on 05-06-2024, code ends
        
        
        loadData()
    }
    //OdDutyRequest
    @objc func view_new_od_duty_request(tapGestureRecognizer: UITapGestureRecognizer){
        OutDoorDutyListViewController.new_create_yn = true
        self.performSegue(withIdentifier: "outdoordutyrequest", sender: nil)
    }
    
    //Subordinate
    @objc func subordinate_duty_rqst_list(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "subordinateodrqstlist", sender: nil)
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    //----------tableview code starts------------
    //    var rowIndex: Int! // --for instant delete delaring the variable
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OutDoorDutyListTableViewCell
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
        
        cell.label_od_no.text = dict["od_request_no"] as? String
        if (dict["total_days"]?.doubleValue)! > 0 {
            cell.label_od_date.text = "\(String(describing: dict["from_date"] as! String)) to \(String(describing: dict["to_date"] as! String))"
        }else{
            cell.label_od_date.text = dict["from_date"] as? String
        }
        
        cell.label_day_count.text = "\(String(describing:dict["total_days"] as! Int)) Day(s)"
        cell.label_od_status.text = dict["od_status"] as? String
        /*cell.label_timeout.text = dict["time_out"] as? String
         cell.label_status.text = dict["attendance_status"] as? String
         cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)*/
        if dict["od_status"] as? String == "Save"{
//            cell.custom_img_btn_delete.isHidden = false
            cell.custom_label_btn_delete.isHidden = false
            cell.custom_delimeter_for_delete.isHidden = false
            cell.custom_label_btn_delete.clipsToBounds = true
            cell.custom_label_btn_delete.cornerRadius = 5
        }else{
//            cell.custom_img_btn_delete.isHidden = true
            cell.custom_label_btn_delete.isHidden = true
            cell.custom_delimeter_for_delete.isHidden = true
        }
        
        if dict["od_status"] as? String == "Approved"{
            cell.label_od_status.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["od_status"] as? String == "Canceled"{
            cell.label_od_status.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["od_status"] as? String == "Return"{
            cell.label_od_status.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["od_status"] as? String == "Submit"{
            cell.label_od_status.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["od_status"] as? String == "Save"{
            cell.label_od_status.textColor = UIColor(hexFromString: "2196ed")
        }
        return cell
        
    }
    
    //---------onClick tableview code starts----------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        OutDoorDutyListViewController.new_create_yn = false
        var row=arrRes[indexPath.row]
        print(row)
        print("tap is working")
        
        OutDoorDutyListViewController.supervisor_od_request_id = row["od_request_id"]?.stringValue
        SubordinateOutdoorDutyRequestListViewController.supervisor_employee_id = row["employee_id"]?.stringValue
        
        //            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
        //            print("test-=>",row["od_request_id"]?.stringValue)
        self.performSegue(withIdentifier: "outdoordutyrequest", sender: self)
    }
    //---------onClick tableview code ends----------
    
    func OutDoorDutyListTableViewCellAddOrRemoveDidTapAddOrView(_ sender: OutDoorDutyListTableViewCell) {
        guard let tappedIndexPath = TableViewOutdoorList.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        
        let od_request_id = rowData["od_request_id"]?.stringValue
        
        self.delete_data(od_request_id: od_request_id!)
        
        self.arrRes.remove(at: tappedIndexPath.row)
        self.TableViewOutdoorList.reloadData()
        
        
    }
    //----------tableview code ends------------
    
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        
        let url = "\(BASE_URL)od/request/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("odDutylisturl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                if let resData = swiftyJsonVar["request_list"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.TableViewOutdoorList.reloadData()
                }else{
                    self.TableViewOutdoorList.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewOutdoorList.bounds.size.width, height: self.TableViewOutdoorList.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.TableViewOutdoorList.backgroundView  = noDataLabel
                    self.TableViewOutdoorList.separatorStyle  = .none
                    
                }
            }
            
        }
    }
    //--------function to show log details using Alamofire and Json Swifty code ends------------
    
    
    //---function to delete, code starts-----
    func delete_data(od_request_id: String){
        //        loaderStart()
        let url = "\(BASE_URL)od/request/delete/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(od_request_id)/"
        print("deleteapi-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            //               self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Response description: \(swiftyJsonVar)")
                
                
                
                //                   if let resData = swiftyJsonVar["request_list"].arrayObject{
                //                       self.arrRes = resData as! [[String:AnyObject]]
                //
                //                   }
                if swiftyJsonVar["response"]["status"] == "true"{
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageColor = .white
                    
                    // present the toast with the new style
                    self.view.makeToast(swiftyJsonVar["response"]["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                }
                
            }
            
        }
        
    }
    //---function to delete, code ends-----
    
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
