//
//  SupportingDocumentsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/06/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

struct DocumentDetails{
//    var document_id: Int!
    var document_name: String!
    var document_size: String!
    var document_base64: String!
    
}
class SupportingDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, SupportingDocumentsTableViewCellDelegate {
    
    @IBOutlet weak var TableViewSupportingDocuments: UITableView!
    @IBOutlet var ImgViewCustomBtnAddDocs: UIView!
    @IBOutlet weak var StackViewBtns: UIStackView!
    @IBOutlet weak var ViewBtnCancel: UIView!
    @IBOutlet weak var ViewBtnDone: UIView!
    @IBOutlet weak var ImageViewCustomBtnAddDoc: UIImageView!
    
    static var tableChildData = [DocumentDetails]()
    var collectUpdatedDetailsData = [Any]()
    static var DocumentBase64String: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        self.TableViewSupportingDocuments.delegate = self
        self.TableViewSupportingDocuments.dataSource = self
        
        TableViewSupportingDocuments.backgroundColor = UIColor(hexFromString: "ffffff")
//        TableViewSupportingDocuments.searchTextField.backgroundColor = UIColor.white
        TableViewSupportingDocuments.backgroundColor = UIColor.white
//        TableViewSupportingDocuments.searchTextField.textColor = UIColor.black
        
        LoadButtons()
        
        //ViewDone
        let tapGestureRecognizerDoneView = UITapGestureRecognizer(target: self, action: #selector(DoneView(tapGestureRecognizer:)))
        ViewBtnDone.isUserInteractionEnabled = true
        ViewBtnDone.addGestureRecognizer(tapGestureRecognizerDoneView)
        
        //AddDocs
        let tapGestureRecognizerAddDocsView = UITapGestureRecognizer(target: self, action: #selector(AddDocView(tapGestureRecognizer:)))
        ImageViewCustomBtnAddDoc.isUserInteractionEnabled = true
        ImageViewCustomBtnAddDoc.addGestureRecognizer(tapGestureRecognizerAddDocsView)
        
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
        self.performSegue(withIdentifier: "mediclaimrequest", sender: nil)
        
    }

    //----function to load buttons acc to the logic, code starts
    func LoadButtons(){
        StackViewBtns.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnDone.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        
       
    }
    //----function to load buttons acc to the logic, code ends
    
    
    //----------tableview code starts------------

    func SupportingDocumentsTableViewCellRemoveDidTapAddOrView(_ sender: SupportingDocumentsTableViewCell) {
        guard let tappedIndexPath = TableViewSupportingDocuments.indexPath(for: sender) else {return}
        SupportingDocumentsViewController.tableChildData.remove(at: tappedIndexPath.row)
        TableViewSupportingDocuments.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupportingDocumentsViewController.tableChildData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SupportingDocumentsTableViewCell

        cell.delegate = self
        let dict = SupportingDocumentsViewController.tableChildData[indexPath.row]
        cell.LabelPdfName.text = dict.document_name
        cell.LabelPdfSize.text = dict.document_size
        cell.LabelSerialNo.text = String(indexPath.row + 1)
        return cell
        
    }
    //---------onClick tableview code starts----------
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let row = SupportingDocumentsViewController.tableChildData[indexPath.row]
            print(row)
            print("tap is working")
           
            SupportingDocumentsViewController.DocumentBase64String = row.document_base64
           
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
            print("base64fileTesting-=>", fileStream)
            
            //--code to save data in array dictionary, starts
            var data = DocumentDetails()
            data.document_name = filename
            data.document_size = covertToFileString(with: UInt64(fileSize))
            data.document_base64 = fileStream
            
            
            SupportingDocumentsViewController.tableChildData.append(data)
            
            TableViewSupportingDocuments.reloadData()
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
    
   
}
