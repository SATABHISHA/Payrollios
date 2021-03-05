//
//  OutDoorDutyRequestViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/03/21.
//

import UIKit
import DropDown

class OutDoorDutyRequestViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txt_employee_name: UITextField!
    @IBOutlet weak var txt_requisition_no: UITextField!
    @IBOutlet weak var img_from_date: UIImageView!
    @IBOutlet weak var img_to_date: UIImageView!
    @IBOutlet weak var txt_view_reason: UITextView!
    @IBOutlet weak var txt_view_remarks: UITextView!
    @IBOutlet weak var label_from_date: UILabel!
    @IBOutlet weak var label_to_date: UILabel!
    @IBOutlet weak var txt_from_date: UITextField!
    @IBOutlet weak var txt_to_date: UITextField!
    
    var from_date: Bool = false
    var to_date: Bool = false
    
    let dropDown = DropDown()
    var type = [String]()
    
//    var datePicker : UIDatePicker!
    let datePicker = UIDatePicker()

//    var datePicker  = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_from_date.delegate = self
        txt_to_date.delegate = self

        // Do any additional setup after loading the view.
       
        
        type.append("Work From Home")
        
//        showDatePicker()
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case self.txt_from_date:
            from_date = true
            to_date = false
            showDatePicker(txtfield: txt_from_date)
            break
        case self.txt_to_date:
            to_date = true
            from_date = false
            showDatePicker(txtfield: txt_to_date)
            break
        default:
            break
        }
    }
    
   
    //-----Date picker code starts
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
       formatter.dateFormat = "dd/MM/yyyy"
        if from_date == true {
       txt_from_date.text = formatter.string(from: datePicker.date)
        }
        if to_date == true{
            txt_to_date.text = formatter.string(from: datePicker.date)
            print("test-=>",daysBetween(start: txt_from_date.text!, end: txt_to_date.text!))
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
    
    //---code for dropdown on button click, starts
    @IBAction func btn_select_type(_ sender: UIButton) {
        dropDown.dataSource = type
        dropDown.anchorView = sender//5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
          sender.setTitle(item, for: .normal) //9
            sender.setTitleColor(UIColor(hexFromString: "000000"), for: .normal)
//            print("name-=>",SubordinateLogViewController.subordinate_details[index].slno!)

    }
    }
    //---code for dropdown on button click, ends
   

   

}

