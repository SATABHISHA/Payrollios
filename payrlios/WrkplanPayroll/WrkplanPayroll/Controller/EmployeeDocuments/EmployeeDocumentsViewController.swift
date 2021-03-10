//
//  EmployeeDocumentsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 26/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class EmployeeDocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, downloadDelegate {
    
    
    
    @IBOutlet weak var tableviewEmployeeDocuments: UITableView!
    //    http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39
    
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color

        // Do any additional setup after loading the view.
        self.tableviewEmployeeDocuments.delegate = self
        self.tableviewEmployeeDocuments.dataSource = self
        
        tableviewEmployeeDocuments.backgroundColor = UIColor(hexFromString: "ffffff")
        
        self.loadData()
    }
    

    @IBAction func btn_home(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    func downloadTableViewCelldidTap(_ sender: EmployeeDocumentsTableViewCell) {
        guard let tappedIndexPath = tableviewEmployeeDocuments.indexPath(for: sender) else {return}
                let rowData = arrRes[tappedIndexPath.row]
        let url1 = rowData["file_path"] as? String
//        let url1 = "http://www.filedownloader.com/mydemofile.pdf"
        let url = URL(string: url1!)
        FileDownloader.loadFileAsync(url: url!) { (path, error) in
            print("PDF File downloaded to : \(path!)")
        }
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewEmployeeDocuments.dequeueReusableCell(withIdentifier: "cell") as! EmployeeDocumentsTableViewCell
        cell.delegate = self
        let dict = arrRes[indexPath.row]
        cell.label_document_name.text = dict["name"] as? String
        return cell
    }

    //--------function to show document details using Alamofire and Json Swifty------------
       func loadData(){
           loaderStart()
        
        let url = "http://14.99.211.60:9018/api/employeedocs/list/EMC_NEW/39"
           AF.request(url).responseJSON{ (responseData) -> Void in
               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Goal description: \(swiftyJsonVar)")
                   if let resData = swiftyJsonVar["docs"].arrayObject{
                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                   if self.arrRes.count>0 {
                       self.tableviewEmployeeDocuments.reloadData()
                   }else{
                       self.tableviewEmployeeDocuments.reloadData()
                       //                    Toast(text: "No data", duration: Delay.short).show()
                       let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableviewEmployeeDocuments.bounds.size.width, height: self.tableviewEmployeeDocuments.bounds.size.height))
                       noDataLabel.text          = "No goal is available"
                       noDataLabel.textColor     = UIColor.black
                       noDataLabel.textAlignment = .center
                       self.tableviewEmployeeDocuments.backgroundView  = noDataLabel
                       self.tableviewEmployeeDocuments.separatorStyle  = .none
                       
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
