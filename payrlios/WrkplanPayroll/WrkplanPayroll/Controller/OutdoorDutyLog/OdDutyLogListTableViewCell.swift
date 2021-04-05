//
//  OdDutyLogListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 31/03/21.
//

import UIKit


protocol OdDutyLogListTableViewCellDelegate : class {
    func OdDutyLogListTableViewCellDidTapView(_ sender: OdDutyLogListTableViewCell)
    func OdDutyLogListTableViewCellDidTapViewTimeLog(_ sender: OdDutyLogListTableViewCell)
}
class OdDutyLogListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        //---view task
        let tapGestureRecognizerViewTask = UITapGestureRecognizer(target: self, action: #selector(ViewTaskTapped(tapGestureRecognizer:)))
        label_view_task.isUserInteractionEnabled = true
        label_view_task.addGestureRecognizer(tapGestureRecognizerViewTask)
        
        //--view time log
        let tapGestureRecognizerViewTimeLog = UITapGestureRecognizer(target: self, action: #selector(ViewTimeLog(tapGestureRecognizer:)))
        label_time_log.isUserInteractionEnabled = true
        label_time_log.addGestureRecognizer(tapGestureRecognizerViewTimeLog)
    }

    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_time_log: UILabel!
    @IBOutlet weak var label_view_task: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    weak var delegate: OdDutyLogListTableViewCellDelegate?
    
    //---task
    @objc func ViewTaskTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.OdDutyLogListTableViewCellDidTapView(self)
        
    }
    //--time log
    @objc func ViewTimeLog(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.OdDutyLogListTableViewCellDidTapViewTimeLog(self)
        
    }

}
