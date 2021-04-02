//
//  OdDutyLogEmpTaskTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/04/21.
//

import UIKit

protocol OdDutyLogEmpTaskTableViewCellDelegate : class {
    func OdDutyLogEmpTaskTableViewCellDidTapDeleteTask(_ sender: OdDutyLogEmpTaskTableViewCell)
    func OdDutyLogEmpTaskTableViewCellDidTapEditTask(_ sender: OdDutyLogEmpTaskTableViewCell)
}
class OdDutyLogEmpTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var viewOdLogEmpTask: UIView!
    @IBOutlet weak var labelTaskName: UILabel!
    @IBOutlet weak var labelTaskDescription: UILabel!
    @IBOutlet weak var imgviewDeleteRecord: UIImageView!
    @IBOutlet weak var imgViewEditRecord: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //---Delete
        let tapGestureRecognizerDeleteTask = UITapGestureRecognizer(target: self, action: #selector(DeleteTaskTapped(tapGestureRecognizer:)))
        imgviewDeleteRecord.isUserInteractionEnabled = true
        imgviewDeleteRecord.addGestureRecognizer(tapGestureRecognizerDeleteTask)
        
        //---Edit
        let tapGestureRecognizerEditTask = UITapGestureRecognizer(target: self, action: #selector(EditTaskTapped(tapGestureRecognizer:)))
        imgViewEditRecord.isUserInteractionEnabled = true
        imgViewEditRecord.addGestureRecognizer(tapGestureRecognizerEditTask)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: OdDutyLogEmpTaskTableViewCellDelegate?
    @objc func DeleteTaskTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.OdDutyLogEmpTaskTableViewCellDidTapDeleteTask(self)
        
    }
    
    @objc func EditTaskTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.OdDutyLogEmpTaskTableViewCellDidTapEditTask(self)
        
    }

    
}
