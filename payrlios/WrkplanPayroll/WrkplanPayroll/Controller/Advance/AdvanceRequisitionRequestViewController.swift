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

class AdvanceRequisitionRequestViewController: UIViewController {

    @IBOutlet weak var btn_reason_select_type: UIButton!
    let dropDown = DropDown()
    var type = [String]()
    
    @IBOutlet weak var TxtApplicationStatus: UITextField!
    @IBOutlet weak var TxtViewApprovalRemark: UITextView!
    @IBOutlet weak var TxtApprovedAmount: UITextField!
    @IBOutlet weak var TxtReturnPeriod: UITextField!
    @IBOutlet weak var TxtViewNarration: UITextView!
    @IBOutlet weak var TxtRequisitionAmount: UITextField!
    @IBOutlet weak var TxtCtc: UITextField!
    @IBOutlet weak var TxtRequisitionNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeStatusBarColor() //---to change background statusbar color
        
        //---code to customize dropdown button starts------
        let buttonWidth = btn_reason_select_type.frame.width
        let imageWidth = btn_reason_select_type.imageView!.frame.width
        
        btn_reason_select_type.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        btn_reason_select_type.titleEdgeInsets = UIEdgeInsets(top: 0, left: -28, bottom: 0, right: imageWidth)
        btn_reason_select_type.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-70, bottom: 0, right: 0)
        //---code to customize dropdown button ends------
        
        //----code to append dropdown data, starts------
        type.append("i) Serious and / prolonged illness in the family ('Family' means self, wife and dependent children) of the employee.")
        type.append("ii) His / her own marriage.")
        type.append("iii) Son’s / Daughter’s or real Sister’s marriage.")
        type.append("iv) Rehabilitation due to natural calamity, such as flood, fire, accident etc.")
        //----code to append dropdown data, ends------
        
        TxtRequisitionNo.setLeftPaddingPoints(2)
        TxtRequisitionAmount.setRightPaddingPoints(2)
        TxtApprovedAmount.setRightPaddingPoints(2)
        TxtApplicationStatus.setLeftPaddingPoints(2)
        TxtRequisitionNo.text = AdvanceRequisitionListViewController.requisition_no
        TxtRequisitionAmount.text = String(AdvanceRequisitionListViewController.requisition_amount)
        TxtViewNarration.text = AdvanceRequisitionListViewController.description
        TxtApprovedAmount.text = String(AdvanceRequisitionListViewController.approved_requisition_amount)
        TxtViewApprovalRemark.text = AdvanceRequisitionListViewController.supervisor_remark
        TxtApplicationStatus.text = AdvanceRequisitionListViewController.requisition_status
        
    }
    
    
    @IBAction func BtnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "advancehome", sender: nil)
    }
    
    @IBAction func BtnDropDownSelect(_ sender: UIButton) {
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
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
    }
    }
    
   

}