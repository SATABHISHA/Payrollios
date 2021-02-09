//
//  TimesheetMyAttendanceTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 08/12/20.
//

import UIKit

class TimesheetMyAttendanceTableViewCell: UITableViewCell {

    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_time: UILabel!
    @IBOutlet weak var label_in_out_status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
