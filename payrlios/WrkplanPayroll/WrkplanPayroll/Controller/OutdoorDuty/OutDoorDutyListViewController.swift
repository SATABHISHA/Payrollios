//
//  OutDoorDutyListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 01/03/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class OutDoorDutyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var TableViewOutdoorList: UITableView!
    var arrRes = [[String:AnyObject]]()
    
    @IBOutlet weak var view_new_od_duty_request: UIButton!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TableViewOutdoorList.delegate = self
        self.TableViewOutdoorList.dataSource = self
        
        //EmployeeInformation
        let tapGestureRecognizer_view_new_od_duty_request = UITapGestureRecognizer(target: self, action: #selector(view_new_od_duty_request(tapGestureRecognizer:)))
        view_new_od_duty_request.isUserInteractionEnabled = true
        view_new_od_duty_request.addGestureRecognizer(tapGestureRecognizer_view_new_od_duty_request)

        // Do any additional setup after loading the view.
        loadData()
    }
    //OdDutyRequest
    @objc func view_new_od_duty_request(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "outdoordutyrequest", sender: nil)
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    //----------tableview code starts------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OutDoorDutyListTableViewCell
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
        
        cell.label_day_count.text = String(describing:dict["total_days"] as! Int)
        cell.label_od_status.text = dict["od_status"] as? String
        /*cell.label_timeout.text = dict["time_out"] as? String
        cell.label_status.text = dict["attendance_status"] as? String
        cell.label_status.backgroundColor = UIColor(hexFromString: (dict["attendance_color"] as? String)!)*/
        return cell
        
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
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewOutdoorList.backgroundView  = noDataLabel
                       self.TableViewOutdoorList.separatorStyle  = .none
                       
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
