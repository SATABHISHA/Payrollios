//
//  MyLeaveApplicationViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyLeaveApplicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableViewLeaveApplication: UITableView!
    var arrRes = [[String:AnyObject]]()
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    static var new_create_yn: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.TableViewLeaveApplication.delegate = self
        self.TableViewLeaveApplication.dataSource = self
        loadData()
    }
    

    @IBAction func BtnNew(_ sender: Any) {
        MyLeaveApplicationViewController.new_create_yn = true
        self.performSegue(withIdentifier: "myleaverqst", sender: self)
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "leave", sender: self)
    }
    
    //--------tableview code starts------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyLeaveApplicationTableViewCell
        
        let dict = arrRes[indexPath.row]
        cell.LabelApplicationCode.text = dict["appliction_code"] as? String
        cell.LabelDate.text = "\(String(describing: dict["from_date"] as! String)) to \(String(describing: dict["to_date"] as! String)))"
        cell.LabelDayCount.text = String(dict["total_days"] as! Int)
        cell.LabelLeaveType.text = dict["leave_name"] as? String
        cell.LabelStatus.text = dict["leave_status"] as? String
        
        return cell
    }
    //--------tableview code ends------
    //--------function to show log details using Alamofire and Json Swifty------------
    func loadData(){
           loaderStart()
        
        let url = "\(BASE_URL)leave/application/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/1/\(swiftyJsonvar1["user"]["user_id"].stringValue)/"
        print("odDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["application_list"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                    self.TableViewLeaveApplication.reloadData()
                   }else{
                       self.TableViewLeaveApplication.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewLeaveApplication.bounds.size.width, height: self.TableViewLeaveApplication.bounds.size.height))
                       noDataLabel.text          = "No Log(s) available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.TableViewLeaveApplication.backgroundView  = noDataLabel
                       self.TableViewLeaveApplication.separatorStyle  = .none
                       
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
