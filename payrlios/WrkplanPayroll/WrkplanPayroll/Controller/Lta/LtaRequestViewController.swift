//
//  LtaRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 14/07/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class LtaRequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var TxtLtaRequisitionNo: UITextField!
    @IBOutlet weak var TxtEmpName: UITextField!
    @IBOutlet weak var TxtFromYrLtaLimit: UITextField!
    @IBOutlet weak var TxtToYearLtaLimit: UITextField!
    @IBOutlet weak var TxtTotalLtaAmount: UITextField!
    @IBOutlet weak var TxtRemainingLtaAmount: UITextField!
    @IBOutlet weak var TxtLtaAmount: UITextField!
    @IBOutlet weak var TxtViewDetail: UITextView!
    @IBOutlet weak var TxtFromDate: UITextField!
    @IBOutlet weak var ImgFromDate: UIImageView!
    @IBOutlet weak var TxtToDate: UITextField!
    @IBOutlet weak var ImgToDate: UIImageView!
    @IBOutlet weak var LabelDayCount: UILabel!
    @IBOutlet weak var LabelWarningTitle: UILabel!
    @IBOutlet weak var TxtSupportingDocuments: UITextField!
    @IBOutlet weak var ViewSupportingDocuments: UIView!
    @IBOutlet weak var TxtRequisitionStatus: UITextField!
    @IBOutlet weak var TxtApprovedAmount: UITextField!
    @IBOutlet weak var TxtViewSupervisorRemark: UITextView!
    @IBOutlet weak var TxtViewFinalSupervisorRemark: UITextView!
    @IBOutlet weak var ViewBtnCancel: UIView!
    @IBOutlet weak var ViewBtnReturn: UIView!
    @IBOutlet weak var ViewBtnApprove: UIView!
    @IBOutlet weak var ViewBtnSubmit: UIView!
    @IBOutlet weak var ViewBtnSave: UIView!
    @IBOutlet weak var ViewBtnBack: UIView!
    @IBOutlet weak var StackViewButtons: UIStackView!
    
    var from_date: Bool = false
    var to_date: Bool = false
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        //---code for date section, starts
        TxtFromDate.delegate = self
        TxtToDate.delegate = self
        TxtFromDate.isUserInteractionEnabled = true
        TxtToDate.isUserInteractionEnabled = false
        TxtFromDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        TxtToDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        //---code for date section, ends
        
        TxtLtaRequisitionNo.isUserInteractionEnabled = false
        TxtEmpName.isUserInteractionEnabled = false
        TxtFromYrLtaLimit.isUserInteractionEnabled = false
        TxtToYearLtaLimit.isUserInteractionEnabled = false
        TxtTotalLtaAmount.isUserInteractionEnabled = false
        TxtRemainingLtaAmount.isUserInteractionEnabled = false
        TxtRequisitionStatus.isUserInteractionEnabled = false
        TxtSupportingDocuments.isUserInteractionEnabled = false
        
        TxtLtaRequisitionNo.setLeftPaddingPoints(5)
        TxtEmpName.setLeftPaddingPoints(5)
        TxtFromYrLtaLimit.setRightPaddingPoints(5)
        TxtToYearLtaLimit.setRightPaddingPoints(5)
        TxtLtaAmount.setRightPaddingPoints(5)
        TxtFromYrLtaLimit.setRightPaddingPoints(5)
        TxtTotalLtaAmount.setRightPaddingPoints(5)
        TxtRemainingLtaAmount.setRightPaddingPoints(5)
        TxtLtaAmount.setRightPaddingPoints(5)
        TxtViewDetail.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        TxtFromDate.setLeftPaddingPoints(5)
        TxtToDate.setLeftPaddingPoints(5)
        TxtSupportingDocuments.setLeftPaddingPoints(5)
        TxtRequisitionStatus.setLeftPaddingPoints(5)
        TxtApprovedAmount.setRightPaddingPoints(5)
        TxtViewSupervisorRemark.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        TxtViewFinalSupervisorRemark.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        //-----code to add button border, starts------
        StackViewButtons.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnCancel.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnReturn.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnApprove.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnSubmit.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnSave.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewSupportingDocuments.addBorder(side: .left, color: UIColor(hexFromString: "000000"), width: 0.6)
        //-----code to add button border, ends------
        
        if LtaListViewController.new_create_yn == true {
            ViewBtnSave.isHidden = false
            ViewBtnSubmit.isHidden = false
            ViewBtnCancel.isHidden = true
            ViewBtnApprove.isHidden = true
            ViewBtnReturn.isHidden = true
            ImgFromDate.isHidden = false
            ImgToDate.isHidden = false
            
            TxtLtaAmount.isUserInteractionEnabled = true
            TxtViewDetail.isUserInteractionEnabled = true
            TxtFromDate.isUserInteractionEnabled = true
            TxtToDate.isUserInteractionEnabled = true
            
            TxtApprovedAmount.isUserInteractionEnabled = false
            TxtViewSupervisorRemark.isUserInteractionEnabled = false
            TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
            
            ViewSupportingDocuments.isUserInteractionEnabled = true
            ViewSupportingDocuments.alpha = 1.0
        } else if LtaListViewController.new_create_yn == false {
            LoadButtons()
        }
        
        
        //ViewBack
        let tapGestureRecognizerBackView = UITapGestureRecognizer(target: self, action: #selector(BackView(tapGestureRecognizer:)))
        ViewBtnBack.isUserInteractionEnabled = true
        ViewBtnBack.addGestureRecognizer(tapGestureRecognizerBackView)
        
    }
    
    //---ViewBack
    @objc func BackView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
        
    }

    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
    }
    
    
    //-----Code for calendarDate selection, starts-----
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case self.TxtFromDate:
            from_date = true
            to_date = false
            showDatePicker(txtfield: TxtFromDate)
            TxtToDate.isUserInteractionEnabled = true
            print("from date tapped")
            break
        case self.TxtToDate:
            
            if TxtFromDate.text == "" {
                to_date = false
                
                
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                
                // present the toast with the new style
                self.view.makeToast("Please select From Date", duration: 3.0, position: .bottom, style: style)
            }else{
                to_date = true
                from_date = false
                
            showDatePicker(txtfield: TxtToDate)
            }
            break
        default:
            break
        }
    }
    
    //-----Date picker code starts
    let datePicker = UIDatePicker()
    func showDatePicker(txtfield: UITextField){
        //Formate Date
        datePicker.datePickerMode = .date

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

      txtfield.inputAccessoryView = toolbar
      txtfield.inputView = datePicker

     }

    @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MMM-yyyy"
        if from_date == true {
       TxtFromDate.text = formatter.string(from: datePicker.date)
        }
        if to_date == true{
            TxtToDate.text = formatter.string(from: datePicker.date)
            print("test-=>",daysBetween(start: TxtFromDate.text!, end: TxtToDate.text!))
            LabelDayCount.text = String(daysBetween(start: TxtFromDate.text!, end: TxtToDate.text!)+1)
            
            if (daysBetween(start: TxtFromDate.text!, end: TxtToDate.text!)+1) <= 0 {
//                ViewBtnSave.isEnabled = false
                ViewBtnSave.isUserInteractionEnabled = false
                ViewBtnSave.alpha = 0.6
                
                ViewBtnSubmit.isUserInteractionEnabled = false
                ViewBtnSubmit.alpha = 0.6
            }else{
//                custom_btn_label_save.isEnabled = true
                ViewBtnSave.isUserInteractionEnabled = true
                ViewBtnSave.alpha = 1.0
                
                ViewBtnSubmit.isUserInteractionEnabled = true
                ViewBtnSubmit.alpha = 1.0
            }
//            daysBetween(start: txt_from_date.text!, end: txt_to_date.text!)
        }
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
       
    
   
    
    //-----Date picker code ends
    
    
    //--code to get day count starts
    func daysBetween(start: String, end: String) -> Int {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        // specify the format,
        formatter.dateFormat = "dd/MM/yyyy"
        // specify the start date
        let startDate = formatter.date(from: start)
        // specify the end date
        let endDate = formatter.date(from: end)
        print(startDate!)
        print(endDate!)
        let diff = calendar.dateComponents([.day], from: startDate!, to: endDate!).day ?? 0
        
        return diff
//        print("test-=>",diff)
       
        }
    //--code to get day count ends
    
    //-----Code for calendarDate selection, ends-----
    
    
    //----function to load buttons acc to the logic, code starts
    func LoadButtons(){
        
        if LtaListViewController.EmployeeType == "Employee"{
//            LabelNavBarTitle.text = "My Advance Requisition"
//            btn_reason_select_type.isUserInteractionEnabled = true
//            btn_reason_select_type.alpha = 1.0
            if LtaListViewController.lta_status! == ""{
                
                
                
                ViewBtnSave.isHidden = false
                ViewBtnSubmit.isHidden = false
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                ImgFromDate.isHidden = false
                ImgToDate.isHidden = false
                
                TxtLtaAmount.isUserInteractionEnabled = true
                TxtViewDetail.isUserInteractionEnabled = true
                TxtFromDate.isUserInteractionEnabled = true
                TxtToDate.isUserInteractionEnabled = true
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewSupervisorRemark.isUserInteractionEnabled = false
                TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
                
                ViewSupportingDocuments.isUserInteractionEnabled = true
                ViewSupportingDocuments.alpha = 1.0
                
                
                
            }
            if LtaListViewController.lta_status! == "Saved"{
                
                ViewBtnSave.isHidden = false
                ViewBtnSubmit.isHidden = false
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                ImgFromDate.isHidden = false
                ImgToDate.isHidden = false
                
                TxtLtaAmount.isUserInteractionEnabled = true
                TxtViewDetail.isUserInteractionEnabled = true
                TxtFromDate.isUserInteractionEnabled = true
                TxtToDate.isUserInteractionEnabled = true
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewSupervisorRemark.isUserInteractionEnabled = false
                TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
                
                ViewSupportingDocuments.isUserInteractionEnabled = true
                ViewSupportingDocuments.alpha = 1.0
            }
            if LtaListViewController.lta_status! == "Submitted" ||
                LtaListViewController.lta_status! == "Approved" ||
                LtaListViewController.lta_status! == "Payment done" ||
                LtaListViewController.lta_status! == "Canceled"{
                
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = true
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                ImgFromDate.isHidden = true
                ImgToDate.isHidden = true
                
                TxtLtaAmount.isUserInteractionEnabled = false
                TxtViewDetail.isUserInteractionEnabled = false
                TxtFromDate.isUserInteractionEnabled = false
                TxtToDate.isUserInteractionEnabled = false
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewSupervisorRemark.isUserInteractionEnabled = false
                TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
                
                ViewSupportingDocuments.isUserInteractionEnabled = true
                ViewSupportingDocuments.alpha = 1.0
            }
            if LtaListViewController.lta_status! == "Returned"{
           
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = false
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                ImgFromDate.isHidden = false
                ImgToDate.isHidden = false
                
                TxtLtaAmount.isUserInteractionEnabled = true
                TxtViewDetail.isUserInteractionEnabled = true
                TxtFromDate.isUserInteractionEnabled = true
                TxtToDate.isUserInteractionEnabled = true
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewSupervisorRemark.isUserInteractionEnabled = false
                TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
                
                ViewSupportingDocuments.isUserInteractionEnabled = true
                ViewSupportingDocuments.alpha = 1.0
            }
        }
        if LtaListViewController.lta_status! == "Supervisor"{
//            LabelNavBarTitle.text = "Subordinate Advance Requisition"
//            btn_reason_select_type.isUserInteractionEnabled = false
//            btn_reason_select_type.alpha = 0.6
            if LtaListViewController.lta_status! == "Submitted"{
            
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = true
                ViewBtnCancel.isHidden = false
                ViewBtnApprove.isHidden = false
                ViewBtnReturn.isHidden = false
                ImgFromDate.isHidden = true
                ImgToDate.isHidden = true
                
                TxtLtaAmount.isUserInteractionEnabled = false
                TxtViewDetail.isUserInteractionEnabled = false
                TxtFromDate.isUserInteractionEnabled = false
                TxtToDate.isUserInteractionEnabled = false
                
                TxtApprovedAmount.isUserInteractionEnabled = true
                TxtViewSupervisorRemark.isUserInteractionEnabled = true
                TxtViewFinalSupervisorRemark.isUserInteractionEnabled = true
                
                ViewSupportingDocuments.isUserInteractionEnabled = true
                ViewSupportingDocuments.alpha = 1.0
            }
            if LtaListViewController.lta_status! == "Returned" ||
                LtaListViewController.lta_status! == "Approved" ||
                LtaListViewController.lta_status! == "Payment done" ||
                LtaListViewController.lta_status! == "Canceled"{
                
              
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = true
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                ImgFromDate.isHidden = true
                ImgToDate.isHidden = true
                
                TxtLtaAmount.isUserInteractionEnabled = false
                TxtViewDetail.isUserInteractionEnabled = false
                TxtFromDate.isUserInteractionEnabled = false
                TxtToDate.isUserInteractionEnabled = false
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewSupervisorRemark.isUserInteractionEnabled = false
                TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
                
                ViewSupportingDocuments.isUserInteractionEnabled = true
                ViewSupportingDocuments.alpha = 1.0
            }
        }
        
        
    }
    //----function to load buttons acc to the logic, code ends

}
