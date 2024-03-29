//
//  AdvanceRequisitionRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 16/06/21.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import Toast_Swift

class AdvanceRequisitionRequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var ButtonReasonIsSelected: Bool!
    @IBOutlet weak var btn_reason_select_type: UIButton!
    let dropDown = DropDown()
    var type = [String]()
    
    @IBOutlet weak var LabelNavBarTitle: UILabel!
    @IBOutlet weak var TxtApplicationStatus: UITextField!
    @IBOutlet weak var TxtViewApprovalRemark: UITextView!
    @IBOutlet weak var TxtApprovedAmount: UITextField!
    @IBOutlet weak var TxtReturnPeriod: UITextField!
    @IBOutlet weak var TxtViewNarration: UITextView!
    @IBOutlet weak var TxtRequisitionAmount: UITextField!
    @IBOutlet weak var TxtCtc: UITextField!
    @IBOutlet weak var TxtRequisitionNo: UITextField!
    
    @IBOutlet weak var TxtEmployeeName: UITextField!
    @IBOutlet weak var ViewButtonCancel: UIView!
    @IBOutlet weak var ViewButtonReturn: UIView!
    @IBOutlet weak var ViewButtonApprove: UIView!
    @IBOutlet weak var ViewButtonSubmit: UIView!
    @IBOutlet weak var ViewButtonSave: UIView!
    @IBOutlet weak var ViewButtonBack: UIView!
    @IBOutlet weak var StackViewButtons: UIStackView!
    
    static var RequisitionReason: Int!
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        TxtRequisitionAmount.delegate = self
        TxtReturnPeriod.delegate = self
        TxtApprovedAmount.delegate = self
        
        TxtViewNarration.backgroundColor = UIColor.white
        TxtViewApprovalRemark.backgroundColor = UIColor.white
        
       
        //---code to customize dropdown button starts------
        let buttonWidth = btn_reason_select_type.frame.width
//        let imageWidth = btn_reason_select_type.imageView!.frame.width
        
        btn_reason_select_type.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
//        btn_reason_select_type.titleEdgeInsets = UIEdgeInsets(top: 0, left: -28, bottom: 0, right: imageWidth)
        btn_reason_select_type.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        btn_reason_select_type.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-70, bottom: 0, right: 0)
        //---code to customize dropdown button ends------
        
        //----code to append dropdown data, starts------
        type.append("i) Serious and / prolonged illness in the family ('Family' means self, wife and dependent children) of the employee.")
        type.append("ii) His / her own marriage.")
        type.append("iii) Son’s / Daughter’s or real Sister’s marriage.")
        type.append("iv) Rehabilitation due to natural calamity, such as flood, fire, accident etc.")
        //----code to append dropdown data, ends------
        
        
        TxtRequisitionNo.isUserInteractionEnabled = false
        TxtEmployeeName.isUserInteractionEnabled = false
        TxtApplicationStatus.isUserInteractionEnabled = false
        TxtCtc.isUserInteractionEnabled = false
        
        
        TxtRequisitionNo.setLeftPaddingPoints(5)
        TxtEmployeeName.setLeftPaddingPoints(5)
        TxtReturnPeriod.setLeftPaddingPoints(5)
        TxtRequisitionAmount.setRightPaddingPoints(5)
        TxtApprovedAmount.setRightPaddingPoints(5)
        TxtApplicationStatus.setLeftPaddingPoints(5)
        TxtCtc.setRightPaddingPoints(5)
        
        TxtCtc.text = swiftyJsonvar1["employee"]["ctc"].stringValue
        if AdvanceRequisitionListViewController.new_create_yn == false{
            if AdvanceRequisitionListViewController.employee_name! == ""{
                TxtEmployeeName.text = "NA"
            }else{
            TxtEmployeeName.text = AdvanceRequisitionListViewController.employee_name!
            }
            if AdvanceRequisitionListViewController.reason == 1 {
                btn_reason_select_type.setTitle("Serious and / prolonged illness in the family ('Family' means self, wife and dependent children) of the employee.", for: .normal)
                AdvanceRequisitionRequestViewController.RequisitionReason = 1
            }
            if AdvanceRequisitionListViewController.reason == 2 {
                btn_reason_select_type.setTitle("His / her own marriage.", for: .normal)
                AdvanceRequisitionRequestViewController.RequisitionReason = 2
            }
            if AdvanceRequisitionListViewController.reason == 3 {
                btn_reason_select_type.setTitle("Son’s / Daughter’s or real Sister’s marriage.", for: .normal)
                AdvanceRequisitionRequestViewController.RequisitionReason = 3
            }
            if AdvanceRequisitionListViewController.reason == 4 {
                btn_reason_select_type.setTitle("Rehabilitation due to natural calamity, such as flood, fire, accident etc.", for: .normal)
                AdvanceRequisitionRequestViewController.RequisitionReason = 4
            }
            
           
            TxtRequisitionNo.text = AdvanceRequisitionListViewController.requisition_no
            TxtRequisitionAmount.text = String(AdvanceRequisitionListViewController.requisition_amount)
            TxtViewNarration.text = AdvanceRequisitionListViewController.description
            TxtApprovedAmount.text = String(AdvanceRequisitionListViewController.approved_requisition_amount)
            TxtViewApprovalRemark.text = AdvanceRequisitionListViewController.supervisor_remark
            TxtReturnPeriod.text = String(AdvanceRequisitionListViewController.return_period_in_months)
            
            //-----code to formate date for requisition_status, starts
            let dateFormatterGet = DateFormatter()
            
            dateFormatterGet.dateFormat = "dd-MMM-yyyy" //--format changed in ios on 24th feb
            let dateFormatterPrintRequistionDate = DateFormatter()
            dateFormatterPrintRequistionDate.dateFormat = "yyyy-MM-dd"
            let date = dateFormatterGet.date(from: (AdvanceRequisitionListViewController.requisition_date)!)
            AdvanceRequisitionListViewController.requisition_date = dateFormatterPrintRequistionDate.string(from: date!)
           
            print("RequisitionDate-=>",AdvanceRequisitionListViewController.requisition_date!)
            
            //-----code to formate date for requisition_status, ends
            
            //---commented on 25-06-2021
          /*  if AdvanceRequisitionListViewController.requisition_status == "Submit"{
            TxtApplicationStatus.text = "Submitted"
            } else if AdvanceRequisitionListViewController.requisition_status == "Return"{
                TxtApplicationStatus.text = "Returned"
            } else if AdvanceRequisitionListViewController.requisition_status == "Save" {
                TxtApplicationStatus.text = "Saved"
            } else{
                TxtApplicationStatus.text = AdvanceRequisitionListViewController.requisition_status
            } */
            
            TxtApplicationStatus.text = AdvanceRequisitionListViewController.requisition_status
            
        }
        if AdvanceRequisitionListViewController.new_create_yn == true{
        TxtEmployeeName.text = swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        }
        
        //Back
        let tapGestureRecognizerBackView = UITapGestureRecognizer(target: self, action: #selector(BackView(tapGestureRecognizer:)))
        ViewButtonBack.isUserInteractionEnabled = true
        ViewButtonBack.addGestureRecognizer(tapGestureRecognizerBackView)
        
        //Cancel
        let tapGestureRecognizerCancelView = UITapGestureRecognizer(target: self, action: #selector(CancelView(tapGestureRecognizer:)))
        ViewButtonCancel.isUserInteractionEnabled = true
        ViewButtonCancel.addGestureRecognizer(tapGestureRecognizerCancelView)
        
        //Return
        let tapGestureRecognizerReturnView = UITapGestureRecognizer(target: self, action: #selector(ReturnView(tapGestureRecognizer:)))
        ViewButtonReturn.isUserInteractionEnabled = true
        ViewButtonReturn.addGestureRecognizer(tapGestureRecognizerReturnView)
        
        //Approve
        let tapGestureRecognizerApproveView = UITapGestureRecognizer(target: self, action: #selector(ApproveView(tapGestureRecognizer:)))
        ViewButtonApprove.isUserInteractionEnabled = true
        ViewButtonApprove.addGestureRecognizer(tapGestureRecognizerApproveView)
        
        
        //Submit
        let tapGestureRecognizerSubmitView = UITapGestureRecognizer(target: self, action: #selector(SubmitView(tapGestureRecognizer:)))
        ViewButtonSubmit.isUserInteractionEnabled = true
        ViewButtonSubmit.addGestureRecognizer(tapGestureRecognizerSubmitView)
        
        //Save
        let tapGestureRecognizerSaveView = UITapGestureRecognizer(target: self, action: #selector(SaveView(tapGestureRecognizer:)))
        ViewButtonSave.isUserInteractionEnabled = true
        ViewButtonSave.addGestureRecognizer(tapGestureRecognizerSaveView)
        
        
        //-------Default making all buttons visibility false
        ViewButtonCancel.isHidden = true
        ViewButtonSave.isHidden = true
        ViewButtonSubmit.isHidden = true
        ViewButtonApprove.isHidden = true
        ViewButtonReturn.isHidden = true
        
        LoadButtons() //---to load buttons according to conditions
        
        /*ViewButtonSubmit.isUserInteractionEnabled = false
        ViewButtonSubmit.alpha = 0.6
        
        ViewButtonSave.isUserInteractionEnabled = false
        ViewButtonSave.alpha = 0.6
        
        ButtonReasonIsSelected = false
        btn_reason_select_type.alpha = 0.6
        
        TxtReturnPeriod.isUserInteractionEnabled = false
        TxtReturnPeriod.alpha = 0.6*/
    }
    
    //---Back
    @objc func BackView(tapGestureRecognizer: UITapGestureRecognizer){
        if AdvanceRequisitionListViewController.EmployeeType == "Employee"{
//            self.performSegue(withIdentifier: "advancehome", sender: nil)
            if AdvanceRequisitionListViewController.new_create_yn == true {
                OpenAlertPopup()
            }else{
                AdvanceRequisitionListViewController.new_create_yn = false
                self.performSegue(withIdentifier: "advancehome", sender: self)
            }
        }
        if AdvanceRequisitionListViewController.EmployeeType == "Supervisor"{
            self.performSegue(withIdentifier: "subordinate", sender: nil)
        }
    }
    
    
    //===============Alert(Cancel/Yes) Confirmation Popup code starts===================
    @IBOutlet weak var ViewBtnAlertPopupYesDashboard: UIView!
    @IBOutlet weak var ViewBtnPopupYesList: UIView!
    @IBOutlet weak var ViewBtnPopupNo: UIView!
    
    @IBOutlet weak var stackViewAlertPopupButton: UIStackView!
    @IBOutlet var ViewAlert: UIView!
    func OpenAlertPopup(){
        blurEffect()
        self.view.addSubview(ViewAlert)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        ViewAlert.layer.masksToBounds = true
        ViewAlert.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        ViewAlert.center = self.view.center
        ViewAlert.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        ViewAlert.alpha = 0
        ViewAlert.sizeToFit()
        
        stackViewAlertPopupButton.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
//        view_custom_btn_punchout.addBorder(side: .top, color: UIColor(hexFromString: "4f4f4f"), width: 1)
//        btnPopupCancel.titleLabel?.textColor = .black
        ViewBtnPopupYesList.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        ViewBtnPopupNo.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        
        UIView.animate(withDuration: 0.3){
            self.ViewAlert.alpha = 1
            self.ViewAlert.transform = CGAffineTransform.identity
        }
        
        
        //        self.confidencelabel.text = confidence!
        //----onClick go to dashboard
        let tapGestureRecognizerYesDashboard = UITapGestureRecognizer(target: self, action: #selector(onClickYeshDashboard(tapGestureRecognizer:)))
        ViewBtnAlertPopupYesDashboard.isUserInteractionEnabled = true
//        custom_btn_label_save.alpha = 0.6
        ViewBtnAlertPopupYesDashboard.addGestureRecognizer(tapGestureRecognizerYesDashboard)
        
        //---onClick go to list
        let tapGestureRecognizerYesList = UITapGestureRecognizer(target: self, action: #selector(onClickYesList(tapGestureRecognizer:)))
        ViewBtnPopupYesList.isUserInteractionEnabled = true
        ViewBtnPopupYesList.addGestureRecognizer(tapGestureRecognizerYesList)
        
        //---onClick stay on current page
        let tapGestureRecognizerAlertNo = UITapGestureRecognizer(target: self, action: #selector(onClickAlertPopupNo(tapGestureRecognizer:)))
        ViewBtnPopupNo.isUserInteractionEnabled = true
        ViewBtnPopupNo.addGestureRecognizer(tapGestureRecognizerAlertNo)
        
    }
    func CloseAlertPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewAlert.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ViewAlert.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.ViewAlert.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    @objc func onClickYesList(tapGestureRecognizer: UITapGestureRecognizer){
        AdvanceRequisitionListViewController.new_create_yn = false
        self.performSegue(withIdentifier: "advancehome", sender: self)
        CloseAlertPopup()
    }
    @objc func onClickYeshDashboard(tapGestureRecognizer: UITapGestureRecognizer){
        AdvanceRequisitionListViewController.new_create_yn = false
        CloseAlertPopup()
        self.performSegue(withIdentifier: "dboard", sender: self)
    }
    @objc func onClickAlertPopupNo(tapGestureRecognizer: UITapGestureRecognizer){
        CloseAlertPopup()
    }
    //===============Alert(Cancel/Yes) Confirmation Popup code ends===================
    //---Cancel
    @objc func CancelView(tapGestureRecognizer: UITapGestureRecognizer){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = formatter.string(from: date)
        
        SaveData(requisition_id: AdvanceRequisitionListViewController.requisition_id!, requisition_date: AdvanceRequisitionListViewController.requisition_date!, employee_id: AdvanceRequisitionListViewController.employee_id!, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Canceled", approved_requisition_amount: Double(TxtApprovedAmount.text!), approved_by_id: swiftyJsonvar1["employee"]["employee_id"].intValue, approved_date: CurrentDate, supervisor_remark: TxtViewApprovalRemark.text!, supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
    }
    //---Return
    @objc func ReturnView(tapGestureRecognizer: UITapGestureRecognizer){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = formatter.string(from: date)
        
        SaveData(requisition_id: AdvanceRequisitionListViewController.requisition_id!, requisition_date: AdvanceRequisitionListViewController.requisition_date!, employee_id: AdvanceRequisitionListViewController.employee_id!, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Returned", approved_requisition_amount: Double(TxtApprovedAmount.text!), approved_by_id: swiftyJsonvar1["employee"]["employee_id"].intValue, approved_date: CurrentDate, supervisor_remark: TxtViewApprovalRemark.text!, supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
    }
    //---Approve
    @objc func ApproveView(tapGestureRecognizer: UITapGestureRecognizer){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = formatter.string(from: date)
        
        SaveData(requisition_id: AdvanceRequisitionListViewController.requisition_id!, requisition_date: AdvanceRequisitionListViewController.requisition_date!, employee_id: AdvanceRequisitionListViewController.employee_id!, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Approved", approved_requisition_amount: Double(TxtApprovedAmount.text!), approved_by_id: swiftyJsonvar1["employee"]["employee_id"].intValue, approved_date: CurrentDate, supervisor_remark: TxtViewApprovalRemark.text!, supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
    }
    //---Submit
    @objc func SubmitView(tapGestureRecognizer: UITapGestureRecognizer){
        if AdvanceRequisitionListViewController.new_create_yn == true{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = formatter.string(from: date)
        
        SaveData(requisition_id: 0, requisition_date: CurrentDate, employee_id: swiftyJsonvar1["employee"]["employee_id"].intValue, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Submitted", approved_requisition_amount: 0, approved_by_id: 0, approved_date: "", supervisor_remark: "", supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
        }
        if AdvanceRequisitionListViewController.new_create_yn == false{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let CurrentDate = formatter.string(from: date)
            
            SaveData(requisition_id: AdvanceRequisitionListViewController.requisition_id!, requisition_date: CurrentDate, employee_id: swiftyJsonvar1["employee"]["employee_id"].intValue, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Submitted", approved_requisition_amount: 0, approved_by_id: 0, approved_date: "", supervisor_remark: "", supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
        }
    }
    //---Save
    @objc func SaveView(tapGestureRecognizer: UITapGestureRecognizer){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = formatter.string(from: date)
        
//        SaveData(requisition_id: 0, requisition_date: CurrentDate, employee_id: swiftyJsonvar1["employee"]["employee_id"].intValue, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Saved", approved_requisition_amount: 0, approved_by_id: 0, approved_date: "", supervisor_remark: "", supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
        if AdvanceRequisitionListViewController.new_create_yn == true{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let CurrentDate = formatter.string(from: date)
        
        SaveData(requisition_id: 0, requisition_date: CurrentDate, employee_id: swiftyJsonvar1["employee"]["employee_id"].intValue, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Saved", approved_requisition_amount: 0, approved_by_id: 0, approved_date: "", supervisor_remark: "", supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
        }
        if AdvanceRequisitionListViewController.new_create_yn == false{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let CurrentDate = formatter.string(from: date)
            
            SaveData(requisition_id: AdvanceRequisitionListViewController.requisition_id!, requisition_date: CurrentDate, employee_id: swiftyJsonvar1["employee"]["employee_id"].intValue, requisition_reason: AdvanceRequisitionRequestViewController.RequisitionReason, requisition_amount: Double(TxtRequisitionAmount.text!), description: TxtViewNarration.text!, ctc_amount: Double(TxtCtc.text!), return_period_in_months: Int(TxtReturnPeriod.text!), requisition_status: "Saved", approved_requisition_amount: 0, approved_by_id: 0, approved_date: "", supervisor_remark: "", supervisor1_id: swiftyJsonvar1["employee"]["supervisor_1"].intValue, supervisor2_id: swiftyJsonvar1["employee"]["supervisor_2"].intValue )
        }
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        if AdvanceRequisitionListViewController.EmployeeType == "Employee"{
//            self.performSegue(withIdentifier: "advancehome", sender: nil)
            if AdvanceRequisitionListViewController.new_create_yn == true {
                OpenAlertPopup()
            }else{
                AdvanceRequisitionListViewController.new_create_yn = false
                self.performSegue(withIdentifier: "advancehome", sender: self)
            }
        }
        if AdvanceRequisitionListViewController.EmployeeType == "Supervisor"{
            self.performSegue(withIdentifier: "subordinate", sender: nil)
        }
    }
    
    @IBAction func BtnDropDownSelect(_ sender: UIButton) {
        /*ButtonReasonIsSelected = true
        btn_reason_select_type.alpha = 1.0*/
        
        /*TxtReturnPeriod.isUserInteractionEnabled = true
        TxtReturnPeriod.alpha = 1.0*/
        
        dropDown.dataSource = type
        dropDown.anchorView = sender//5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height+10) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            if item.contains("i)"){
                sender.setTitle(item.replacingOccurrences(of: "i) ", with: "", options: .literal, range: nil), for: .normal) //9
            }
            if item.contains("ii)"){
                sender.setTitle(item.replacingOccurrences(of: "ii) ", with: "", options: .literal, range: nil), for: .normal) //9
            }
            if item.contains("iii)"){
                sender.setTitle(item.replacingOccurrences(of: "iii) ", with: "", options: .literal, range: nil), for: .normal) //9
            }
            if item.contains("iv)"){
                sender.setTitle(item.replacingOccurrences(of: "iv) ", with: "", options: .literal, range: nil), for: .normal) //9
            }
            //          sender.setTitle(item, for: .normal) //9
            print("indexCheck-=>",index+1)
            if index >= 0 {
                self!.TxtReturnPeriod.isUserInteractionEnabled = true
                self!.TxtReturnPeriod.alpha = 1.0
                
                self!.ButtonReasonIsSelected = true
                self!.btn_reason_select_type.alpha = 1.0
            }else{
                self!.TxtReturnPeriod.isUserInteractionEnabled = false
                self!.TxtReturnPeriod.alpha = 0.6
                
                self!.ButtonReasonIsSelected = false
                self!.btn_reason_select_type.alpha = 0.6
            }
            AdvanceRequisitionRequestViewController.RequisitionReason = index+1
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
        }
    }
    
    //-----textfield delegate, starts
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if TxtRequisitionAmount.text != "" && TxtReturnPeriod.text != "" && ButtonReasonIsSelected == true{
            ViewButtonSubmit.isUserInteractionEnabled = true
            ViewButtonSubmit.alpha = 1.0
            
            ViewButtonSave.isUserInteractionEnabled = true
            ViewButtonSave.alpha = 1.0
        }
            return true;
        }*/
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField{
        case self.TxtRequisitionAmount:
            if Double(TxtRequisitionAmount.text!) ?? 0 > 0 {
                btn_reason_select_type.isUserInteractionEnabled = true
                btn_reason_select_type.alpha = 1.0
                if AdvanceRequisitionListViewController.requisition_status != ""{
                    ViewButtonSubmit.isUserInteractionEnabled = true
                    ViewButtonSubmit.alpha = 1.0
                    ViewButtonSave.isUserInteractionEnabled = true
                    ViewButtonSave.alpha = 1.0
                }
                if TxtRequisitionAmount.text != "" && TxtReturnPeriod.text != "" && ButtonReasonIsSelected == true{
                    ViewButtonSubmit.isUserInteractionEnabled = true
                    ViewButtonSubmit.alpha = 1.0
                    
                    ViewButtonSave.isUserInteractionEnabled = true
                    ViewButtonSave.alpha = 1.0
                }
                
            }else if Double(TxtRequisitionAmount.text!) ?? 0 == 0 {
                ViewButtonSubmit.isUserInteractionEnabled = false
                ViewButtonSubmit.alpha = 0.6
                ViewButtonSave.isUserInteractionEnabled = false
                ViewButtonSave.alpha = 0.6
                
            }else{
                ViewButtonSubmit.isUserInteractionEnabled = false
                ViewButtonSubmit.alpha = 0.6
                ViewButtonSave.isUserInteractionEnabled = false
                ViewButtonSave.alpha = 0.6
            }
            break
         
        case self.btn_reason_select_type:
            /*TxtReturnPeriod.isUserInteractionEnabled = true
            TxtReturnPeriod.alpha = 1.0*/
            if AdvanceRequisitionListViewController.requisition_status != ""{
                ViewButtonSubmit.isUserInteractionEnabled = true
                ViewButtonSubmit.alpha = 1.0
                ViewButtonSave.isUserInteractionEnabled = true
                ViewButtonSave.alpha = 1.0
            }
            break
        case self.TxtReturnPeriod:
            if Double(TxtReturnPeriod.text!) ?? 0 > 0 {
                ViewButtonSubmit.isUserInteractionEnabled = true
                ViewButtonSubmit.alpha = 1.0
                ViewButtonSave.isUserInteractionEnabled = true
                ViewButtonSave.alpha = 1.0
            }else if Double(TxtReturnPeriod.text!) ?? 0 == 0 {
                ViewButtonSubmit.isUserInteractionEnabled = false
                ViewButtonSubmit.alpha = 0.6
                ViewButtonSave.isUserInteractionEnabled = false
                ViewButtonSave.alpha = 0.6
                
            }else{
                ViewButtonSubmit.isUserInteractionEnabled = false
                ViewButtonSubmit.alpha = 0.6
                ViewButtonSave.isUserInteractionEnabled = false
                ViewButtonSave.alpha = 0.6
            }
            break
        case self.TxtApprovedAmount:
            if Double(TxtApprovedAmount.text!)! > 0 {
                if Double(TxtApprovedAmount.text!)! > Double(TxtRequisitionAmount.text!)! {
                    ViewButtonApprove.isUserInteractionEnabled = false
                    ViewButtonApprove.alpha = 0.6
                }else {
                    ViewButtonApprove.isUserInteractionEnabled = true
                    ViewButtonApprove.alpha = 1.0
                }
            }else{
                ViewButtonApprove.isUserInteractionEnabled = false
                ViewButtonApprove.alpha = 0.6
            }
            break
      /*  case self.TxtApprovedAmount:
            if Double(TxtApprovedAmount.text!)! > 0 {
                if Double(TxtApprovedAmount.text!)! > Double(TxtMediclaimAmount.text!)! {
                    ViewBtnApprove.isUserInteractionEnabled = false
                    ViewBtnApprove.alpha = 0.6
                }else {
                    ViewBtnApprove.isUserInteractionEnabled = true
                    ViewBtnApprove.alpha = 1.0
                }
            }else{
                ViewBtnApprove.isUserInteractionEnabled = false
                ViewBtnApprove.alpha = 0.6
            }
            break*/
        
        default:
            break
        }
    }
    //-----textfield delegate, ends
    //----function to load buttons acc to the logic, code starts
    func LoadButtons(){
        StackViewButtons.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewButtonCancel.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewButtonReturn.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewButtonApprove.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewButtonSubmit.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewButtonSave.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        
        if AdvanceRequisitionListViewController.EmployeeType == "Employee"{
            LabelNavBarTitle.text = "My Advance Requisition"
            btn_reason_select_type.isUserInteractionEnabled = true
            btn_reason_select_type.alpha = 1.0
            
            TxtApprovedAmount.isUserInteractionEnabled = false
            TxtApprovedAmount.alpha = 0.6
            TxtViewApprovalRemark.isUserInteractionEnabled = false
            TxtViewApprovalRemark.alpha = 0.6
            if AdvanceRequisitionListViewController.requisition_status == ""{
                ViewButtonSubmit.isUserInteractionEnabled = false
                ViewButtonSubmit.alpha = 0.6
                ViewButtonSave.isUserInteractionEnabled = false
                ViewButtonSave.alpha = 0.6
                
                
                ViewButtonCancel.isHidden = true
                ViewButtonSave.isHidden = false
                ViewButtonSubmit.isHidden = false
                ViewButtonApprove.isHidden = true
                ViewButtonReturn.isHidden = true
                
                TxtRequisitionAmount.isUserInteractionEnabled = true
                TxtViewNarration.isUserInteractionEnabled = true
                TxtReturnPeriod.isUserInteractionEnabled = false
                TxtReturnPeriod.alpha = 0.6
                btn_reason_select_type.isUserInteractionEnabled = false
                btn_reason_select_type.alpha = 0.6
                
//                TxtApprovedAmount.isUserInteractionEnabled = false
//                TxtViewApprovalRemark.isUserInteractionEnabled = false
                
            }
            if AdvanceRequisitionListViewController.requisition_status == "Saved"{
                ViewButtonSubmit.isUserInteractionEnabled = true
                ViewButtonSubmit.alpha = 1.0
                ViewButtonSave.isUserInteractionEnabled = true
                ViewButtonSave.alpha = 1.0
                
                ViewButtonCancel.isHidden = true
                ViewButtonSave.isHidden = false
                ViewButtonSubmit.isHidden = false
                ViewButtonApprove.isHidden = true
                ViewButtonReturn.isHidden = true
                
                TxtRequisitionAmount.isUserInteractionEnabled = true
                TxtViewNarration.isUserInteractionEnabled = true
                TxtReturnPeriod.isUserInteractionEnabled = true
                TxtReturnPeriod.alpha = 1.0
                btn_reason_select_type.isUserInteractionEnabled = true
                btn_reason_select_type.alpha = 1.0
                
//                TxtApprovedAmount.isUserInteractionEnabled = false
//                TxtViewApprovalRemark.isUserInteractionEnabled = false
            }
            if AdvanceRequisitionListViewController.requisition_status == "Submitted" ||
                AdvanceRequisitionListViewController.requisition_status == "Approved" ||
                AdvanceRequisitionListViewController.requisition_status == "Payment done" ||
                AdvanceRequisitionListViewController.requisition_status == "Canceled"{
                
                ViewButtonCancel.isHidden = true
                ViewButtonSave.isHidden = true
                ViewButtonSubmit.isHidden = true
                ViewButtonApprove.isHidden = true
                ViewButtonReturn.isHidden = true
                
                TxtRequisitionAmount.isUserInteractionEnabled = false
                TxtRequisitionAmount.alpha = 0.6
                TxtViewNarration.isUserInteractionEnabled = false
                TxtViewNarration.alpha = 0.6
                TxtReturnPeriod.isUserInteractionEnabled = false
                TxtReturnPeriod.alpha = 0.6
                btn_reason_select_type.isUserInteractionEnabled = false
                btn_reason_select_type.alpha = 0.6
                
                
//                TxtApprovedAmount.isUserInteractionEnabled = false
//                TxtViewApprovalRemark.isUserInteractionEnabled = false
            }
            if AdvanceRequisitionListViewController.requisition_status == "Returned"{
                
                ViewButtonSubmit.isUserInteractionEnabled = true
                ViewButtonSubmit.alpha = 1.0
                ViewButtonSave.isUserInteractionEnabled = true
                ViewButtonSave.alpha = 1.0
                
                ViewButtonCancel.isHidden = true
                ViewButtonSave.isHidden = true
                ViewButtonSubmit.isHidden = false
                ViewButtonApprove.isHidden = true
                ViewButtonReturn.isHidden = true
                
                TxtRequisitionAmount.isUserInteractionEnabled = true
                TxtViewNarration.isUserInteractionEnabled = true
                TxtReturnPeriod.isUserInteractionEnabled = true
                
//                TxtApprovedAmount.isUserInteractionEnabled = false
//                TxtViewApprovalRemark.isUserInteractionEnabled = false
            }
        }
        if AdvanceRequisitionListViewController.EmployeeType == "Supervisor"{
            LabelNavBarTitle.text = "Subordinate Advance Requisition"
            btn_reason_select_type.isUserInteractionEnabled = false
            btn_reason_select_type.alpha = 0.6
            
            TxtRequisitionAmount.isUserInteractionEnabled = false
            TxtRequisitionAmount.alpha = 0.6
            TxtViewNarration.isUserInteractionEnabled = false
            TxtViewNarration.alpha = 0.6
            TxtReturnPeriod.isUserInteractionEnabled = false
            TxtReturnPeriod.alpha = 0.6
            
            if AdvanceRequisitionListViewController.requisition_status == "Submitted"{
                ViewButtonCancel.isHidden = false
                ViewButtonSave.isHidden = true
                ViewButtonSubmit.isHidden = true
                ViewButtonApprove.isHidden = false
                ViewButtonReturn.isHidden = false
                
               
                
                TxtApprovedAmount.isUserInteractionEnabled = true
                TxtApprovedAmount.alpha = 1.0
                TxtViewApprovalRemark.isUserInteractionEnabled = true
                TxtViewApprovalRemark.alpha = 1.0
            }
            if AdvanceRequisitionListViewController.requisition_status == "Returned" ||
                AdvanceRequisitionListViewController.requisition_status == "Approved" ||
                AdvanceRequisitionListViewController.requisition_status == "Payment done" ||
                AdvanceRequisitionListViewController.requisition_status == "Canceled"{
                
                ViewButtonCancel.isHidden = true
                ViewButtonSave.isHidden = true
                ViewButtonSubmit.isHidden = true
                ViewButtonApprove.isHidden = true
                ViewButtonReturn.isHidden = true
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtApprovedAmount.alpha = 0.6
                TxtViewApprovalRemark.isUserInteractionEnabled = false
                TxtViewApprovalRemark.alpha = 0.6
            }
        }
    }
    //----function to load buttons acc to the logic, code ends
    
    //-----function to save data, code starts---
    func SaveData(requisition_id: Int!, requisition_date: String!, employee_id: Int!, requisition_reason: Int!, requisition_amount: Double!, description: String!, ctc_amount: Double!, return_period_in_months: Int!, requisition_status: String!, approved_requisition_amount: Double!, approved_by_id: Int!, approved_date: String!, supervisor_remark: String!, supervisor1_id: Int!, supervisor2_id: Int!){
        let url = "\(BASE_URL)advance-requisition/save"
        print("save_url_advancereq-=>",url)
//        swiftyJsonvar1["employee"]["employee_id"].stringValue
        
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "requisition_id": requisition_id!,
            "requisition_date": requisition_date!,
            "employee_id": employee_id!,
            "requisition_reason": requisition_reason!,
            "requisition_amount": requisition_amount!,
            "description": description!,
            "ctc_amount": ctc_amount!,
            "return_period_in_months": return_period_in_months!,
            "requisition_status": requisition_status!,
            "approved_requisition_amount": approved_requisition_amount!,
            "approved_by_id": approved_by_id!,
            "approved_date": approved_date!,
            "supervisor_remark": supervisor_remark!,
            "supervisor1_id": supervisor1_id!,
            "supervisor2_id": supervisor2_id!
        ]
        
        print("SentData-=>",sentData)
                
                AF.request(url, method: .post, parameters: sentData, encoding: JSONEncoding.default, headers: nil).responseJSON{
                    response in
                    switch response.result{
                        
                    case .success:
    //                        self.loaderEnd()
                        let swiftyJsonVar = JSON(response.value!)
                        print("Return saved data: ", swiftyJsonVar)
                    
                        if swiftyJsonVar["status"].stringValue == "true"{
                            // Create new Alert
                            var dialogMessage = UIAlertController(title: "", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
    //                                print("Ok button tapped")
//                                self.performSegue(withIdentifier: "outdoordutylist", sender: nil)
                                if AdvanceRequisitionListViewController.EmployeeType == "Employee"{
                                    self.performSegue(withIdentifier: "advancehome", sender: nil)
                                }
                                if AdvanceRequisitionListViewController.EmployeeType == "Supervisor"{
                                    self.performSegue(withIdentifier: "subordinate", sender: nil)
                                }
                             })
                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)

                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                        }else{
                            var style = ToastStyle()
                            
                            // this is just one of many style options
                            style.messageColor = .white
                            
                            // present the toast with the new style
                            self.view.makeToast(swiftyJsonVar["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                        }
   
                        break
                        
                    case .failure(let error):
    //                        self.loaderEnd()
                        print("Error: ", error)
                    }
                }
    }

    //-----function to save data, code ends---
   
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


//---code to set max limit option inside stoyboard at textfield section, starts-----
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
//---code to set max limit option inside stoyboard at textfield section, ends-----


