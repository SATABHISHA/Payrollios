//
//  InsuranceDetailViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 27/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class InsuranceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var label_policy_type: UILabel!
    @IBOutlet weak var label_provider_name: UILabel!
    @IBOutlet weak var label_policy_name: UILabel!
    @IBOutlet weak var label_amount: UILabel!
    @IBOutlet weak var label_premium: UILabel!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var tableviewInsurance: UITableView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var arrRes = [[String:AnyObject]]()
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var count = 0
    var data_count:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.tableviewInsurance.delegate = self
        self.tableviewInsurance.dataSource = self

        // Do any additional setup after loading the view.
        btnPrevious.isEnabled = false
        btnPrevious.alpha = CGFloat(0.6)
        btnPrevious.backgroundColor = UIColor(hexFromString: "#EEEEEE")
        
        btnNext.isEnabled = true
        btnNext.alpha = CGFloat(1.0)
        btnNext.backgroundColor = UIColor(hexFromString: "#ffffff")
        
        btnClose.isEnabled = true
        btnClose.alpha = CGFloat(1.0)
        btnClose.backgroundColor = UIColor(hexFromString: "#ffffff")
        
        loadData(i: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btn_click(_ sender: UIButton) {
        switch sender {
        case btnPrevious:
            count = count - 1
            if count == 0{
                btnPrevious.isEnabled = false
                btnPrevious.alpha = CGFloat(0.6)
                btnPrevious.backgroundColor = UIColor(hexFromString: "#EEEEEE")
                
                btnNext.isEnabled = true
                btnNext.alpha = CGFloat(1.0)
                btnNext.backgroundColor = UIColor(hexFromString: "#ffffff")
                
                loadData(i: count)
            }else{
                btnPrevious.isEnabled = true
                btnPrevious.alpha = CGFloat(1.0)
                btnPrevious.backgroundColor = UIColor(hexFromString: "#ffffff")
                
                btnNext.isEnabled = true
                btnNext.alpha = CGFloat(1.0)
                btnNext.backgroundColor = UIColor(hexFromString: "#ffffff")
                
                loadData(i: count)
            }
            break
        case btnClose:
            self.performSegue(withIdentifier: "home", sender: self)
            break
        case btnNext:
            count = count + 1
            if count == data_count{
                btnNext.isEnabled = false
                btnNext.alpha = CGFloat(0.6)
                btnNext.backgroundColor = UIColor(hexFromString: "#EEEEEE")
                
                btnPrevious.isEnabled = true
                btnPrevious.alpha = CGFloat(1.0)
                btnPrevious.backgroundColor = UIColor(hexFromString: "#ffffff")
                
                loadData(i: count)
            }else{
                btnNext.isEnabled = true
                btnNext.alpha = CGFloat(1.0)
                btnNext.backgroundColor = UIColor(hexFromString: "#ffffff")
                
                btnPrevious.isEnabled = true
                btnPrevious.alpha = CGFloat(1.0)
                btnPrevious.backgroundColor = UIColor(hexFromString: "#ffffff")
                
                loadData(i: count)
            }
            break
        default:
            break
        }
    }
    
    //---------tableview code starts---------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InsuranceDetailTableViewCell
        let dict = arrRes[indexPath.row]
        cell.label_member_name.text = dict["name"] as? String
        cell.label_member_relationship.text = dict["relationship"] as? String
        return cell
    }
    //----------tableview code ends---------
    
    
    //--------function to show document details using Alamofire and Json Swifty------------
    func loadData(i:Int!){
           loaderStart()
        let url = "\(BASE_URL)insurance/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)"
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Documents description: \(swiftyJsonVar)")
                
                self.data_count = swiftyJsonVar["policies"].count - 1
                
                self.label_policy_type.text = swiftyJsonVar["policies"][i]["type"].stringValue
                self.label_provider_name.text = swiftyJsonVar["policies"][i]["provider_name"].stringValue
                self.label_policy_name.text = swiftyJsonVar["policies"][i]["no"].stringValue
                self.label_amount.text = swiftyJsonVar["policies"][i]["amount"].stringValue
                self.label_premium.text = swiftyJsonVar["policies"][i]["premium_amount"].stringValue
                self.label_date.text = swiftyJsonVar["policies"][i]["expiry_date"].stringValue
                
                    if let resData = swiftyJsonVar["policies"][i]["members"].arrayObject{
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                print("test-=>",self.arrRes)
                print("count-=>",self.data_count)
            
                   if self.arrRes.count>0 {
                       self.tableviewInsurance.reloadData()
                   }else{
                       self.tableviewInsurance.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewInsurance.bounds.size.width, height: self.tableviewInsurance.bounds.size.height))
                       noDataLabel.text          = "No Data"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.tableviewInsurance.backgroundView  = noDataLabel
                       self.tableviewInsurance.separatorStyle  = .none
                       
                   }
               }
               
           }
       }
       //--------function to show document details using Alamofire and Json Swifty code ends------------
    
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
    
};
extension UIColor {
 convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
 var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
 var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
 
 if (cString.hasPrefix("#")) {
 cString.remove(at: cString.startIndex)
 }
 
 if ((cString.count) == 6) {
 Scanner(string: cString).scanHexInt32(&rgbValue)
 }
 
 self.init(
 red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
 alpha: alpha
 )
 }
 }
