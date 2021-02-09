//
//  HomeViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 17/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var EmployeeInformationView: UIView!
    @IBOutlet weak var EmployeeInformationImg: UIImageView!
    @IBOutlet weak var LeaveView: UIView!
    @IBOutlet weak var LeaveImg: UIImageView!
    
    @IBOutlet weak var EmployeeFacilitiesView: UIView!
    @IBOutlet weak var EmployeeFacilitiesImg: UIImageView!
    @IBOutlet weak var EmployeeDocImg: UIImageView!
    @IBOutlet weak var EmployeeDocView: UIView!
    @IBOutlet weak var CompanyDocImg: UIImageView!
    @IBOutlet weak var CompanyDocView: UIView!
    @IBOutlet weak var InsuranceImg: UIImageView!
    @IBOutlet weak var InsuranceView: UIView!
    
    @IBOutlet weak var HolidayView: UIView!
    @IBOutlet weak var HolidayImg: UIImageView!
    
    @IBOutlet weak var TimesheetView: UIView!
    @IBOutlet weak var TimesheetImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
        print("hometesting-=>",swiftyJsonvar1["employee"]["father_husband_name"].stringValue)
        // Do any additional setup after loading the view.
        
        
        //EmployeeInformation
        let tapGestureRecognizerEmployeeInformationView = UITapGestureRecognizer(target: self, action: #selector(EmployeeInformationView(tapGestureRecognizer:)))
        EmployeeInformationView.isUserInteractionEnabled = true
        EmployeeInformationView.addGestureRecognizer(tapGestureRecognizerEmployeeInformationView)
        
        let tapGestureRecognizerEmployeeInformationImg = UITapGestureRecognizer(target: self, action: #selector(EmployeeInformationImg(tapGestureRecognizer:)))
        EmployeeInformationImg.isUserInteractionEnabled = true
        EmployeeInformationImg.addGestureRecognizer(tapGestureRecognizerEmployeeInformationImg)
        
        //Leave
        let tapGestureRecognizerLeaveView = UITapGestureRecognizer(target: self, action: #selector(LeaveView(tapGestureRecognizer:)))
        LeaveView.isUserInteractionEnabled = true
        LeaveView.addGestureRecognizer(tapGestureRecognizerLeaveView)
        
        let tapGestureRecognizerLeaveImg = UITapGestureRecognizer(target: self, action: #selector(LeaveImg(tapGestureRecognizer:)))
        LeaveImg.isUserInteractionEnabled = true
        LeaveImg.addGestureRecognizer(tapGestureRecognizerLeaveImg)
        
        //EmployeeFacilities
        let tapGestureRecognizerEmployeefacilitiesView = UITapGestureRecognizer(target: self, action: #selector(EmployeefacilitiesView(tapGestureRecognizer:)))
        EmployeeFacilitiesView.isUserInteractionEnabled = true
        EmployeeFacilitiesView.addGestureRecognizer(tapGestureRecognizerEmployeefacilitiesView)
        
        let tapGestureRecognizerEmployeefacilitiesImg = UITapGestureRecognizer(target: self, action: #selector(EmployeefacilitiesImg(tapGestureRecognizer:)))
        EmployeeFacilitiesImg.isUserInteractionEnabled = true
        EmployeeFacilitiesImg.addGestureRecognizer(tapGestureRecognizerEmployeefacilitiesImg)
        
        //EmployeeDocuments
        let tapGestureRecognizerEmployeedocView = UITapGestureRecognizer(target: self, action: #selector(EmployeedocView(tapGestureRecognizer:)))
        EmployeeDocView.isUserInteractionEnabled = true
        EmployeeDocView.addGestureRecognizer(tapGestureRecognizerEmployeedocView)
        
        let tapGestureRecognizerEmployeedocImg = UITapGestureRecognizer(target: self, action: #selector(EmployeedocImg(tapGestureRecognizer:)))
        EmployeeDocImg.isUserInteractionEnabled = true
        EmployeeDocImg.addGestureRecognizer(tapGestureRecognizerEmployeedocImg)
        
        //CompanyDocs
        let tapGestureRecognizerCompanydocView = UITapGestureRecognizer(target: self, action: #selector(CompanydocView(tapGestureRecognizer:)))
        CompanyDocView.isUserInteractionEnabled = true
        CompanyDocView.addGestureRecognizer(tapGestureRecognizerCompanydocView)
        
        let tapGestureRecognizerCompanydocImg = UITapGestureRecognizer(target: self, action: #selector(CompanydocImg(tapGestureRecognizer:)))
        CompanyDocImg.isUserInteractionEnabled = true
        CompanyDocImg.addGestureRecognizer(tapGestureRecognizerCompanydocImg)
        
        //InsuranceDetails
        let tapGestureRecognizerInsuranceView = UITapGestureRecognizer(target: self, action: #selector(InsuranceView(tapGestureRecognizer:)))
        InsuranceView.isUserInteractionEnabled = true
        InsuranceView.addGestureRecognizer(tapGestureRecognizerInsuranceView)
        
        let tapGestureRecognizerInsuranceImg = UITapGestureRecognizer(target: self, action: #selector(InsuranceImg(tapGestureRecognizer:)))
        InsuranceImg.isUserInteractionEnabled = true
        InsuranceImg.addGestureRecognizer(tapGestureRecognizerInsuranceImg)
        
        //HolidayDetails
        let tapGestureRecognizerHolidayView = UITapGestureRecognizer(target: self, action: #selector(HolidayView(tapGestureRecognizer:)))
        HolidayView.isUserInteractionEnabled = true
        HolidayView.addGestureRecognizer(tapGestureRecognizerHolidayView)
        
        let tapGestureRecognizerHolidayImg = UITapGestureRecognizer(target: self, action: #selector(HolidayImg(tapGestureRecognizer:)))
        HolidayImg.isUserInteractionEnabled = true
        HolidayImg.addGestureRecognizer(tapGestureRecognizerHolidayImg)
        
        //Timesheet
        let tapGestureRecognizerTimesheetView = UITapGestureRecognizer(target: self, action: #selector(TimesheetView(tapGestureRecognizer:)))
        TimesheetView.isUserInteractionEnabled = true
        TimesheetView.addGestureRecognizer(tapGestureRecognizerTimesheetView)
        
        let tapGestureRecognizerTimesheetImg = UITapGestureRecognizer(target: self, action: #selector(TimesheetImg(tapGestureRecognizer:)))
        TimesheetImg.isUserInteractionEnabled = true
        TimesheetImg.addGestureRecognizer(tapGestureRecognizerTimesheetImg)
    }
    
    //---EmployeeInformation
    @objc func EmployeeInformationView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empinfo", sender: nil)
    }
    
    @objc func EmployeeInformationImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empinfo", sender: nil)
    }
    

    //---Leave
    @objc func LeaveView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "leave", sender: nil)
    }
    
    @objc func LeaveImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "leave", sender: nil)
    }
    
    //---Employee Facilities
    @objc func EmployeefacilitiesView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "facilities", sender: nil)
    }
    
    @objc func EmployeefacilitiesImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "facilities", sender: nil)
    }
    
    //---Employee Documents
    @objc func EmployeedocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empdoc", sender: nil)
    }
    
    @objc func EmployeedocImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "empdoc", sender: nil)
    }
    
    //---Compny Documents
    @objc func CompanydocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "companydoc", sender: nil)
    }
    
    @objc func CompanydocImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "companydoc", sender: nil)
    }
    
    //--Insurance Details
    @objc func InsuranceView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "insurance", sender: nil)
    }
    
    @objc func InsuranceImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "insurance", sender: nil)
    }
    
    //--Holiday Details
    @objc func HolidayView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "holiday", sender: nil)
    }
    
    @objc func HolidayImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "holiday", sender: nil)
    }
    
    //--Timesheet Details
    @objc func TimesheetView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "timesheet", sender: nil)
    }
    
    @objc func TimesheetImg(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "timesheet", sender: nil)
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
