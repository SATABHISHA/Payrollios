//
//  DashboardViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 25/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class DashboardViewController: UIViewController {

    @IBOutlet weak var ViewEmpDetails: UIView!
    @IBOutlet weak var LabelEmpName: UILabel!
    @IBOutlet weak var LabelDesignation: UILabel!
    @IBOutlet weak var LabelDepartment: UILabel!
    @IBOutlet weak var LabelSupervisor1: UILabel!
    @IBOutlet weak var LabelSupervisor2: UILabel!
    
    
    @IBOutlet weak var ViewAttendance: UIView!
    @IBOutlet weak var ViewChildAttendance: UIView!
    @IBOutlet weak var LabelInTime: UILabel!
    @IBOutlet weak var LabelOutTime: UILabel!
    @IBOutlet weak var TxtViewWFH: UITextView!
    @IBOutlet weak var TxtViewWFHHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCheckBox: UIButton!
    var checkBtnYN = 0
    var work_from_home_flag: Int!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    @IBOutlet weak var LabelCorpId: UILabel!
    @IBOutlet weak var ViewCalendar: UIView!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnCheckBox.setImage(UIImage(named:"check_box_empty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"check_box"), for: .selected)
        
        TxtViewWFHHeightConstraint.constant = 0
        self.TxtViewWFH.layer.borderColor = UIColor.lightGray.cgColor
        self.TxtViewWFH.layer.borderWidth = 1

        LoadEmployeeDetails()
        LoadCalendarDetails()
        ChangeStatusBarColor()
        
    }
    
    
    @IBAction func checkMarkedTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                if(!sender.isSelected){
                    sender.isSelected = true
                    sender.transform = .identity
                    self.checkBtnYN = 1
                    self.TxtViewWFHHeightConstraint.constant = 44
                    print("checked", self.checkBtnYN)
                    self.work_from_home_flag = 1
                }else{
                    sender.isSelected = false
                    sender.transform = .identity
                    self.checkBtnYN = 0
                    self.TxtViewWFHHeightConstraint.constant = 0
                    print("Un checked")
                    self.work_from_home_flag = 0
                }
            }, completion: nil)
        }
        
    }
    
    func LoadEmployeeDetails(){
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        self.LabelEmpName.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        self.LabelDesignation.text = swiftyJsonvar1["employee"]["designation_name"].stringValue
        self.LabelDepartment.text = swiftyJsonvar1["company"]["company_name"].stringValue
        self.LabelSupervisor1.text = swiftyJsonvar1["employee"]["supervisor_1_name"].stringValue
        self.LabelSupervisor2.text = swiftyJsonvar1["employee"]["supervisor_2_name"].stringValue
        self.LabelCorpId.text = swiftyJsonvar1["company"]["corporate_id"].stringValue
    }
    
    func LoadCalendarDetails(){
       
    }

}
