//
//  SupportingDocumentsViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/06/21.
//

import UIKit

class SupportingDocumentsViewController: UIViewController {

    @IBOutlet weak var TableViewSupportingDocuments: UITableView!
    @IBOutlet var ImgViewCustomBtnAddDocs: UIView!
    @IBOutlet weak var StackViewBtns: UIStackView!
    @IBOutlet weak var ViewBtnCancel: UIView!
    @IBOutlet weak var ViewBtnDone: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ChangeStatusBarColor() //---to change background statusbar color
        //ViewDone
        let tapGestureRecognizerDoneView = UITapGestureRecognizer(target: self, action: #selector(DoneView(tapGestureRecognizer:)))
        ViewBtnDone.isUserInteractionEnabled = true
        ViewBtnDone.addGestureRecognizer(tapGestureRecognizerDoneView)
        
        LoadButtons()
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

}
