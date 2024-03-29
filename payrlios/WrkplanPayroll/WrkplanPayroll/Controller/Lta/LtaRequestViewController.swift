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
import DropDown

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
    @IBOutlet weak var BtnFromYearSelect: UIButton!
    
    @IBOutlet weak var BtnToYearSelect: UIButton!
    var from_date: Bool = false
    var to_date: Bool = false
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    let dropDown = DropDown()
    var year_details = [YearDetails]()
    
    static var from_year: String!, to_year: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        LtaRequestViewController.from_year = ""
        LtaRequestViewController.to_year = ""
        
        TxtViewDetail.backgroundColor = UIColor.white
        TxtViewSupervisorRemark.backgroundColor = UIColor.white
        TxtViewFinalSupervisorRemark.backgroundColor = UIColor.white
        
        TxtLtaAmount.delegate = self
        TxtApprovedAmount.delegate = self
        
        //---code for date section, starts
        TxtFromDate.delegate = self
        TxtToDate.delegate = self
       /* TxtFromDate.isUserInteractionEnabled = false
        TxtFromDate.alpha = 0.4
        TxtToDate.isUserInteractionEnabled = false
        TxtToDate.alpha = 0.4*/
        
        TxtFromDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        TxtToDate.attributedPlaceholder = NSAttributedString(string: "Select Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        //---code to customize dropdown button starts------
        let buttonWidth = BtnFromYearSelect.frame.width
        
        BtnFromYearSelect.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        BtnToYearSelect.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        BtnFromYearSelect.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        BtnToYearSelect.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        //---code to customize dropdown button ends------
        
        //----code to append dropdown data, starts------
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
        
        
        
        //ViewBack
        let tapGestureRecognizerBackView = UITapGestureRecognizer(target: self, action: #selector(BackView(tapGestureRecognizer:)))
        ViewBtnBack.isUserInteractionEnabled = true
        ViewBtnBack.addGestureRecognizer(tapGestureRecognizerBackView)
        
        //ViewDocs
        let tapGestureRecognizerDocView = UITapGestureRecognizer(target: self, action: #selector(DocView(tapGestureRecognizer:)))
        ViewSupportingDocuments.isUserInteractionEnabled = true
        ViewSupportingDocuments.addGestureRecognizer(tapGestureRecognizerDocView)
        
        //ViewSave
        let tapGestureRecognizerSaveView = UITapGestureRecognizer(target: self, action: #selector(SaveView(tapGestureRecognizer:)))
        ViewBtnSave.isUserInteractionEnabled = true
        ViewBtnSave.addGestureRecognizer(tapGestureRecognizerSaveView)
        
        //ViewSubmit
        let tapGestureRecognizerSubmitView = UITapGestureRecognizer(target: self, action: #selector(SubmitView(tapGestureRecognizer:)))
        ViewBtnSubmit.isUserInteractionEnabled = true
        ViewBtnSubmit.addGestureRecognizer(tapGestureRecognizerSubmitView)
        
        //ViewApprove
        let tapGestureRecognizerApproveView = UITapGestureRecognizer(target: self, action: #selector(ApproveView(tapGestureRecognizer:)))
        ViewBtnApprove.isUserInteractionEnabled = true
        ViewBtnApprove.addGestureRecognizer(tapGestureRecognizerApproveView)
        
        //ViewReturn
        let tapGestureRecognizerReturnView = UITapGestureRecognizer(target: self, action: #selector(ReturnView(tapGestureRecognizer:)))
        ViewBtnReturn.isUserInteractionEnabled = true
        ViewBtnReturn.addGestureRecognizer(tapGestureRecognizerReturnView)
        
        //ViewCancel
        let tapGestureRecognizerCancelView = UITapGestureRecognizer(target: self, action: #selector(CancelView(tapGestureRecognizer:)))
        ViewBtnCancel.isUserInteractionEnabled = true
        ViewBtnCancel.addGestureRecognizer(tapGestureRecognizerCancelView)
        
        if LtaListViewController.new_create_yn == true {
            
            ViewBtnSave.isUserInteractionEnabled = false
            ViewBtnSave.alpha = 0.5
            
            ViewBtnSubmit.isUserInteractionEnabled = false
            ViewBtnSubmit.alpha = 0.5
            
            TxtFromDate.isUserInteractionEnabled = false
            TxtFromDate.alpha = 0.4
            TxtToDate.isUserInteractionEnabled = false
            TxtToDate.alpha = 0.4
            
            ViewBtnSave.isHidden = false
            ViewBtnSubmit.isHidden = false
            ViewBtnCancel.isHidden = true
            ViewBtnApprove.isHidden = true
            ViewBtnReturn.isHidden = true
            ImgFromDate.isHidden = false
            ImgToDate.isHidden = false
            
            TxtLtaAmount.isUserInteractionEnabled = true
            TxtViewDetail.isUserInteractionEnabled = true
//            TxtFromDate.isUserInteractionEnabled = true
//            TxtToDate.isUserInteractionEnabled = true
            
            TxtApprovedAmount.isUserInteractionEnabled = false
            TxtViewSupervisorRemark.isUserInteractionEnabled = false
            TxtViewFinalSupervisorRemark.isUserInteractionEnabled = false
            
            ViewSupportingDocuments.isUserInteractionEnabled = true
            ViewSupportingDocuments.alpha = 1.0
            
            self.TxtEmpName.text = self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue
        } else if LtaListViewController.new_create_yn == false {
//            LoadButtons()
            loadData(application_id: LtaListViewController.lta_id!)
        }
        
        //------making buttons disabled, code starts-----
        
        ViewBtnApprove.isUserInteractionEnabled = false
        ViewBtnApprove.alpha = 0.5
        //------making buttons disabled, code ends-----
        
        self.get_Year_details()
        
    }
    
    
    @IBAction func BtnDropDwonFromYear(_ sender: UIButton) {
        dropDown.dataSource = year
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("fromyear-=>",item)
                LtaRequestViewController.from_year = self!.year_details[index].calender_year
                
                if LtaRequestViewController.to_year != "" {
                    if LtaListViewController.new_create_yn == true {
                        LtaRequestViewController.to_year = self!.year_details[index].calender_year
                        self!.loadRemainingLtaAmountData(employee_id: self!.swiftyJsonvar1["employee"]["employee_id"].intValue, year_from: LtaRequestViewController.from_year, year_to: LtaRequestViewController.to_year)
                    }
                    if LtaListViewController.new_create_yn == false {
                        self!.loadRemainingLtaAmountData(employee_id: LtaListViewController.employee_id!, year_from: LtaRequestViewController.from_year, year_to: LtaRequestViewController.to_year)
                    }
                }
                sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
//                self!.loadData(year: self!.year_details[index].financial_year_code)
            }
    }
    
    @IBAction func BtnDropDownToYear(_ sender: UIButton) {
        dropDown.dataSource = year
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              sender.setTitle(item, for: .normal) //9
                print("toyear-=>",item)
                
                
                LtaRequestViewController.to_year = self!.year_details[index].calender_year
                
                if LtaRequestViewController.from_year != "" {
                    if LtaListViewController.new_create_yn == true {
                        LtaRequestViewController.to_year = self!.year_details[index].calender_year
                        self!.loadRemainingLtaAmountData(employee_id: self!.swiftyJsonvar1["employee"]["employee_id"].intValue, year_from: LtaRequestViewController.from_year, year_to: LtaRequestViewController.to_year)
                    }
                    if LtaListViewController.new_create_yn == false {
                        self!.loadRemainingLtaAmountData(employee_id: LtaListViewController.employee_id!, year_from: LtaRequestViewController.from_year, year_to: LtaRequestViewController.to_year)
                    }
                }
                sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
//                self!.loadData(year: self!.year_details[index].financial_year_code)
            }
    }
    
    //--------function to get year using Alamofire and Json Swifty------------
    var year = [String]()
        func get_Year_details(){
//            loaderStart()
            if !year_details.isEmpty{
                year_details.removeAll(keepingCapacity: true)
            }
            if !year.isEmpty {
                year.removeAll(keepingCapacity: true)
            }
            let url = "\(BASE_URL)finyear/list/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)"
            print("yearyrl-=>",url)
            AF.request(url).responseJSON{ (responseData) -> Void in
//                self.loaderEnd()
                if((responseData.value) != nil){
                    let swiftyJsonVar=JSON(responseData.value!)
                    print("Calendar description: \(swiftyJsonVar)")
                    
                    for i in 0..<swiftyJsonVar["fin_years"].count{
//                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
//                        print("Calendar-=>",self.year)
                        self.year.append(swiftyJsonVar["fin_years"][i]["calender_year"].stringValue)
                        
                        
                    }
                    for(key,value) in swiftyJsonVar["fin_years"]{
                        var k = YearDetails()
                        k.calender_year = value["calender_year"].stringValue
                        k.financial_year_code = value["financial_year_code"].stringValue
                        self.year_details.append(k)
                    }

                    
                }
                
            }
        }
    
        //--------function to get year using Alamofire and Json Swifty code ends------------
    //--------function to loadData using Alamofire and Json Swifty code starts----------
    func loadRemainingLtaAmountData(employee_id: Int!,year_from: String!, year_to: String!){
        loaderStart()
        let url = "\(BASE_URL)lta/balance/year-wise/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(employee_id!)/\(year_from!)/\(year_to!)"
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
                self.loaderEnd()
            print("responseData-=>",responseData)
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                    print("Year description: \(swiftyJsonVar)")
                self.TxtRemainingLtaAmount.text = swiftyJsonVar["balance_amount"].stringValue
                    
                }

                
            }
            
        }
    //--------function to loadData using Alamofire and Json Swifty code ends----------
    //---ViewCancel
    @objc func CancelView(tapGestureRecognizer: UITapGestureRecognizer){
        makeJsonObjectAndSaveDataToServer(lta_application_id: LtaListViewController.lta_id!, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: TxtApprovedAmount.text!, description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: "Cancelled", approved_by_id: LtaListViewController.employee_id!)
        
    }
    
    //---ViewReturn
    @objc func ReturnView(tapGestureRecognizer: UITapGestureRecognizer){
        makeJsonObjectAndSaveDataToServer(lta_application_id: LtaListViewController.lta_id!, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: TxtApprovedAmount.text!, description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: "Returned", approved_by_id: LtaListViewController.employee_id!)
        
    }
    
    //---ViewApprove
    @objc func ApproveView(tapGestureRecognizer: UITapGestureRecognizer){
        makeJsonObjectAndSaveDataToServer(lta_application_id: LtaListViewController.lta_id!, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: TxtApprovedAmount.text!, description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: "Approved", approved_by_id: LtaListViewController.employee_id!)
        
    }
    
    //---ViewSubmit
    @objc func SubmitView(tapGestureRecognizer: UITapGestureRecognizer){
        //        self.performSegue(withIdentifier: "ltasupportingdoc", sender: nil)
        if LtaListViewController.new_create_yn == true {
            makeJsonObjectAndSaveDataToServer(lta_application_id: 0, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: "0.00", description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: "Submitted", approved_by_id: 0)
        }
        if LtaListViewController.new_create_yn == false {
            makeJsonObjectAndSaveDataToServer(lta_application_id: LtaListViewController.lta_id!, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: TxtApprovedAmount.text!, description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: "Submitted", approved_by_id: 0)
        }
        
    }
    
    //---ViewSave
    @objc func SaveView(tapGestureRecognizer: UITapGestureRecognizer){
        //        self.performSegue(withIdentifier: "ltasupportingdoc", sender: nil)
        if LtaListViewController.new_create_yn == true {
            makeJsonObjectAndSaveDataToServer(lta_application_id: 0, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: "0.00", description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: "Saved", approved_by_id: 0)
        }
        if LtaListViewController.new_create_yn == false {
            makeJsonObjectAndSaveDataToServer(lta_application_id: LtaListViewController.lta_id!, date_from: TxtFromDate.text!, date_to: TxtToDate.text!, total_days: LabelDayCount.text!, lta_amount: TxtLtaAmount.text!, approved_lta_amount: TxtApprovedAmount.text!, description: TxtViewDetail.text!, supervisor_remark: TxtViewSupervisorRemark.text!, lta_application_status: TxtRequisitionStatus.text!, approved_by_id: 0)
        }
        
    }
    
    //---ViewDocs
    @objc func DocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "ltasupportingdoc", sender: nil)
        
    }
    //---ViewBack
    @objc func BackView(tapGestureRecognizer: UITapGestureRecognizer){
       /* if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
            LtaSupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
            LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
            self.collectUpdatedDetailDeletedData.removeAll()
        }
        if LtaListViewController.EmployeeType == "Supervisor" {
            self.performSegue(withIdentifier: "subordinatelta", sender: nil)
        }
        if LtaListViewController.EmployeeType == "Employee" {
            self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
        }*/
        customiseBackWithAlertPopup()
        
    }
    
    @IBAction func BtnBack(_ sender: Any) {
       /* if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
            LtaSupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if LtaListViewController.EmployeeType == "Supervisor" {
            self.performSegue(withIdentifier: "subordinatelta", sender: nil)
        }
        if LtaListViewController.EmployeeType == "Employee" {
            self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
        }*/
        
        customiseBackWithAlertPopup()
        
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
        LtaListViewController.new_create_yn = false
//        self.performSegue(withIdentifier: "advancehome", sender: self)
        CloseAlertPopup()
        
        if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
            LtaSupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
            LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
            self.collectUpdatedDetailDeletedData.removeAll()
        }
        if LtaListViewController.EmployeeType == "Supervisor" {
            self.performSegue(withIdentifier: "subordinatelta", sender: nil)
        }
        if LtaListViewController.EmployeeType == "Employee" {
            self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
        }
    }
    @objc func onClickYeshDashboard(tapGestureRecognizer: UITapGestureRecognizer){
        LtaListViewController.new_create_yn = false
        CloseAlertPopup()
        if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
            LtaSupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
            LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
            self.collectUpdatedDetailDeletedData.removeAll()
        }
        if LtaListViewController.EmployeeType == "Supervisor" {
//            self.performSegue(withIdentifier: "subordinatemediclaimlist", sender: nil)
            self.performSegue(withIdentifier: "dboard", sender: self)
        }
        if LtaListViewController.EmployeeType == "Employee" {
//            self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
            self.performSegue(withIdentifier: "dboard", sender: self)
        }
    }
    @objc func onClickAlertPopupNo(tapGestureRecognizer: UITapGestureRecognizer){
        CloseAlertPopup()
    }
    //===============Alert(Cancel/Yes) Confirmation Popup code ends===================
    //-----Code for calendarDate selection, starts-----
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField{
        case self.TxtLtaAmount:
            if Double(TxtLtaAmount.text!) ?? 0 > 0 {
                TxtFromDate.isUserInteractionEnabled = true
                TxtFromDate.alpha = 1.0
                
                if TxtFromDate.text! != "" &&
                    TxtToDate.text! != "" {
                    ViewBtnSubmit.isUserInteractionEnabled = true
                    ViewBtnSubmit.alpha = 1.0
                    ViewBtnSave.isUserInteractionEnabled = true
                    ViewBtnSave.alpha = 1.0
                }
            }else if Double(TxtLtaAmount.text!) ?? 0 == 0 {
                TxtFromDate.isUserInteractionEnabled = false
                TxtFromDate.alpha = 0.6
                
                ViewBtnSubmit.isUserInteractionEnabled = false
                ViewBtnSubmit.alpha = 0.6
                ViewBtnSave.isUserInteractionEnabled = false
                ViewBtnSave.alpha = 0.6
            }else{
                TxtFromDate.isUserInteractionEnabled = false
                TxtFromDate.alpha = 0.6
                
                ViewBtnSubmit.isUserInteractionEnabled = false
                ViewBtnSubmit.alpha = 0.6
                ViewBtnSave.isUserInteractionEnabled = false
                ViewBtnSave.alpha = 0.6
            }
            break
            
        case self.TxtApprovedAmount:
            if Double(TxtApprovedAmount.text!)! > 0 {
                if Double(TxtApprovedAmount.text!)! > Double(TxtLtaAmount.text!)! {
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
            break
        
        default:
            break
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case self.TxtFromDate:
            from_date = true
            to_date = false
            showDatePicker(txtfield: TxtFromDate)
            TxtToDate.isUserInteractionEnabled = true
            TxtToDate.alpha = 1.0
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
    override func viewWillAppear(_ animated: Bool) {
        if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
            self.TxtSupportingDocuments.text = "\(LtaSupportingDocumentsViewController.tableChildData.count) Document(s)"
        }else{
            self.TxtSupportingDocuments.text = "0 Document(s)"
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
            
            if (daysBetween(start: TxtFromDate.text!, end: TxtToDate.text!)+1) < 5 {
                //                ViewBtnSave.isEnabled = false
                ViewBtnSave.isUserInteractionEnabled = false
                ViewBtnSave.alpha = 0.6
                
                ViewBtnSubmit.isUserInteractionEnabled = false
                ViewBtnSubmit.alpha = 0.6
                
                LabelWarningTitle.textColor = UIColor(hexFromString: "FF0000")
            }else{
                //                custom_btn_label_save.isEnabled = true
                ViewBtnSave.isUserInteractionEnabled = true
                ViewBtnSave.alpha = 1.0
                
                ViewBtnSubmit.isUserInteractionEnabled = true
                ViewBtnSubmit.alpha = 1.0
                
                LabelWarningTitle.textColor = UIColor(hexFromString: "2C2C2C")
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
    
    //=========function to make json object and save data, code starts======
    var collectUpdatedDetailsData = [Any]()
    var collectUpdatedDetailDeletedData = [Any]()
    func makeJsonObjectAndSaveDataToServer(lta_application_id: Int,  date_from: String, date_to: String, total_days: String,  lta_amount: String, approved_lta_amount: String, description: String, supervisor_remark: String,  lta_application_status: String, approved_by_id: Int){
        var getData = [String:AnyObject]()
        print("LtaCount-=>",LtaSupportingDocumentsViewController.tableChildData.count)
        
        if !collectUpdatedDetailsData.isEmpty{
            self.collectUpdatedDetailsData.removeAll()
        }
        
        for i in 0..<LtaSupportingDocumentsViewController.tableChildData.count{
            getData.updateValue(LtaSupportingDocumentsViewController.tableChildData[i].document_name! as AnyObject, forKey: "file_name")
            getData.updateValue(LtaSupportingDocumentsViewController.tableChildData[i].document_base64! as AnyObject, forKey: "file_base64")
            
            collectUpdatedDetailsData.append(getData)
        }
        
        var getDeletedData = [String:AnyObject]()
        if !collectUpdatedDetailDeletedData.isEmpty{
            self.collectUpdatedDetailDeletedData.removeAll()
        }
        for i in 0..<LtaSupportingDocumentsViewController.deletedTableChildData.count{
           
            getDeletedData.updateValue(LtaSupportingDocumentsViewController.deletedTableChildData[i].document_id! as AnyObject, forKey: "lta_application_id")
            getDeletedData.updateValue(LtaSupportingDocumentsViewController.deletedTableChildData[i].document_name! as AnyObject, forKey: "file_name")
            
            collectUpdatedDetailDeletedData.append(getDeletedData)
        }
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "lta_application_id": lta_application_id,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].intValue,
            "date_from": date_from,
            "date_to": date_to,
            "total_days": Int(total_days)!,
            "lta_amount": Double(lta_amount)!,
            "approved_lta_amount": Double(approved_lta_amount)!,
            "description": description,
            "supervisor_remark": supervisor_remark,
            "lta_application_status": lta_application_status,
            "approved_by_id": approved_by_id,
            "year_from": LtaRequestViewController.from_year ?? "",
            "year_to": LtaRequestViewController.to_year ?? "",
            "year_from_limit": Double(TxtFromYrLtaLimit.text!) ?? 0,
            "year_to_limit": Double(TxtToYearLtaLimit.text!) ?? 0,
            "lta_total_limit": Double(TxtTotalLtaAmount.text!) ?? 0,
            "documents": collectUpdatedDetailsData,
            "deleted_documents": collectUpdatedDetailDeletedData
        ]
        
        print("SentData-=>",sentData)
        let url = "\(BASE_URL)lta/save"
        print("save_url-=>",url)
        AF.request(url, method: .post, parameters: sentData, encoding: JSONEncoding.default, headers: nil).responseJSON{
            response in
            switch response.result{
            
            case .success:
                //                        self.loaderEnd()
                let swiftyJsonVar = JSON(response.value!)
                print("message-=>", swiftyJsonVar)
                
                if swiftyJsonVar["status"].stringValue == "true"{
                    
                    // Create new Alert
                    let dialogMessage = UIAlertController(title: "", message: swiftyJsonVar["message"].stringValue, preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                        //                                print("Ok button tapped")
                        
//                        self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
                        if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                            LtaSupportingDocumentsViewController.tableChildData.removeAll()
                            self.collectUpdatedDetailsData.removeAll()
                            //                            self.loadData()
                        }
                        if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
                            LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
                            self.collectUpdatedDetailDeletedData.removeAll()
                        }
                        if LtaListViewController.EmployeeType == "Supervisor" {
                            self.performSegue(withIdentifier: "subordinatelta", sender: nil)
                        }
                        if LtaListViewController.EmployeeType == "Employee" {
                            self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
                        }
                        
                    })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)
                    
                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                }else{
//                    OdDutyLogEmployeeTaskViewController.back_btn_save_unsave_check = 0
//                    self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
                    if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                        LtaSupportingDocumentsViewController.tableChildData.removeAll()
                        self.collectUpdatedDetailsData.removeAll()
                        //                            self.loadData()
                    }
                    if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
                        LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
                        self.collectUpdatedDetailDeletedData.removeAll()
                    }
                    
                    if LtaListViewController.EmployeeType == "Supervisor" {
                        self.performSegue(withIdentifier: "subordinatelta", sender: nil)
                    }
                    if LtaListViewController.EmployeeType == "Employee" {
                        self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
                    }
                    
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageColor = .white
                    
                    // present the toast with the new style
                    self.view.makeToast(swiftyJsonVar["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                    
                    print("Error-=>",swiftyJsonVar["message"].stringValue)
                    
                    
                }
                
                break
                
            case .failure(let error):
                //                        self.loaderEnd()
                print("Error: ", error)
            }
        }
    }
    //=========function to make json object and save data, code ends======
    
    //-----function to add alert logic on back button, code starts(added on 5-Aug-2021)-----
    func customiseBackWithAlertPopup(){
        if LtaListViewController.EmployeeType == "Employee"{
            //            LabelNavBarTitle.text = "My Advance Requisition"
            //            btn_reason_select_type.isUserInteractionEnabled = true
            //            btn_reason_select_type.alpha = 1.0
            if LtaListViewController.lta_status! == ""{
                
//                openBackConfirmationPopup()
                OpenAlertPopup()
            }
            if LtaListViewController.lta_status! == "Saved"{
//               openBackConfirmationPopup()
                OpenAlertPopup()
            }
            if LtaListViewController.lta_status! == "Submitted" ||
                LtaListViewController.lta_status! == "Approved" ||
                LtaListViewController.lta_status! == "Payment done" ||
                LtaListViewController.lta_status! == "Cancelled"{
                
                if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                    LtaSupportingDocumentsViewController.tableChildData.removeAll()
                    collectUpdatedDetailsData.removeAll()
                }
                if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
                    LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
                    self.collectUpdatedDetailDeletedData.removeAll()
                }
                if LtaListViewController.EmployeeType == "Supervisor" {
                    self.performSegue(withIdentifier: "subordinatelta", sender: nil)
                }
                if LtaListViewController.EmployeeType == "Employee" {
                    self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
                }
            }
            if LtaListViewController.lta_status! == "Returned"{
//                openBackConfirmationPopup()
                OpenAlertPopup()
                
            }
        }
        if LtaListViewController.EmployeeType! == "Supervisor"{
            //            LabelNavBarTitle.text = "Subordinate Advance Requisition"
            //            btn_reason_select_type.isUserInteractionEnabled = false
            //            btn_reason_select_type.alpha = 0.6
            if LtaListViewController.lta_status! == "Submitted"{
//                openBackConfirmationPopup()
                OpenAlertPopup()
            }
            if LtaListViewController.lta_status! == "Returned" ||
                LtaListViewController.lta_status! == "Approved" ||
                LtaListViewController.lta_status! == "Payment done" ||
                LtaListViewController.lta_status! == "Cancelled"{
                
                if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                    LtaSupportingDocumentsViewController.tableChildData.removeAll()
                    collectUpdatedDetailsData.removeAll()
                }
                if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
                    LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
                    self.collectUpdatedDetailDeletedData.removeAll()
                }
                if LtaListViewController.EmployeeType == "Supervisor" {
                    self.performSegue(withIdentifier: "subordinatelta", sender: nil)
                }
                if LtaListViewController.EmployeeType == "Employee" {
                    self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
                }
            }
        }
    }
    //-----function to add alert logic on back button, code ends-----
    
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
                //--added on 23rd july, starts
                ViewBtnSubmit.isUserInteractionEnabled = true
                ViewBtnSubmit.alpha = 1.0
                ViewBtnSave.isUserInteractionEnabled = true
                ViewBtnSave.alpha = 1.0
                //--added on 23rd july, ends
                
                
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
                LtaListViewController.lta_status! == "Cancelled"{
                
                //--added on 23rd july, starts
                ViewBtnSubmit.isUserInteractionEnabled = true
                ViewBtnSubmit.alpha = 1.0
                ViewBtnSave.isUserInteractionEnabled = true
                ViewBtnSave.alpha = 1.0
                //--added on 23rd july, ends
                
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
                
                //--added on 23rd july, starts
                ViewBtnSubmit.isUserInteractionEnabled = true
                ViewBtnSubmit.alpha = 1.0
                ViewBtnSave.isUserInteractionEnabled = true
                ViewBtnSave.alpha = 1.0
                //--added on 23rd july, ends
                
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
        if LtaListViewController.EmployeeType! == "Supervisor"{
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
                
                if LtaSupportingDocumentsViewController.tableChildData.count <= 0 {
                    ViewSupportingDocuments.isUserInteractionEnabled = false
                    ViewSupportingDocuments.alpha = 0.2
                                }
                if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                    ViewSupportingDocuments.isUserInteractionEnabled = true
                    ViewSupportingDocuments.alpha = 1.0
                                }
            }
            if LtaListViewController.lta_status! == "Returned" ||
                LtaListViewController.lta_status! == "Approved" ||
                LtaListViewController.lta_status! == "Payment done" ||
                LtaListViewController.lta_status! == "Cancelled"{
                
                
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
                
                if LtaSupportingDocumentsViewController.tableChildData.count <= 0 {
                    ViewSupportingDocuments.isUserInteractionEnabled = false
                    ViewSupportingDocuments.alpha = 0.2
                                }
                if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                    ViewSupportingDocuments.isUserInteractionEnabled = true
                    ViewSupportingDocuments.alpha = 1.0
                                }
                
            }
        }
        
        
    }
    //----function to load buttons acc to the logic, code ends
    
    //--------function to load document details using Alamofire and Json Swifty(added on 2-Jul-2021------------
    func loadData(application_id: Int!){
        loaderStart()
        
        let url = "\(BASE_URL)lta/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(application_id!)"
        print("MediclaimDocumentDetails-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Doc description: \(swiftyJsonVar)")
                
                self.TxtLtaRequisitionNo.text = swiftyJsonVar["fields"]["lta_application_no"].stringValue
                /*if LtaListViewController.new_create_yn == true{
                 self.TxtEmpName.text = self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue
                 }else{
                 self.TxtEmpName.text = LtaListViewController.employee_name!
                 }*/
                
                self.TxtEmpName.text = self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue
                self.TxtFromYrLtaLimit.text = swiftyJsonVar["fields"]["year_from_limit"].stringValue
                self.TxtToYearLtaLimit.text = swiftyJsonVar["fields"]["year_to_limit"].stringValue
                self.TxtTotalLtaAmount.text = String(swiftyJsonVar["fields"]["lta_total_limit"].doubleValue)
                self.TxtRemainingLtaAmount.text = String(swiftyJsonVar["fields"]["lta_used_amount"].doubleValue)
                self.TxtLtaAmount.text = String(swiftyJsonVar["fields"]["lta_amount"].doubleValue)
                self.TxtViewDetail.text = swiftyJsonVar["fields"]["description"].stringValue
                self.TxtFromDate.text = swiftyJsonVar["fields"]["date_from"].stringValue
                self.TxtToDate.text = swiftyJsonVar["fields"]["date_to"].stringValue
                self.TxtApprovedAmount.text = String(swiftyJsonVar["fields"]["approved_lta_amount"].doubleValue)
                self.TxtViewSupervisorRemark.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                self.TxtViewFinalSupervisorRemark.text = swiftyJsonVar["fields"]["final_supervisor_remark"].stringValue
                self.TxtRequisitionStatus.text = swiftyJsonVar["fields"]["application_status"].stringValue
                self.LabelDayCount.text = String(self.daysBetween(start: swiftyJsonVar["fields"]["date_from"].stringValue, end: swiftyJsonVar["fields"]["date_to"].stringValue)+1)
                
                if swiftyJsonVar["documents"] != ""{
                    //                    UserSingletonModel.sharedInstance.documents = swiftyJsonVar
                    for (key,value) in  swiftyJsonVar["documents"]{
                        var data = LtaDocumentDetails(document_id: value["lta_application_id"].intValue, document_name: value["file_name"].stringValue, document_size: "", document_base64: value["file_base64"].stringValue, lta_file_from_api_yn: true)
                       /* data.document_name = value["file_name"].stringValue
                        data.document_base64 = value["file_base64"].stringValue*/
                        LtaSupportingDocumentsViewController.tableChildData.append(data)
                    }
                }
                
                if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
                    self.TxtSupportingDocuments.text = "\(LtaSupportingDocumentsViewController.tableChildData.count) Document(s)"
                    self.LoadButtons()
                }else{
                    self.TxtSupportingDocuments.text = "0 Document(s)"
                    self.LoadButtons()
                }
                
            }
            
        }
    }
    //--------function to load document details using Alamofire and Json Swifty code ends------------
    
    //==============FormDialog Back Confirmation code starts================
    @IBOutlet var viewBackConfirmationPopup: UIView!
    
    func openBackConfirmationPopup(){
        blurEffect()
        self.view.addSubview(viewBackConfirmationPopup)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewBackConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewBackConfirmationPopup.center = self.view.center
        viewBackConfirmationPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewBackConfirmationPopup.alpha = 0
        viewBackConfirmationPopup.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.viewBackConfirmationPopup.alpha = 1
            self.viewBackConfirmationPopup.transform = CGAffineTransform.identity
        }
    }
    func cancelBackConfirmationPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBackConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewBackConfirmationPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewBackConfirmationPopup.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    @IBAction func btnCancelBackConfirmationPopupYes(_ sender: Any) {
        cancelBackConfirmationPopup()
        if LtaSupportingDocumentsViewController.tableChildData.count > 0 {
            LtaSupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if LtaSupportingDocumentsViewController.deletedTableChildData.count > 0 {
            LtaSupportingDocumentsViewController.deletedTableChildData.removeAll()
            self.collectUpdatedDetailDeletedData.removeAll()
        }
        if LtaListViewController.EmployeeType == "Supervisor" {
            self.performSegue(withIdentifier: "subordinatelta", sender: nil)
        }
        if LtaListViewController.EmployeeType == "Employee" {
            self.performSegue(withIdentifier: "LtaEmployee", sender: nil)
        }
        
    }
    
    @IBAction func btnCancelBackConfirmationPopupNo(_ sender: Any) {
        cancelBackConfirmationPopup()
    }
    //==============FormDialog Cancel Confirmation code ends================
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
