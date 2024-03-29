//
//  EmployeeInformationViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 20/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class EmployeeInformationViewController: UIViewController {

    @IBOutlet weak var emp_stack_view: UIStackView!
    @IBOutlet weak var emp_info_view: UIView!
    @IBOutlet weak var label_emp_name: UILabel!
    @IBOutlet weak var label_emp_code: UILabel!
    @IBOutlet weak var label_esi_no: UILabel!
    @IBOutlet weak var label_pf_no: UILabel!
    @IBOutlet weak var label_uan_no: UILabel!
    @IBOutlet weak var label_supervisor1: UILabel!
    @IBOutlet weak var label_supervisor2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        ChangeStatusBarColor() //---to change background statusbar color
        
        // Do any additional setup after loading the view.
        
        //---added obn 11-March-2024, code starts
        /*self.emp_info_view.clipsToBounds = true
        self.emp_info_view.cornerRadius = 10
        self.emp_info_view.borderWidth = 1
        
        self.emp_stack_view.clipsToBounds = true
        self.emp_stack_view.cornerRadius = 10*/
        
        self.emp_stack_view.layer.shadowColor = UIColor.gray.cgColor
        self.emp_stack_view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.emp_stack_view.layer.shadowOpacity = 3
        self.emp_stack_view.layer.shadowRadius = 5.0
        //---added obn 11-March-2024, code ends
        
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        print("hometesting-=>",swiftyJsonvar1["employee"]["father_husband_name"].stringValue)
        
        label_emp_name.text = "  \(swiftyJsonvar1["employee"]["employee_fname"].stringValue) \(swiftyJsonvar1["employee"]["employee_lname"].stringValue)"
        label_emp_code.text = "  \(swiftyJsonvar1["employee"]["employee_code"].stringValue)"
        label_esi_no.text = "  \(swiftyJsonvar1["employee"]["esi_no"].stringValue)"
        label_pf_no.text = "  \(swiftyJsonvar1["employee"]["pf_no"].stringValue)"
        label_uan_no.text = "  \(swiftyJsonvar1["employee"]["uan_no"].stringValue)"
        label_supervisor1.text = "  \(swiftyJsonvar1["employee"]["supervisor_1_name"].stringValue)"
        label_supervisor2.text = "  \(swiftyJsonvar1["employee"]["supervisor_2_name"].stringValue)"
    }
    
    @IBAction func btn_home(_ sender: Any) {
        self.performSegue(withIdentifier: "home", sender: nil)
        
    }
    
   
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
