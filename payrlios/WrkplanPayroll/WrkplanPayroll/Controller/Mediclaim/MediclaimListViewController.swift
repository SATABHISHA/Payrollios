//
//  MediclaimListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 28/06/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class MediclaimListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MediclaimListTableViewCellDelegate {

    @IBOutlet weak var TableViewMediclaimList: UITableView!
    @IBOutlet weak var LabelCustomBtnSubordinateMediclaim: UILabel!
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    static var mediclaim_no: String!, mediclaim_status: String!, EmployeeType: String!
    static var mediclaim_amount: Double!, approved_mediclaim_amount: Double!, payment_amount: Double!
    static var new_create_yn: Bool = false
    
    static var  mediclaim_date: String!, employee_name: String!, mediclaim_type: String!
    static var mediclaim_id: Int!, employee_id: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.TableViewMediclaimList.delegate = self
        self.TableViewMediclaimList.dataSource = self
        
        loadData() //---funtion to load data from api
        
        //Subordinate
        let tapGestureRecognizerSubordinateMediclaimListView = UITapGestureRecognizer(target: self, action: #selector(MediclaimView(tapGestureRecognizer:)))
        LabelCustomBtnSubordinateMediclaim.isUserInteractionEnabled = true
        LabelCustomBtnSubordinateMediclaim.addGestureRecognizer(tapGestureRecognizerSubordinateMediclaimListView)
        
    }
    
    //---Subordinate
    @objc func MediclaimView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "subordinatemediclaim", sender: nil)
    }
    
    @IBAction func BtnNewMediclaimRequest(_ sender: Any) {
        MediclaimListViewController.new_create_yn = true
        self.performSegue(withIdentifier: "mediclaimrequest", sender: nil)
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    
    //----------tableview code starts------------
//    var rowIndex: Int! // --for instant delete delaring the variable
    func MediclaimListTableViewCellRemoveDidTapAddOrView(_ sender: MediclaimListTableViewCell) {
        guard let tappedIndexPath = TableViewMediclaimList.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        let body = "Do you really want to delete this record \(rowData["mediclaim_no"] as! String)?"
        let  mediclaim_id = rowData["mediclaim_id"] as? Int
        MediclaimListViewController.mediclaim_id = rowData["mediclaim_id"] as? Int
        print("Selected-=>",mediclaim_id!)
        print("Selected")
        openDeletePopup(body: body)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MediclaimListTableViewCell
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
        
        cell.label_mediclaim_no.text = dict["mediclaim_no"] as? String
        cell.label_mediclaim_date.text = dict["mediclaim_date"] as? String
        cell.label_amount.text = String(describing:dict["mediclaim_amount"] as! Double)
        cell.label_mediclaim_status.text = dict["mediclaim_status"] as? String
        /*cell.label_timeout.text = dict["time_out"] as? String
        cell.label_status.text = dict["attendance_status"] as? String
        cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)*/
        if dict["mediclaim_status"] as? String == "Saved"{
            cell.image_view_delete.isHidden = false
        }else{
            cell.image_view_delete.isHidden = true
        }
        
        if dict["mediclaim_status"] as? String == "Approved"{
            cell.label_mediclaim_status.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["mediclaim_status"] as? String == "Canceled"{
            cell.label_mediclaim_status.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["mediclaim_status"] as? String == "Returned"{
            cell.label_mediclaim_status.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["mediclaim_status"] as? String == "Submitted"{
            cell.label_mediclaim_status.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["mediclaim_status"] as? String == "Saved"{
            cell.label_mediclaim_status.textColor = UIColor(hexFromString: "2196ed")
        }
        return cell
        
    }
    
    //---------onClick tableview code starts----------
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            MediclaimListViewController.new_create_yn = false
            let row=arrRes[indexPath.row]
            print(row)
            print("tap is working")
           
            MediclaimListViewController.mediclaim_no = row["mediclaim_no"] as? String
            MediclaimListViewController.mediclaim_id = row["mediclaim_id"]?.intValue
            MediclaimListViewController.mediclaim_amount = row["payment_amount"]?.doubleValue
            /*AdvanceRequisitionListViewController.description = row["description"] as? String
            AdvanceRequisitionListViewController.approved_requisition_amount = row["approved_requisition_amount"]?.doubleValue
            AdvanceRequisitionListViewController.supervisor_remark = row["supervisor_remark"] as? String
            AdvanceRequisitionListViewController.requisition_status = row["requisition_status"] as? String*/
           
//            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
//            print("test-=>",row["od_request_id"]?.stringValue)
            MediclaimListViewController.EmployeeType = "Employee"
            
            //--added on 18th June
            /*AdvanceRequisitionListViewController.approved_date = row["approved_date"] as? String
            AdvanceRequisitionListViewController.approved_by_name = row["approved_by_name"] as? String
            AdvanceRequisitionListViewController.requisition_date = row["requisition_date"] as? String*/
            MediclaimListViewController.employee_name = row["employee_name"] as? String
            /*AdvanceRequisitionListViewController.requisition_type = row["requisition_type"] as? String
            AdvanceRequisitionListViewController.requisition_id = row["requisition_id"]?.intValue
            AdvanceRequisitionListViewController.supervisor1_id = row["supervisor1_id"]?.intValue
            AdvanceRequisitionListViewController.supervisor2_id = row["supervisor2_id"]?.intValue
            AdvanceRequisitionListViewController.approved_by_id = row["approved_by_id"]?.intValue
            AdvanceRequisitionListViewController.reason = row["reason"]?.intValue
            AdvanceRequisitionListViewController.return_period_in_months = row["return_period_in_months"]?.intValue*/
//            self.performSegue(withIdentifier: "advancerequisition", sender: self)
            MediclaimListViewController.new_create_yn = false
            self.performSegue(withIdentifier: "mediclaimrequest", sender: nil)
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
        
        let url = "\(BASE_URL)mediclaim/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/Employee/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("AdvanceReqlisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["mediclaim_list"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.TableViewMediclaimList.reloadData()
                   }else{
                       self.TableViewMediclaimList.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewMediclaimList.bounds.size.width, height: self.TableViewMediclaimList.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewMediclaimList.backgroundView  = noDataLabel
                       self.TableViewMediclaimList.separatorStyle  = .none
                       
                   }
               }
               
           }
       }
       //--------function to show log details using Alamofire and Json Swifty code ends------------
    //===============FormDelete Popup code starts(added on 29th june)===================
    
    
    @IBOutlet weak var btnPopupOk: UIButton!
    @IBOutlet weak var btnPopupCancel: UIButton!
    @IBAction func btnPopupOk(_ sender: Any) {
        closeDeletePopup()
        
//        deleteApi(requisition_id: AdvanceRequisitionListViewController.requisition_id!)
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
