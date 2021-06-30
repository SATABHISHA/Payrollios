//
//  MediclaimRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/06/21.
//

import UIKit

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
    @IBOutlet weak var StackViewButtons: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        LoadButtons()
        

        
        //ViewDocs
        let tapGestureRecognizerDocView = UITapGestureRecognizer(target: self, action: #selector(DocView(tapGestureRecognizer:)))
        ViewCustomBtnViewDocuments.isUserInteractionEnabled = true
        ViewCustomBtnViewDocuments.addGestureRecognizer(tapGestureRecognizerDocView)
    }
   
    //---ViewDocs
    @objc func DocView(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "supportingdoc", sender: nil)
        
    }
    
    //----function to load buttons acc to the logic, code starts
    func LoadButtons(){
        StackViewButtons.addBorder(side: .top, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnReturn.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnApprove.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnSubmit.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewBtnSave.addBorder(side: .left, color: UIColor(hexFromString: "7F7F7F"), width: 0.6)
        ViewCustomBtnViewDocuments.addBorder(side: .left, color: UIColor(hexFromString: "000000"), width: 0.6)
        
       
    }
    //----function to load buttons acc to the logic, code ends
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "mediclaimlist", sender: nil)
    }
    
}
