//
//  MediclaimRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/06/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class MediclaimRequestViewController: UIViewController {
    
    @IBOutlet weak var TxtMediclaimNo: UITextField!
    @IBOutlet weak var TxtEmployeeName: UITextField!
    @IBOutlet weak var TxtMediclaimAmount: UITextField!
    @IBOutlet weak var LabelCustomBtnCheckBalance: UILabel!
    @IBOutlet weak var ViewCustomBtnCheckBalance: UIView!
    @IBOutlet weak var TxtReason: UITextField!
    @IBOutlet weak var TxtSupportingDocuments: UITextField!
    @IBOutlet weak var LabelCustomBtnViewDocuments: UILabel!
    @IBOutlet weak var ViewCustomBtnViewDocuments: UIView!
    @IBOutlet weak var TxtApprovedAmount: UITextField!
    @IBOutlet weak var TxtViewApprovalRemark: UITextView!
    @IBOutlet weak var TxtApplicationStatus: UITextField!
    @IBOutlet weak var ViewBtnCancel: UIView!
    @IBOutlet weak var ViewBtnReturn: UIView!
    @IBOutlet weak var ViewBtnApprove: UIView!
    @IBOutlet weak var ViewBtnSubmit: UIView!
    @IBOutlet weak var ViewBtnSave: UIView!
    @IBOutlet weak var ViewBtnBack: UIView!
    @IBOutlet weak var StackViewButtons: UIStackView!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        
        
        
        TxtMediclaimNo.isUserInteractionEnabled = false
        TxtEmployeeName.isUserInteractionEnabled = false
        TxtApplicationStatus.isUserInteractionEnabled = false
        TxtSupportingDocuments.isUserInteractionEnabled = false
        
        TxtMediclaimNo.setLeftPaddingPoints(5)
        TxtEmployeeName.setLeftPaddingPoints(5)
        TxtMediclaimAmount.setRightPaddingPoints(5)
        TxtReason.setLeftPaddingPoints(5)
        TxtSupportingDocuments.setLeftPaddingPoints(5)
        TxtApprovedAmount.setRightPaddingPoints(5)
        TxtApplicationStatus.setLeftPaddingPoints(5)
        TxtViewApprovalRemark.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        TxtApplicationStatus.setLeftPaddingPoints(2)
        
        //-----code to add button border, starts------
        StackViewButtons.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnCancel.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnReturn.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnApprove.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnSubmit.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnSave.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewCustomBtnViewDocuments.addBorder(side: .left, color: UIColor(hexFromString: "000000"), width: 0.6)
        //-----code to add button border, ends------
        
        if LtaListViewController.new_create_yn == true {
            ViewBtnSave.isHidden = false
            ViewBtnSubmit.isHidden = false
            ViewBtnCancel.isHidden = true
            ViewBtnApprove.isHidden = true
            ViewBtnReturn.isHidden = true
            
            
            TxtMediclaimAmount.isUserInteractionEnabled = true
            TxtReason.isUserInteractionEnabled = true
            
            TxtApprovedAmount.isUserInteractionEnabled = false
            TxtViewApprovalRemark.isUserInteractionEnabled = false
            
            ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
            ViewCustomBtnViewDocuments.alpha = 1.0
            self.TxtEmployeeName.text = self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue
            TxtSupportingDocuments.text = "0 Document(s)"
        } else if LtaListViewController.new_create_yn == false {
            LoadButtons()
            loadData(mediclaim_id: MediclaimListViewController.mediclaim_id!)
        }
        
        //ViewDocs
        let tapGestureRecognizerDocView = UITapGestureRecognizer(target: self, action: #selector(DocView(tapGestureRecognizer:)))
        ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
        ViewCustomBtnViewDocuments.addGestureRecognizer(tapGestureRecognizerDocView)
        
        //ViewCheckBalance
        let tapGestureRecognizerCheckBalanceView = UITapGestureRecognizer(target: self, action: #selector(CheckBalanceView(tapGestureRecognizer:)))
        ViewCustomBtnCheckBalance.isUserInteractionEnabled = true
        ViewCustomBtnCheckBalance.addGestureRecognizer(tapGestureRecognizerCheckBalanceView)
        
        //------ClaimAmountBalancePopup Ok
        let tapGestureRecognizerLeavePopupOk = UITapGestureRecognizer(target: self, action: #selector(ClaimAmountBalancePopupOk(tapGestureRecognizer:)))
        CustomOkBtnAmountBalancePopup.isUserInteractionEnabled = true
        CustomOkBtnAmountBalancePopup.addGestureRecognizer(tapGestureRecognizerLeavePopupOk)
        
        //ViewBack
        let tapGestureRecognizerBackView = UITapGestureRecognizer(target: self, action: #selector(BackView(tapGestureRecognizer:)))
        ViewBtnBack.isUserInteractionEnabled = true
        ViewBtnBack.addGestureRecognizer(tapGestureRecognizerBackView)
        
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
        
      /*  if MediclaimListViewController.new_create_yn == false{
            loadData(mediclaim_id: MediclaimListViewController.mediclaim_id!)
//            loadData(mediclaim_id: 9)
        } else if MediclaimListViewController.new_create_yn == true{
            TxtSupportingDocuments.text = "0 Document(s)"
        }*/
        
//        LoadButtons()
        print("Status-=>",MediclaimListViewController.mediclaim_status!)
        
    }
    
    
    //---ViewCheckBalance
    @objc func CheckBalanceView(tapGestureRecognizer: UITapGestureRecognizer){
        OpenClaimAmountBalancePopup()
        
    }
    //---ViewDocs
    @objc func DocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "supportingdoc", sender: nil)
        
    }
    //---ViewBack
    @objc func BackView(tapGestureRecognizer: UITapGestureRecognizer){
        
        
        
        
        if SupportingDocumentsViewController.tableChildData.count > 0 {
            SupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if MediclaimListViewController.EmployeeType == "Supervisor" {
            self.performSegue(withIdentifier: "subordinatemediclaimlist", sender: nil)
        }
        if MediclaimListViewController.EmployeeType == "Employee" {
            self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
        }
        
    }
    
    //---ViewCancel
    @objc func CancelView(tapGestureRecognizer: UITapGestureRecognizer){
        makeJsonObjectAndSaveDataToServer(mediclaim_id: MediclaimListViewController.mediclaim_id!, mediclaim_no: MediclaimListViewController.mediclaim_no!, mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Canceled", approved_by_id: MediclaimListViewController.employee_id!, approved_by_name: self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue, payment_remark: "", payment_amount: "0")
    }
    
    //---ViewReturn
    @objc func ReturnView(tapGestureRecognizer: UITapGestureRecognizer){

        makeJsonObjectAndSaveDataToServer(mediclaim_id: MediclaimListViewController.mediclaim_id!, mediclaim_no: MediclaimListViewController.mediclaim_no!, mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Returned", approved_by_id: MediclaimListViewController.employee_id!, approved_by_name: self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue, payment_remark: "", payment_amount: "0")
        
    }
    
    //---ViewApprove
    @objc func ApproveView(tapGestureRecognizer: UITapGestureRecognizer){

        makeJsonObjectAndSaveDataToServer(mediclaim_id: MediclaimListViewController.mediclaim_id!, mediclaim_no: MediclaimListViewController.mediclaim_no!, mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Approved", approved_by_id: MediclaimListViewController.employee_id!, approved_by_name: self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue, payment_remark: "", payment_amount: "0")
        
    }
    
    //---ViewSubmit
    @objc func SubmitView(tapGestureRecognizer: UITapGestureRecognizer){
        //        self.performSegue(withIdentifier: "ltasupportingdoc", sender: nil)
        if MediclaimListViewController.new_create_yn == true {

            makeJsonObjectAndSaveDataToServer(mediclaim_id: 0, mediclaim_no: "", mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Submitted", approved_by_id: 0, approved_by_name: "", payment_remark: "", payment_amount: "0")
        }
        if MediclaimListViewController.new_create_yn == false {

            makeJsonObjectAndSaveDataToServer(mediclaim_id: MediclaimListViewController.mediclaim_id!, mediclaim_no: MediclaimListViewController.mediclaim_no!, mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Submitted", approved_by_id: 0, approved_by_name: "", payment_remark: "", payment_amount: "0")
        }
        
    }
    
    //---ViewSave
    @objc func SaveView(tapGestureRecognizer: UITapGestureRecognizer){
        //        self.performSegue(withIdentifier: "ltasupportingdoc", sender: nil)
        if MediclaimListViewController.new_create_yn == true {
            makeJsonObjectAndSaveDataToServer(mediclaim_id: 0, mediclaim_no: "", mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Saved", approved_by_id: 0, approved_by_name: "", payment_remark: "", payment_amount: "0")
        }
        if MediclaimListViewController.new_create_yn == false {
            makeJsonObjectAndSaveDataToServer(mediclaim_id: MediclaimListViewController.mediclaim_id!, mediclaim_no: MediclaimListViewController.mediclaim_no!, mediclaim_amount: TxtMediclaimAmount.text!, approved_mediclaim_amount: TxtApprovedAmount.text!, description: TxtReason.text!, supervisor_remark: TxtViewApprovalRemark.text!, mediclaim_status: "Saved", approved_by_id: 0, approved_by_name: "", payment_remark: "", payment_amount: "0")
        }
        
    }
    //----function to load buttons acc to the logic, code starts
    func LoadButtons(){
       
        
        if MediclaimListViewController.EmployeeType == "Employee"{
//            LabelNavBarTitle.text = "My Advance Requisition"
//            btn_reason_select_type.isUserInteractionEnabled = true
//            btn_reason_select_type.alpha = 1.0
            if MediclaimListViewController.mediclaim_status! == ""{
                ViewBtnSave.isHidden = false
                ViewBtnSubmit.isHidden = false
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                
                
                TxtMediclaimAmount.isUserInteractionEnabled = true
                TxtReason.isUserInteractionEnabled = true
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewApprovalRemark.isUserInteractionEnabled = false
                
                ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
                ViewCustomBtnViewDocuments.alpha = 1.0
            }
            if MediclaimListViewController.mediclaim_status! == "Saved"{
                ViewBtnSave.isHidden = false
                ViewBtnSubmit.isHidden = false
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                
                
                TxtMediclaimAmount.isUserInteractionEnabled = true
                TxtReason.isUserInteractionEnabled = true
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewApprovalRemark.isUserInteractionEnabled = false
                
                ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
                ViewCustomBtnViewDocuments.alpha = 1.0
            }
            if MediclaimListViewController.mediclaim_status! == "Submitted" ||
                MediclaimListViewController.mediclaim_status! == "Approved" ||
                MediclaimListViewController.mediclaim_status! == "Payment done" ||
                MediclaimListViewController.mediclaim_status! == "Canceled"{
                
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = true
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                
                TxtMediclaimAmount.isUserInteractionEnabled = false
                TxtReason.isUserInteractionEnabled = false
                
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewApprovalRemark.isUserInteractionEnabled = false
                
                ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
                ViewCustomBtnViewDocuments.alpha = 1.0
            }
            if MediclaimListViewController.mediclaim_status! == "Returned"{
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = false
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                
                TxtMediclaimAmount.isUserInteractionEnabled = true
                TxtReason.isUserInteractionEnabled = true
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewApprovalRemark.isUserInteractionEnabled = false
                
                ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
                ViewCustomBtnViewDocuments.alpha = 1.0
            }
        }
        if MediclaimListViewController.EmployeeType == "Supervisor"{
//            LabelNavBarTitle.text = "Subordinate Advance Requisition"
//            btn_reason_select_type.isUserInteractionEnabled = false
//            btn_reason_select_type.alpha = 0.6
            if MediclaimListViewController.mediclaim_status! == "Submitted"{
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = true
                ViewBtnCancel.isHidden = false
                ViewBtnApprove.isHidden = false
                ViewBtnReturn.isHidden = false
                
                
                TxtMediclaimAmount.isUserInteractionEnabled = false
                TxtReason.isUserInteractionEnabled = false
                TxtApprovedAmount.isUserInteractionEnabled = true
                TxtViewApprovalRemark.isUserInteractionEnabled = true
                
                ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
                ViewCustomBtnViewDocuments.alpha = 1.0
            }
            if MediclaimListViewController.mediclaim_status! == "Returned" ||
                MediclaimListViewController.mediclaim_status! == "Approved" ||
                MediclaimListViewController.mediclaim_status! == "Payment done" ||
                MediclaimListViewController.mediclaim_status! == "Canceled"{
                
                ViewBtnSave.isHidden = true
                ViewBtnSubmit.isHidden = true
                ViewBtnCancel.isHidden = true
                ViewBtnApprove.isHidden = true
                ViewBtnReturn.isHidden = true
                
                
                TxtMediclaimAmount.isUserInteractionEnabled = false
                TxtReason.isUserInteractionEnabled = false
                TxtApprovedAmount.isUserInteractionEnabled = false
                TxtViewApprovalRemark.isUserInteractionEnabled = false
                
                ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
                ViewCustomBtnViewDocuments.alpha = 1.0
            }
        }
        
        
    }
    //----function to load buttons acc to the logic, code ends
    
    @IBAction func BtnBack(_ sender: Any) {
//        self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
        if SupportingDocumentsViewController.tableChildData.count > 0 {
            SupportingDocumentsViewController.tableChildData.removeAll()
            collectUpdatedDetailsData.removeAll()
        }
        if MediclaimListViewController.EmployeeType == "Supervisor" {
            self.performSegue(withIdentifier: "subordinatemediclaimlist", sender: nil)
        }
        if MediclaimListViewController.EmployeeType == "Employee" {
            self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SupportingDocumentsViewController.tableChildData.count > 0 {
            self.TxtSupportingDocuments.text = "\(SupportingDocumentsViewController.tableChildData.count) Document(s)"
        }else{
            self.TxtSupportingDocuments.text = "0 Document(s)"
        }
    }
    
    //============================-Form Leave Balance dialog, code starts============================
    @IBOutlet weak var ViewPopupNavBar: UIView!
    @IBOutlet var ViewAmountBalance: UIView!
    @IBOutlet weak var LabelPeriod: UILabel!
    @IBOutlet weak var LabelUtilizedAmount: UILabel!
    @IBOutlet weak var LabelLimitForTheYearPeriod: UILabel!
    @IBOutlet weak var LabelLimitForTheYearBalance: UILabel!
    @IBOutlet weak var LabelAmountDisbursedPeriod: UILabel!
    @IBOutlet weak var LabelAmountDisbursedBalance: UILabel!
    @IBOutlet weak var LabelBalanceAvailable: UILabel!
    
    @IBOutlet weak var CustomOkBtnAmountBalancePopup: UIView!
    
    
    
    func OpenClaimAmountBalancePopup(){
        blurEffect()
        self.view.addSubview(ViewAmountBalance)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        ViewAmountBalance.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        ViewAmountBalance.center = self.view.center
        ViewAmountBalance.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        ViewAmountBalance.alpha = 0
        ViewAmountBalance.sizeToFit()
        
        
        CustomOkBtnAmountBalancePopup.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
        /*  stackViewButtonborder.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 1)
         view_custom_btn_punchout.addBorder(side: .right, color: UIColor(hexFromString: "7F7F7F"), width: 1)*/
        LoadPopupClaimAmountData(year: "2021")
        
        
        
        UIView.animate(withDuration: 0.3){
            self.ViewAmountBalance.alpha = 1
            self.ViewAmountBalance.transform = CGAffineTransform.identity
        }
        
    }
    
    func CancelClaimAmountBalancePopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewAmountBalance.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ViewAmountBalance.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.ViewAmountBalance.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    
    //--------function to load popup leave data using Alamofire and Json Swifty code starts----------
    func LoadPopupClaimAmountData(year: String?){
        //        loaderStart()
        let url = "\(BASE_URL)mediclaim/balance/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/\(year!)"
        print("url-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            //                self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Year description: \(swiftyJsonVar)")
                self.LabelUtilizedAmount.text = String(describing:swiftyJsonVar["unutilized_amt"].double!)
                self.LabelLimitForTheYearBalance.text =
                    String(describing:swiftyJsonVar["limit_amt"].double!)
                self.LabelAmountDisbursedBalance.text = String(describing:swiftyJsonVar["disbursed_amt"].double!)
                self.LabelBalanceAvailable.text = String(describing:swiftyJsonVar["balanced_amt"].double!)
                
            }
            
            
        }
        
    }
    //---Leave PopupOk
    @objc func ClaimAmountBalancePopupOk(tapGestureRecognizer: UITapGestureRecognizer){
        CancelClaimAmountBalancePopup()
    }
    //--------function to load popup leave data using Alamofire and Json Swifty code ends----------
    //============================Form Leave Balance dialog, code ends============================
    
    //=========function to make json object and save data, code starts======
    var collectUpdatedDetailsData = [Any]()
    func makeJsonObjectAndSaveDataToServer(mediclaim_id: Int, mediclaim_no: String, mediclaim_amount: String, approved_mediclaim_amount: String, description: String, supervisor_remark: String, mediclaim_status: String, approved_by_id: Int, approved_by_name: String, payment_remark: String, payment_amount: String){
        var getData = [String:AnyObject]()
        print("LtaCount-=>",SupportingDocumentsViewController.tableChildData.count)
        
        if !collectUpdatedDetailsData.isEmpty{
            self.collectUpdatedDetailsData.removeAll()
        }
        
        for i in 0..<SupportingDocumentsViewController.tableChildData.count{
            getData.updateValue(SupportingDocumentsViewController.tableChildData[i].document_name! as AnyObject, forKey: "file_name")
            getData.updateValue(SupportingDocumentsViewController.tableChildData[i].document_base64! as AnyObject, forKey: "file_base64")
            
            collectUpdatedDetailsData.append(getData)
        }
        let sentData: [String: Any] = [
            "corp_id": swiftyJsonvar1["company"]["corporate_id"].stringValue,
            "mediclaim_id": mediclaim_id,
            "mediclaim_no": mediclaim_no,
            "employee_id": swiftyJsonvar1["employee"]["employee_id"].intValue,
            "mediclaim_amount": Double(mediclaim_amount)!,
            "approved_mediclaim_amount": Double(approved_mediclaim_amount)!,
            "description": description,
            "supervisor_remark": supervisor_remark,
            "mediclaim_status": mediclaim_status,
            "approved_by_id": approved_by_id,
            "approved_by_name": approved_by_name,
            "payment_remark": payment_remark,
            "payment_amount": Double(payment_amount)!,
            "documents": collectUpdatedDetailsData
        ]
        
        print("SentData-=>",sentData)
        let url = "\(BASE_URL)mediclaim/save"
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
                        if SupportingDocumentsViewController.tableChildData.count > 0 {
                            SupportingDocumentsViewController.tableChildData.removeAll()
                            self.collectUpdatedDetailsData.removeAll()
                            //                            self.loadData()
                        }
                    
                        if MediclaimListViewController.EmployeeType == "Supervisor" {
                            self.performSegue(withIdentifier: "subordinatemediclaimlist", sender: nil)
                        }
                        if MediclaimListViewController.EmployeeType == "Employee" {
                            self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
                        }
                        //                                self.tableViewEmpTask.reloadData()
                        
                    })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)
                    
                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                }else{
//                    OdDutyLogEmployeeTaskViewController.back_btn_save_unsave_check = 0
                    
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageColor = .white
                    
                    // present the toast with the new style
                    self.view.makeToast(swiftyJsonVar["message"].stringValue, duration: 3.0, position: .bottom, style: style)
                    
                    print("Error-=>",swiftyJsonVar["message"].stringValue)
                    
                    if MediclaimListViewController.EmployeeType == "Supervisor" {
                        self.performSegue(withIdentifier: "subordinatemediclaimlist", sender: nil)
                    }
                    if MediclaimListViewController.EmployeeType == "Employee" {
                        self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
                    }
                }
                
                break
                
            case .failure(let error):
                //                        self.loaderEnd()
                print("Error: ", error)
            }
        }
    }
    //=========function to make json object and save data, code ends======
    //--------function to load document details using Alamofire and Json Swifty(added on 2-Jul-2021------------
    func loadData(mediclaim_id: Int!){
        loaderStart()
        
        let url = "\(BASE_URL)mediclaim/detail/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(mediclaim_id!)"
        print("MediclaimDocumentDetails-=>",url)
        AF.request(url).responseJSON{ (responseData) -> Void in
            self.loaderEnd()
            if((responseData.value) != nil){
                let swiftyJsonVar=JSON(responseData.value!)
                print("Doc description: \(swiftyJsonVar)")
                
                self.TxtMediclaimNo.text = swiftyJsonVar["fields"]["mediclaim_no"].stringValue
                if MediclaimListViewController.new_create_yn == true{
                    self.TxtEmployeeName.text = self.swiftyJsonvar1["employee"]["full_employee_name"].stringValue
                }else{
                    self.TxtEmployeeName.text = MediclaimListViewController.employee_name!
                }
                self.TxtMediclaimAmount.text = String(swiftyJsonVar["fields"]["mediclaim_amount"].doubleValue)
                self.TxtReason.text = swiftyJsonVar["fields"]["description"].stringValue
                self.TxtApprovedAmount.text = String(swiftyJsonVar["fields"]["approved_mediclaim_amount"].doubleValue)
                self.TxtViewApprovalRemark.text = swiftyJsonVar["fields"]["supervisor_remark"].stringValue
                self.TxtApplicationStatus.text = swiftyJsonVar["fields"]["mediclaim_status"].stringValue
                
                if swiftyJsonVar["documents"] != ""{
//                    UserSingletonModel.sharedInstance.documents = swiftyJsonVar
                    for (key,value) in  swiftyJsonVar["documents"]{
                        var data = DocumentDetails()
                        data.document_name = value["file_name"].stringValue
                        data.document_base64 = value["file_base64"].stringValue
                        SupportingDocumentsViewController.tableChildData.append(data)
                    }
                }
                
                if SupportingDocumentsViewController.tableChildData.count > 0 {
                    self.TxtSupportingDocuments.text = "\(SupportingDocumentsViewController.tableChildData.count) Document(s)"
                }else{
                    self.TxtSupportingDocuments.text = "0 Document(s)"
                }
                
            }
            
        }
    }
    //--------function to load document details using Alamofire and Json Swifty code ends------------
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
