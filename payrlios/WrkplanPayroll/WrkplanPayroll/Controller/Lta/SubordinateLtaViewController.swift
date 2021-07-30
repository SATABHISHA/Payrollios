//
//  SubordinateLtaViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 21/07/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class SubordinateLtaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var TableViewSubordinateLta: UITableView!
    
    @IBOutlet weak var SearchBarLtaRequisition: UISearchBar!
    var filteredTableData = [[String: AnyObject]]()
    
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.TableViewSubordinateLta.delegate = self
        self.TableViewSubordinateLta.dataSource = self
        self.SearchBarLtaRequisition.delegate = self
        
        TableViewSubordinateLta.backgroundColor = UIColor(hexFromString: "ffffff")
        SearchBarLtaRequisition.searchTextField.backgroundColor = UIColor.white
        SearchBarLtaRequisition.backgroundColor = UIColor.white
        SearchBarLtaRequisition.searchTextField.textColor = UIColor.black
//        searchBar.searchTextField.borderColor = UIColor.lightGray
//        searchBar.searchTextField.borderWidth = 1
//        searchBar.searchTextField.cornerRadius = 10
        SearchBarLtaRequisition.layer.borderWidth = 10
        SearchBarLtaRequisition.layer.borderColor = UIColor.white.cgColor
        loadData()
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "lta", sender: nil)
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

        self.TableViewSubordinateLta.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubordinateLtaTableViewCell
//        rowIndex = indexPath.row
        
//        cell.delegate = self
        
        let dict = filteredTableData[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "dd-MMM-yyyy" //--format changed in ios on 24th feb
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        cell.LabelName.text = dict["employee_name"] as? String
        cell.LabelLtaNo.text = dict["lta_application_no"] as? String
        cell.LabelDate.text = "\(String(describing: dict["date_from"] as! String)) to \(String(describing: dict["date_to"] as! String))"
        cell.LabelLtaAmount.text = String(describing:dict["lta_amount"] as! Double)
        cell.LabelStatus.text = dict["lta_application_status"] as? String
       
        
        if dict["lta_application_status"] as? String == "Approved"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "1e9547")
        }else if dict["lta_application_status"] as? String == "Cancelled"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "ed1c24")
        }else if dict["lta_application_status"] as? String == "Returned"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "2196ed")
        }else if dict["lta_application_status"] as? String == "Submitted"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "fe52ce")
        }else if dict["lta_application_status"] as? String == "Saved"{
            cell.LabelStatus.textColor = UIColor(hexFromString: "2196ed")
        }
        return cell
        
    }
    
    //---------onClick tableview code starts----------
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            LtaListViewController.new_create_yn = false
            let row = filteredTableData[indexPath.row]
            print(row)
            print("tap is working")
           
            LtaListViewController.lta_no = row["lta_application_no"] as? String
            LtaListViewController.lta_amount = row["lta_amount"]?.doubleValue
            LtaListViewController.lta_no = row["lta_application_no"] as? String
            LtaListViewController.lta_status = row["lta_application_status"] as? String
            LtaListViewController.lta_id = row["lta_application_id"]?.intValue
            LtaListViewController.employee_name = row["employee_name"] as? String
            LtaListViewController.employee_id = row["employee_id"]?.intValue
           
            LtaListViewController.new_create_yn = false
            
          
            LtaListViewController.EmployeeType = "Supervisor"
            self.performSegue(withIdentifier: "ltarequest", sender: self)
        }
        //---------onClick tableview code ends----------
    
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        
        let url = "\(BASE_URL)lta/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/Subordinate/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("Ltalisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["lta_list"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                       self.filteredTableData = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.TableViewSubordinateLta.reloadData()
                   }else{
                       self.TableViewSubordinateLta.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewSubordinateLta.bounds.size.width, height: self.TableViewSubordinateLta.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewSubordinateLta.backgroundView  = noDataLabel
                       self.TableViewSubordinateLta.separatorStyle  = .none
                       self.TableViewSubordinateLta.isHidden = true
                       
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
