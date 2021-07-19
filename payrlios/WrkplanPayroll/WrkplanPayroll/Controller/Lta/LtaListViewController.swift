//
//  LtaListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 14/07/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class LtaListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LtaListTableViewCellDelegate {
   
    @IBOutlet weak var LabelSubordinateLtaRequisition: UILabel!
    @IBOutlet weak var TableViewLtaRequisitionList: UITableView!
    
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    static var lta_no: String!, lta_status: String!, EmployeeType: String!
    static var lta_amount: Double!, approved_lta_amount: Double!, payment_amount: Double!
    static var new_create_yn: Bool = false
    
    static var  lta_date: String!, employee_name: String!, lta_type: String!
    static var lta_id: Int!, employee_id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.TableViewLtaRequisitionList.delegate = self
        self.TableViewLtaRequisitionList.dataSource = self
        
        //Subordinate
        let tapGestureRecognizerSubordinateLtaListView = UITapGestureRecognizer(target: self, action: #selector(LtaView(tapGestureRecognizer:)))
        LabelSubordinateLtaRequisition.isUserInteractionEnabled = true
        LabelSubordinateLtaRequisition.addGestureRecognizer(tapGestureRecognizerSubordinateLtaListView)
        
        loadData()
        
    }
    //---Subordinate
    @objc func LtaView(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "subordinatemediclaim", sender: nil)
    }

    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    @IBAction func BtnNew(_ sender: Any) {
        self.performSegue(withIdentifier: "ltarequest", sender: nil)
    }
    
    
    //========tableview code starts=======
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LtaListTableViewCell
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
        
        cell.LabelLtaRequisitionNo.text = dict["lta_application_no"] as? String
        cell.LabelLtaDate.text = "\(String(describing: dict["date_from"] as! String)) to \(String(describing: dict["date_to"] as! String))"
        cell.LabelLtaAmount.text = String(describing:dict["lta_amount"] as! Double)
        cell.LabelLtaStatus.text = dict["lta_application_status"] as? String
        /*cell.label_timeout.text = dict["time_out"] as? String
        cell.label_status.text = dict["attendance_status"] as? String
        cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)*/
        if dict["lta_application_status"] as? String == "Saved"{
            cell.ImgViewDelete.isHidden = false
        }else{
            cell.ImgViewDelete.isHidden = true
        }
        
        if dict["lta_application_status"] as? String == "Approved"{
            cell.LabelLtaStatus.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["lta_application_status"] as? String == "Cancelled"{
            cell.LabelLtaStatus.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["lta_application_status"] as? String == "Returned"{
            cell.LabelLtaStatus.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["lta_application_status"] as? String == "Submitted"{
            cell.LabelLtaStatus.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["lta_application_status"] as? String == "Saved"{
            cell.LabelLtaStatus.textColor = UIColor(hexFromString: "2196ed")
        }
        return cell
    }
    
    func LtaListTableViewCellRemoveDidTapAddOrView(_ sender: LtaListTableViewCell) {
        guard let tappedIndexPath = TableViewLtaRequisitionList.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        let body = "Do you really want to delete this record \(rowData["lta_application_no"] as! String)?"
        let  lta_application_id = rowData["lta_application_id"] as? Int
        LtaListViewController.lta_id = rowData["lta_application_id"] as? Int
        print("Selected-=>",lta_application_id!)
        print("Selected")
        openDeletePopup(body: body)
    }
    
    //---------onClick tableview code starts----------
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            LtaListViewController.new_create_yn = false
            let row=arrRes[indexPath.row]
            print(row)
            print("tap is working")
           
            LtaListViewController.lta_no = row["lta_application_no"] as? String
            LtaListViewController.lta_status = row["lta_application_status"] as? String
            LtaListViewController.lta_id = row["lta_application_id"]?.intValue

            LtaListViewController.EmployeeType = "Employee"
            
            
            LtaListViewController.employee_name = row["employee_name"] as? String
           
            LtaListViewController.new_create_yn = false
//            self.performSegue(withIdentifier: "mediclaimrequest", sender: nil)
        }
        //---------onClick tableview code ends----------
    //========tableview code ends========
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        
        let url = "\(BASE_URL)lta/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/Employee/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("AdvanceReqlisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["lta_list"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.TableViewLtaRequisitionList.reloadData()
                   }else{
                       self.TableViewLtaRequisitionList.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewLtaRequisitionList.bounds.size.width, height: self.TableViewLtaRequisitionList.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewLtaRequisitionList.backgroundView  = noDataLabel
                       self.TableViewLtaRequisitionList.separatorStyle  = .none
                       
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
