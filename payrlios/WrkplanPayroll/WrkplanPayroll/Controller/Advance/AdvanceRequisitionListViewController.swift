//
//  AdvanceRequisitionListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 15/06/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class AdvanceRequisitionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AdvanceRequisitionListTableViewCellDelegate {
    
    
    @IBOutlet weak var BtnNew: UIButton!
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var TableViewRequisitionList: UITableView!
    @IBOutlet weak var LabelCustomButtonSubordinateAdvanceRequisitionList: UILabel!
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    static var requisition_no: String!, description: String!, requisition_status: String!, supervisor_remark: String!, EmployeeType: String!
    static var requisition_amount: Double!, approved_requisition_amount: Double!
    static var new_create_yn: Bool = false
    
    static var approved_date: String!, approved_by_name: String!, requisition_date: String!, employee_name: String!, requisition_type: String!
    static var requisition_id: Int!, supervisor1_id: Int!, supervisor2_id: Int!, employee_id: Int!, approved_by_id: Int!, reason: Int!, return_period_in_months: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.TableViewRequisitionList.delegate = self
        self.TableViewRequisitionList.dataSource = self
        
        loadData()
        
        
        //Subordinate
        let tapGestureRecognizerSubordinateAdvanceRequisitionListView = UITapGestureRecognizer(target: self, action: #selector(SubordinateView(tapGestureRecognizer:)))
        LabelCustomButtonSubordinateAdvanceRequisitionList.isUserInteractionEnabled = true
        LabelCustomButtonSubordinateAdvanceRequisitionList.addGestureRecognizer(tapGestureRecognizerSubordinateAdvanceRequisitionListView)
    }
    
    //---Subordinate
    @objc func SubordinateView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "subordinateadvance", sender: nil)
    }
    
    @IBAction func BtnOnClick(_ sender: UIButton) {
        switch sender {
        case BtnNew:
            AdvanceRequisitionListViewController.new_create_yn = true
            AdvanceRequisitionListViewController.requisition_status = ""
            AdvanceRequisitionListViewController.EmployeeType = "Employee"
            self.performSegue(withIdentifier: "advancerequisition", sender: nil)
            break
        case BtnBack:
            self.performSegue(withIdentifier: "home", sender: nil)
            break
        default:
            break
        }
    }
    
    //----------tableview code starts------------
    //    var rowIndex: Int! // --for instant delete delaring the variable
    func AdvanceRequisitionListTableViewCellRemoveDidTapAddOrView(_ sender: AdvanceRequisitionListTableViewCell) {
        guard let tappedIndexPath = TableViewRequisitionList.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        let body = "Do you really want to delete this record \(rowData["requisition_no"] as! String)?"
        let  requisition_id = rowData["requisition_id"] as? Int
        AdvanceRequisitionListViewController.requisition_id = rowData["requisition_id"] as? Int
        print("Selected-=>",requisition_id!)
        print("Selected")
        openDeletePopup(body: body)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdvanceRequisitionListTableViewCell
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
        
        cell.label_od_no.text = dict["requisition_no"] as? String
        cell.label_od_date.text = dict["requisition_date"] as? String
        cell.label_amount.text = String(describing:dict["requisition_amount"] as! Double)
        cell.label_od_status.text = dict["requisition_status"] as? String
        /*cell.label_timeout.text = dict["time_out"] as? String
         cell.label_status.text = dict["attendance_status"] as? String
         cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)*/
        if dict["requisition_status"] as? String == "Saved"{
            cell.image_view_delete.isHidden = false
        }else{
            cell.image_view_delete.isHidden = true
        }
        
        if dict["requisition_status"] as? String == "Approved"{
            cell.label_od_status.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["requisition_status"] as? String == "Canceled"{
            cell.label_od_status.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["requisition_status"] as? String == "Returned"{
            cell.label_od_status.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["requisition_status"] as? String == "Submitted"{
            cell.label_od_status.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["requisition_status"] as? String == "Saved"{
            cell.label_od_status.textColor = UIColor(hexFromString: "2196ed")
        }
        return cell
        
    }
    
    //---------onClick tableview code starts----------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AdvanceRequisitionListViewController.new_create_yn = false
        let row=arrRes[indexPath.row]
        print(row)
        print("tap is working")
        
        AdvanceRequisitionListViewController.requisition_no = row["requisition_no"] as? String
        AdvanceRequisitionListViewController.requisition_amount = row["requisition_amount"]?.doubleValue
        AdvanceRequisitionListViewController.description = row["description"] as? String
        AdvanceRequisitionListViewController.approved_requisition_amount = row["approved_requisition_amount"]?.doubleValue
        AdvanceRequisitionListViewController.supervisor_remark = row["supervisor_remark"] as? String
        AdvanceRequisitionListViewController.requisition_status = row["requisition_status"] as? String
        
        //            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
        //            print("test-=>",row["od_request_id"]?.stringValue)
        AdvanceRequisitionListViewController.EmployeeType = "Employee"
        
        //--added on 18th June
        AdvanceRequisitionListViewController.approved_date = row["approved_date"] as? String
        AdvanceRequisitionListViewController.approved_by_name = row["approved_by_name"] as? String
        AdvanceRequisitionListViewController.requisition_date = row["requisition_date"] as? String
        AdvanceRequisitionListViewController.employee_name = row["employee_name"] as? String
        AdvanceRequisitionListViewController.requisition_type = row["requisition_type"] as? String
        AdvanceRequisitionListViewController.requisition_id = row["requisition_id"]?.intValue
        AdvanceRequisitionListViewController.supervisor1_id = row["supervisor1_id"]?.intValue
        AdvanceRequisitionListViewController.supervisor2_id = row["supervisor2_id"]?.intValue
        AdvanceRequisitionListViewController.approved_by_id = row["approved_by_id"]?.intValue
        AdvanceRequisitionListViewController.reason = row["reason"]?.intValue
        AdvanceRequisitionListViewController.return_period_in_months = row["return_period_in_months"]?.intValue
        self.performSegue(withIdentifier: "advancerequisition", sender: self)
    }
    //---------onClick tableview code ends----------
    
    /*  func OutDoorDutyListTableViewCellAddOrRemoveDidTapAddOrView(_ sender: OutDoorDutyListTableViewCell) {
     guard let tappedIndexPath = TableViewOutdoorList.indexPath(for: sender) else {return}
     let rowData = arrRes[tappedIndexPath.row]
     
     let od_request_id = rowData["od_request_id"]?.stringValue
     
     delete_data(od_request_id: od_request_id!)
     
     self.arrRes.remove(at: tappedIndexPath.row)
     TableViewOutdoorList.reloadData()
     
     self.delete_data(od_request_id: od_request_id!)
     
     self.arrRes.remove(at: tappedIndexPath.row)
     self.TableViewOutdoorList.reloadData()
     
     
     }*/
    //----------tableview code ends------------
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        
        let url = "\(BASE_URL)advance-requisition/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/Employee/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("AdvanceReqlisturl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                if let resData = swiftyJsonVar["requisition_list"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.TableViewRequisitionList.reloadData()
                }else{
                    self.TableViewRequisitionList.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewRequisitionList.bounds.size.width, height: self.TableViewRequisitionList.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.TableViewRequisitionList.backgroundView  = noDataLabel
                    self.TableViewRequisitionList.separatorStyle  = .none
                    
                }
            }
            
        }
    }
    //--------function to show log details using Alamofire and Json Swifty code ends------------
    
    
    //===============FormDelete Popup code starts(added on 24th june)===================
    
    
    @IBOutlet weak var btnPopupOk: UIButton!
    @IBOutlet weak var btnPopupCancel: UIButton!
    @IBAction func btnPopupOk(_ sender: Any) {
        closeDeletePopup()
        
        deleteApi(requisition_id: AdvanceRequisitionListViewController.requisition_id!)
    }
    
    @IBAction func btn_cancel(_ sender: Any) {
        closeDeletePopup()
    }
    
    @IBOutlet weak var stackViewPopupButton: UIStackView!
    @IBOutlet var viewDetails: UIView!
    @IBOutlet weak var LabelBody: UILabel!
    func openDeletePopup(body: String?){
        blurEffect()
        self.view.addSubview(viewDetails)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewDetails.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewDetails.center = self.view.center
        viewDetails.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewDetails.alpha = 0
        viewDetails.sizeToFit()
        
        stackViewPopupButton.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        //        view_custom_btn_punchout.addBorder(side: .top, color: UIColor(hexFromString: "4f4f4f"), width: 1)
        btnPopupOk.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        
        UIView.animate(withDuration: 0.3){
            self.viewDetails.alpha = 1
            self.viewDetails.transform = CGAffineTransform.identity
        }
        
        self.LabelBody.text = body!
        //        self.confidencelabel.text = confidence!
        
        
    }
    func closeDeletePopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewDetails.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewDetails.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewDetails.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //===============FormDelete Popup code ends===================
    
    
    //=========Code to delete using Alamofire and Swiftyjson, starts=========
    func deleteApi(requisition_id: Int){
        let url = BASE_URL + "advance-requisition/delete/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(requisition_id)"
        print("url->",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            if((responseData.value ?? "") != nil){
                //                       self.dismiss(animated: true, completion: nil)  //----dismissing the loader
                let swiftyJsonVar=JSON(responseData.value!)
                print(swiftyJsonVar)
                if(swiftyJsonVar["response"]["status"].stringValue == "true"){
                    
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageColor = .white
                    self.view.makeToast(swiftyJsonVar["response"]["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                    self.loaderEnd()
                    self.loadData()
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
    //=========Code to delete using Alamofire and Swiftyjson, ends=========
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
