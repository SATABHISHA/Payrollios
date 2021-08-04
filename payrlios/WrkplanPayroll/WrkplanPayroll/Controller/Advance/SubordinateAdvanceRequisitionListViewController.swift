//
//  SubordinateAdvanceRequisitionListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 17/06/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class SubordinateAdvanceRequisitionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var TableViewAdvanceRequisition: UITableView!
    
    @IBOutlet weak var SearchBarAdvanceRequisition: UISearchBar!
    var filteredTableData = [[String: AnyObject]]()
    
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.TableViewAdvanceRequisition.delegate = self
        self.TableViewAdvanceRequisition.dataSource = self
        self.SearchBarAdvanceRequisition.delegate = self
        
        TableViewAdvanceRequisition.backgroundColor = UIColor(hexFromString: "ffffff")
        SearchBarAdvanceRequisition.searchTextField.backgroundColor = UIColor.white
        SearchBarAdvanceRequisition.backgroundColor = UIColor.white
        SearchBarAdvanceRequisition.searchTextField.textColor = UIColor.black
        //        searchBar.searchTextField.borderColor = UIColor.lightGray
        //        searchBar.searchTextField.borderWidth = 1
        //        searchBar.searchTextField.cornerRadius = 10
        SearchBarAdvanceRequisition.layer.borderWidth = 10
        SearchBarAdvanceRequisition.layer.borderColor = UIColor.white.cgColor
        loadData()
        
        
    }
    
    
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "advancehome", sender: nil)
    }
    
    //----------tableview code starts------------
    //    var rowIndex: Int! // --for instant delete delaring the variable
    
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
        
        self.TableViewAdvanceRequisition.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateAdvanceRequisitionListTableViewCell
        //        rowIndex = indexPath.row
        
        //        cell.delegate = self
        
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
        cell.LabelRequisitionNo.text = dict["requisition_no"] as? String
        cell.LabelDate.text = dict["requisition_date"] as? String
        cell.LabelRequisitionAmount.text = String(describing:dict["requisition_amount"] as! Double)
        cell.LabelStatus.text = dict["requisition_status"] as? String
        
        
        
        
        if dict["requisition_status"] as? String == "Approved"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["requisition_status"] as? String == "Canceled"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["requisition_status"] as? String == "Returned"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["requisition_status"] as? String == "Submitted"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["requisition_status"] as? String == "Saved"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "2196ed")
        }
        return cell
        
    }
    
    //---------onClick tableview code starts----------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AdvanceRequisitionListViewController.new_create_yn = false
        let row = filteredTableData[indexPath.row]
        print(row)
        print("tap is working")
        
        AdvanceRequisitionListViewController.requisition_no = row["requisition_no"] as? String
        AdvanceRequisitionListViewController.requisition_amount = row["requisition_amount"]?.doubleValue
        AdvanceRequisitionListViewController.description = row["description"] as? String
        AdvanceRequisitionListViewController.approved_requisition_amount = row["approved_requisition_amount"]?.doubleValue
        AdvanceRequisitionListViewController.supervisor_remark = row["supervisor_remark"] as? String
        AdvanceRequisitionListViewController.requisition_status = row["requisition_status"] as? String
        AdvanceRequisitionListViewController.employee_id = row["employee_id"]?.intValue
        AdvanceRequisitionListViewController.reason = row["reason"]?.intValue
        AdvanceRequisitionListViewController.return_period_in_months = row["return_period_in_months"]?.intValue
        
        //--added on 23rd June
        AdvanceRequisitionListViewController.approved_date = row["approved_date"] as? String
        AdvanceRequisitionListViewController.approved_by_name = row["approved_by_name"] as? String
        AdvanceRequisitionListViewController.requisition_date = row["requisition_date"] as? String
        AdvanceRequisitionListViewController.employee_name = row["employee_name"] as? String
        AdvanceRequisitionListViewController.requisition_type = row["requisition_type"] as? String
        AdvanceRequisitionListViewController.requisition_id = row["requisition_id"]?.intValue
        AdvanceRequisitionListViewController.supervisor1_id = row["supervisor1_id"]?.intValue
        AdvanceRequisitionListViewController.supervisor2_id = row["supervisor2_id"]?.intValue
        AdvanceRequisitionListViewController.approved_by_id = row["approved_by_id"]?.intValue
        
        //            print("test",SubordinateOutdoorDutyRequestListViewController.od_request_id!)
        //            print("test-=>",row["od_request_id"]?.stringValue)
        AdvanceRequisitionListViewController.EmployeeType = "Supervisor"
        self.performSegue(withIdentifier: "advancesubordinaterequest", sender: self)
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
        
        let url = "\(BASE_URL)advance-requisition/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/Supervisor/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("AdvanceReqlisturl-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Log description: \(swiftyJsonVar)")
                
                
                
                if let resData = swiftyJsonVar["requisition_list"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                    self.filteredTableData = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.TableViewAdvanceRequisition.reloadData()
                }else{
                    self.TableViewAdvanceRequisition.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewAdvanceRequisition.bounds.size.width, height: self.TableViewAdvanceRequisition.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.TableViewAdvanceRequisition.backgroundView  = noDataLabel
                    self.TableViewAdvanceRequisition.separatorStyle  = .none
                    self.SearchBarAdvanceRequisition.isHidden = true
                    
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
