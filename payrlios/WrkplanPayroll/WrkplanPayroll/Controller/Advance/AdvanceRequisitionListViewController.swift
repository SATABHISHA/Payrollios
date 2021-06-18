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

class AdvanceRequisitionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    static var requisition_id: Int!, supervisor1_id: Int!, supervisor2_id: Int!, employee_id: Int!, approved_by_id: Int!
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AdvanceRequisitionListTableViewCell
//        rowIndex = indexPath.row
        
//        cell.delegate = self
        
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
        if dict["requisition_status"] as? String == "Save"{
            cell.custom_img_btn_delete.isHidden = false
        }else{
            cell.custom_img_btn_delete.isHidden = true
        }
        
        if dict["requisition_status"] as? String == "Approved"{
            cell.label_od_status.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["requisition_status"] as? String == "Canceled"{
            cell.label_od_status.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["requisition_status"] as? String == "Return"{
            cell.label_od_status.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["requisition_status"] as? String == "Submit"{
            cell.label_od_status.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["requisition_status"] as? String == "Save"{
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
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewRequisitionList.backgroundView  = noDataLabel
                       self.TableViewRequisitionList.separatorStyle  = .none
                       
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
