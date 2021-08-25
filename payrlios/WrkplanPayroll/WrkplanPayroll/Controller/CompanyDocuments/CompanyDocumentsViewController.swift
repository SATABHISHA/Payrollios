//
//  CompanyDocumentsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 27/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift


class CompanyDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,downloadCompanyDocumentDelegate {
    
    @IBOutlet weak var tableviewCompanyDocuments: UITableView!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeStatusBarColor() //---to change background statusbar color
        
        self.tableviewCompanyDocuments.dataSource = self
        self.tableviewCompanyDocuments.delegate = self
        
        tableviewCompanyDocuments.backgroundColor = UIColor(hexFromString: "ffffff")
        // Do any additional setup after loading the view.
        loadData()
    }
    
    @IBAction func btn_home(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CompanyDocumentsTableViewCell
        cell.delegate = self
        
        let dict = arrRes[indexPath.row]
        cell.label_name.text = dict["name"] as? String
        cell.label_date.text = dict["upload_datetime"] as? String
        return cell
    }
    
    func downloadCompanyDocumentdidTapTableviewcell(_ sender: CompanyDocumentsTableViewCell) {
        guard let tappedIndexPath = tableviewCompanyDocuments.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
        /*   let url1 = rowData["file_name"] as? String
         //        let url1 = "http://www.filedownloader.com/mydemofile.pdf"
         let url = URL(string: url1!)
         FileDownloader.loadFileAsync(url: url!) { (path, error) in
         print("PDF File downloaded to : \(path!)")
         } */
        let url1 = rowData["file_name"] as? String
        print("url-=>",url1!)
        if let url = URL(string: url1!){
            FileDownloader.loadFileAsync(url: url) { (path, error) in
             print("PDF File downloaded to : \(path!)")
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                
                // present the toast with the new style
                self.view.makeToast("File downloaded successfully", duration: 3.0, position: .bottom, style: style)
             }
        }else{
            print("Unable to download file")
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .white
            self.view.makeToast("Internal server error", duration: 3.0, position: .bottom, style: style)
        }
    }
    
    
    //--------function to show document details using Alamofire and Json Swifty------------
    func loadData(){
        loaderStart()
        let url = "\(BASE_URL)companydocs/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)"
        //        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Company description: \(swiftyJsonVar)")
                if let resData = swiftyJsonVar["docs"].arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count>0 {
                    self.tableviewCompanyDocuments.reloadData()
                }else{
                    self.tableviewCompanyDocuments.reloadData()
                    //                    Toast(text: "No data", duration: Delay.short).show()
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewCompanyDocuments.bounds.size.width, height: self.tableviewCompanyDocuments.bounds.size.height))
                    noDataLabel.text          = "No record found"
                    noDataLabel.font = UIFont.systemFont(ofSize: 14)
                    noDataLabel.textColor     = UIColor(hexFromString: "767575")
                    noDataLabel.textAlignment = .center
                    self.tableviewCompanyDocuments.backgroundView  = noDataLabel
                    self.tableviewCompanyDocuments.separatorStyle  = .none
                    
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
}
