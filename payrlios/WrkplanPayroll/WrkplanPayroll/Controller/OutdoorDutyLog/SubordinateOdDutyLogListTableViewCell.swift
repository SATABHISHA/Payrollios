//
//  SubordinateOdDutyLogListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 02/04/21.
//

import UIKit

protocol SubordinateOdDutyLogListTableViewCellDelegate : class {
    func SubordinateOdDutyLogListTableViewCellDidTapView(_ sender: SubordinateOdDutyLogListTableViewCell)
    func SubordinateOdDutyLogListTableViewCellDidTapViewTimeLog(_ sender: SubordinateOdDutyLogListTableViewCell)
}
class SubordinateOdDutyLogListTableViewCell: UITableViewCell {
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var label_time_log: UILabel!
    @IBOutlet weak var label_view_task: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //--task
        let tapGestureRecognizerViewTask = UITapGestureRecognizer(target: self, action: #selector(SubordinateViewTaskTapped(tapGestureRecognizer:)))
        label_view_task.isUserInteractionEnabled = true
        label_view_task.addGestureRecognizer(tapGestureRecognizerViewTask)
        
        //--view time log
        let tapGestureRecognizerViewTimeLog = UITapGestureRecognizer(target: self, action: #selector(ViewTimeLog(tapGestureRecognizer:)))
        label_time_log.isUserInteractionEnabled = true
        label_time_log.addGestureRecognizer(tapGestureRecognizerViewTimeLog)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    weak var delegate: SubordinateOdDutyLogListTableViewCellDelegate?
    @objc func SubordinateViewTaskTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.SubordinateOdDutyLogListTableViewCellDidTapView(self)
        
    }
    
    //--time log
    @objc func ViewTimeLog(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.SubordinateOdDutyLogListTableViewCellDidTapViewTimeLog(self)
        
    }
}
