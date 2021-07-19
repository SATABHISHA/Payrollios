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
    @IBOutlet weak var StackViewButtons: UIStackView!
    
    var from_date: Bool = false
    var to_date: Bool = false
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        TxtFromDate.delegate = self
        TxtToDate.delegate = self
        TxtFromDate.isUserInteractionEnabled = true
        TxtToDate.isUserInteractionEnabled = false
        TxtFromDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        TxtToDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
