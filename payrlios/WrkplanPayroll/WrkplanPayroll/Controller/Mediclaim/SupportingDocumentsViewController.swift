//
//  SupportingDocumentsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/06/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftyJSON
import Alamofire

struct DocumentDetails{
    var document_id: Int!
    var document_name: String!
    var document_size: String!
    var document_base64: String!
    var lta_file_from_api_yn: Bool
    init(document_id: Int!, document_name: String!, document_size: String!, document_base64: String!, lta_file_from_api_yn: Bool) {
        self.document_id = document_id
        self.document_name = document_name
        self.document_size = document_size
        self.document_base64 = document_base64
        self.lta_file_from_api_yn = lta_file_from_api_yn
    }
    
}
class SupportingDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, SupportingDocumentsTableViewCellDelegate {
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    @IBOutlet weak var TableViewSupportingDocuments: UITableView!
    @IBOutlet var ImgViewCustomBtnAddDocs: UIView!
    @IBOutlet weak var StackViewBtns: UIStackView!
    @IBOutlet weak var ViewBtnCancel: UIView!
    @IBOutlet weak var ViewBtnDone: UIView!
    @IBOutlet weak var ImageViewCustomBtnAddDoc: UIImageView!
    
    static var tableChildData = [DocumentDetails]()
    var tableTemporaryChildData = [DocumentDetails]()
    static var deletedTableChildData = [DocumentDetails]()
    var collectUpdatedDetailsData = [Any]()
    static var DocumentBase64String: String!, row_position_to_delete: Int!, FileName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        self.TableViewSupportingDocuments.delegate = self
        self.TableViewSupportingDocuments.dataSource = self
        
        TableViewSupportingDocuments.backgroundColor = UIColor(hexFromString: "ffffff")
        //        TableViewSupportingDocuments.searchTextField.backgroundColor = UIColor.white
//        TableViewSupportingDocuments.backgroundColor = UIColor.white
        //        TableViewSupportingDocuments.searchTextField.textColor = UIColor.black
        
        LoadButtons()
        if tableTemporaryChildData.count > 0{
            tableTemporaryChildData.removeAll()
        }
        tableTemporaryChildData = SupportingDocumentsViewController.tableChildData
        CheckTableDataExistsOrNot()
       
        //ViewDone
        let tapGestureRecognizerDoneView = UITapGestureRecognizer(target: self, action: #selector(DoneView(tapGestureRecognizer:)))
        ViewBtnDone.isUserInteractionEnabled = true
        ViewBtnDone.addGestureRecognizer(tapGestureRecognizerDoneView)
        
        //ViewCancel
        let tapGestureRecognizerCancelView = UITapGestureRecognizer(target: self, action: #selector(CancelView(tapGestureRecognizer:)))
        ViewBtnCancel.isUserInteractionEnabled = true
        ViewBtnCancel.addGestureRecognizer(tapGestureRecognizerCancelView)
        
        //AddDocs
        let tapGestureRecognizerAddDocsView = UITapGestureRecognizer(target: self, action: #selector(AddDocView(tapGestureRecognizer:)))
        ImageViewCustomBtnAddDoc.isUserInteractionEnabled = true
        ImageViewCustomBtnAddDoc.addGestureRecognizer(tapGestureRecognizerAddDocsView)
        
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        if SupportingDocumentsViewController.deletedTableChildData.count > 0 {
            SupportingDocumentsViewController.deletedTableChildData.removeAll()
         }
        self.dismiss(animated: true, completion: nil)
    }
    //---AddDocs
    @objc func AddDocView(tapGestureRecognizer: UITapGestureRecognizer){
        
        let types: [String] = [kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    //---ViewDone
    @objc func DoneView(tapGestureRecognizer: UITapGestureRecognizer){
//        self.performSegue(withIdentifier: "mediclaimrequest", sender: nil)
        if SupportingDocumentsViewController.tableChildData.count > 0 {
            SupportingDocumentsViewController.tableChildData.removeAll()
            
         }
        SupportingDocumentsViewController.tableChildData = tableTemporaryChildData
        self.dismiss(animated: true, completion: nil)
        
    }
    //---ViewCancel
    @objc func CancelView(tapGestureRecognizer: UITapGestureRecognizer){
//        openCancelConfirmationPopup() //-----commented on 28th july
        if SupportingDocumentsViewController.deletedTableChildData.count > 0 {
            SupportingDocumentsViewController.deletedTableChildData.removeAll()
         }
        self.dismiss(animated: true, completion: nil) //--added on 28th July
        
    }
    
    //----function to load buttons acc to the logic, code starts
    func LoadButtons(){
        StackViewBtns.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnDone.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        
        
    }
    //----function to load buttons acc to the logic, code ends
    
    //----function to check tabledata exists or not, code starts
    func CheckTableDataExistsOrNot(){
        if tableTemporaryChildData.count > 0 {
            self.TableViewSupportingDocuments.backgroundView?.isHidden = true
             TableViewSupportingDocuments.reloadData()
         }else{
            TableViewSupportingDocuments.reloadData()
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.TableViewSupportingDocuments.bounds.size.width, height: self.TableViewSupportingDocuments.bounds.size.height))
            noDataLabel.text          = "No record found"
            noDataLabel.font = UIFont.systemFont(ofSize: 14)
            noDataLabel.textColor     = UIColor(hexFromString: "767575")
            noDataLabel.textAlignment = .center
            self.TableViewSupportingDocuments.backgroundView?.isHidden = false
            self.TableViewSupportingDocuments.backgroundView  = noDataLabel
            self.TableViewSupportingDocuments.separatorStyle  = .none
         }
    }
    //----function to check tabledata exists or not, code ends
    
    //----------tableview code starts------------
    
    func SupportingDocumentsTableViewCellRemoveDidTapAddOrView(_ sender: SupportingDocumentsTableViewCell) {
        guard let tappedIndexPath = TableViewSupportingDocuments.indexPath(for: sender) else {return}
        SupportingDocumentsViewController.row_position_to_delete = tappedIndexPath.row
        //        SupportingDocumentsViewController.tableChildData.remove(at: tappedIndexPath.row)
        //        TableViewSupportingDocuments.reloadData()
        openDeleteConfirmationPopup()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return SupportingDocumentsViewController.tableChildData.count
        return tableTemporaryChildData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SupportingDocumentsTableViewCell
        
        cell.delegate = self
//        let dict = SupportingDocumentsViewController.tableChildData[indexPath.row]
        let dict = tableTemporaryChildData[indexPath.row]
        cell.LabelPdfName.text = dict.document_name
        cell.LabelPdfSize.text = dict.document_size
        cell.LabelSerialNo.text = String(indexPath.row + 1)
        
        if MediclaimListViewController.EmployeeType == "Employee"{
            if MediclaimListViewController.mediclaim_status! == ""{
                cell.BtnRemove.isHidden = false
                ImageViewCustomBtnAddDoc.isHidden = false
                StackViewBtns.isHidden = false
                
            }
            if MediclaimListViewController.mediclaim_status! == "Saved"{
                cell.BtnRemove.isHidden = false
                ImageViewCustomBtnAddDoc.isHidden = false
                StackViewBtns.isHidden = false
            }
            if MediclaimListViewController.mediclaim_status! == "Submitted" ||
                MediclaimListViewController.mediclaim_status! == "Approved" ||
                MediclaimListViewController.mediclaim_status! == "Payment done" ||
                MediclaimListViewController.mediclaim_status! == "Cancelled"{
                cell.BtnRemove.isHidden = true
                ImageViewCustomBtnAddDoc.isHidden = true
                StackViewBtns.isHidden = false
                
                ViewBtnDone.isHidden = true
                ViewBtnCancel.isHidden = false
            }
            if MediclaimListViewController.mediclaim_status! == "Returned"{
                cell.BtnRemove.isHidden = false
                ImageViewCustomBtnAddDoc.isHidden = false
                StackViewBtns.isHidden = false
            }
        }
        if MediclaimListViewController.EmployeeType == "Supervisor"{
            if MediclaimListViewController.mediclaim_status! == "Submitted"{
                cell.BtnRemove.isHidden = true
                ImageViewCustomBtnAddDoc.isHidden = true
                StackViewBtns.isHidden = false
                
                ViewBtnDone.isHidden = true
                ViewBtnCancel.isHidden = false
            }
            if MediclaimListViewController.mediclaim_status! == "Returned" ||
                MediclaimListViewController.mediclaim_status! == "Approved" ||
                MediclaimListViewController.mediclaim_status! == "Payment done" ||
                MediclaimListViewController.mediclaim_status! == "Cancelled"{
                cell.BtnRemove.isHidden = true
                ImageViewCustomBtnAddDoc.isHidden = true
                StackViewBtns.isHidden = false
                
                ViewBtnDone.isHidden = true
                ViewBtnCancel.isHidden = false
            }
        }
        return cell
        
    }
    //---------onClick tableview code starts(This onclick will work to show pdf view in webview)----------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let row = SupportingDocumentsViewController.tableChildData[indexPath.row]
        let row = tableTemporaryChildData[indexPath.row]
        print(row)
        print("tap is working")
        
        SupportingDocumentsViewController.DocumentBase64String = row.document_base64
        SupportingDocumentsViewController.FileName = row.document_name
        
        self.performSegue(withIdentifier: "MediclaimPdf", sender: nil)
    }
    //---------onClick tableview code ends----------
    //----------tableview code ends------------
    
    //------code to pick documents from phone, starts
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        do{
            let resources = try myURL.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            let filename = myURL.lastPathComponent
            print("filesize-=>",covertToFileString(with: UInt64(fileSize)))
            print("filename-=>",filename)
            
            //        code to convert into base64
            let fileData = try Data.init(contentsOf: myURL)
            let fileStream = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            let decodeData = Data(base64Encoded: fileStream, options: .ignoreUnknownCharacters)
//            print("base64fileTesting-=>", fileStream)
            
            //--code to save data in array dictionary, starts
//            var data = DocumentDetails()
            let data = DocumentDetails(document_id: 0, document_name: filename, document_size: covertToFileString(with: UInt64(fileSize)), document_base64: fileStream, lta_file_from_api_yn: false)
          /*  data.document_name = filename
            data.document_size = covertToFileString(with: UInt64(fileSize))
            data.document_base64 = fileStream*/
            
            
//            SupportingDocumentsViewController.tableChildData.append(data)
            tableTemporaryChildData.append(data)
            
//            TableViewSupportingDocuments.reloadData()
           /* if SupportingDocumentsViewController.tableChildData.count > 0 {
                TableViewSupportingDocuments.reloadData()
            }else{
            CheckTableDataExistsOrNot()
            }*/
            CheckTableDataExistsOrNot()
            
        }catch {
            print("Error: \(error)")
        }
        
        
        
    }
    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    /*func clickFunction(){
     
     let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
     importMenu.delegate = self
     importMenu.modalPresentationStyle = .formSheet
     self.present(importMenu, animated: true, completion: nil)
     }*/
    //------code to pick documents from phone, ends
    
    //==============FormDialog Delete Confirmation code starts================
    @IBOutlet var viewDeleteConfirmationPopup: UIView!
    
    func openDeleteConfirmationPopup(){
        blurEffect()
        self.view.addSubview(viewDeleteConfirmationPopup)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewDeleteConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewDeleteConfirmationPopup.center = self.view.center
        viewDeleteConfirmationPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewDeleteConfirmationPopup.alpha = 0
        viewDeleteConfirmationPopup.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.viewDeleteConfirmationPopup.alpha = 1
            self.viewDeleteConfirmationPopup.transform = CGAffineTransform.identity
        }
    }
    func cancelDeleteConfirmationPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewDeleteConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewDeleteConfirmationPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewDeleteConfirmationPopup.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    @IBAction func btnDeleteConfirmationPopupYes(_ sender: Any) {
        cancelDeleteConfirmationPopup()
        
        let position = SupportingDocumentsViewController.row_position_to_delete!
         if tableTemporaryChildData[SupportingDocumentsViewController.row_position_to_delete].lta_file_from_api_yn == true {
            let data = DocumentDetails(document_id: tableTemporaryChildData[position].document_id, document_name: tableTemporaryChildData[position].document_name, document_size: tableTemporaryChildData[position].document_size, document_base64: tableTemporaryChildData[position].document_base64, lta_file_from_api_yn: tableTemporaryChildData[position].lta_file_from_api_yn)
            SupportingDocumentsViewController.deletedTableChildData.append(data)
        }
        tableTemporaryChildData.remove(at: SupportingDocumentsViewController.row_position_to_delete)
//        TableViewSupportingDocuments.reloadData()
//        CheckTableDataExistsOrNot() //--if data not exists then it would show message
        print("tablecounttesting-=>", SupportingDocumentsViewController.tableChildData.count)
        
//        TableViewSupportingDocuments.reloadData()
        CheckTableDataExistsOrNot()
    }
    
    @IBAction func btnCancelPopup(_ sender: Any) {
        cancelDeleteConfirmationPopup()
    }
    //==============FormDialog Delete Confirmation code ends================
    
    
    //==============FormDialog Cancel Confirmation code starts================
    @IBOutlet var viewCancelConfirmationPopup: UIView!
    
    func openCancelConfirmationPopup(){
        blurEffect()
        self.view.addSubview(viewCancelConfirmationPopup)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        viewCancelConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        viewCancelConfirmationPopup.center = self.view.center
        viewCancelConfirmationPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        viewCancelConfirmationPopup.alpha = 0
        viewCancelConfirmationPopup.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.viewCancelConfirmationPopup.alpha = 1
            self.viewCancelConfirmationPopup.transform = CGAffineTransform.identity
        }
    }
    func cancelConfirmationPopup(){
        UIView.animate(withDuration: 0.3, animations: {
            self.viewCancelConfirmationPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewCancelConfirmationPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.viewCancelConfirmationPopup.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    
    @IBAction func btnCancelTaskConfirmationPopupYes(_ sender: Any) {
        cancelConfirmationPopup()
       /* if SupportingDocumentsViewController.tableChildData.count > 0 {
            SupportingDocumentsViewController.tableChildData.removeAll()
        }
        self.performSegue(withIdentifier: "mediclaimrequest", sender: nil)*/
        
        self.dismiss(animated: true, completion: nil) //--added on 28th July
        
    }
    
    @IBAction func btnCancelTaskConfirmationPopupNo(_ sender: Any) {
        cancelConfirmationPopup()
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
