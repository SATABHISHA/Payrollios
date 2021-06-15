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
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change backgrounf statusbar color
        
        self.TableViewRequisitionList.delegate = self
        self.TableViewRequisitionList.dataSource = self
        
        loadData()
    }
    
    @IBAction func BtnOnClick(_ sender: UIButton) {
        switch sender {
        case BtnNew:
            break
        case BtnBack:
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
      /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        }*/
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
