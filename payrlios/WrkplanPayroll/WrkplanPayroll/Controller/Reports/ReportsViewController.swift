//
//  ReportsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReportsTableViewCellDelegate {
   

    @IBOutlet weak var TanleViewReports: UITableView!
    var arrRes = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TanleViewReports.delegate = self
        TanleViewReports.dataSource = self
        
        loadReportsData()
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
    }
    
    
    func loadReportsData(){
        let dict:[[String:Any]] = [["id":0,"title":"PF Deduction"],["id":1,"title":"Demo"]]
        self.arrRes = dict
    }
    
    //------tableview code, starts-----
    func ReportsItemTableViewCellDidTapView(_ sender: ReportsTableViewCell) {
        guard let tappedIndexPath = TanleViewReports.indexPath(for: sender) else {return}
        let rowData = arrRes[tappedIndexPath.row]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReportsTableViewCell
        
        cell.delegate = self
        
        let dict = arrRes[indexPath.row]
        cell.LabelTitle.text = dict["title"] as? String
        
        return cell
        
    }
    //------tableview code, ends-----
}
