//
//  MyAttendanceLogTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 04/12/20.
//

import UIKit

class MyAttendanceLogTableViewCell: UITableViewCell {

    @IBOutlet weak var label_day_name: UILabel!
    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_timein: UILabel!
    @IBOutlet weak var label_timeout: UILabel!
    @IBOutlet weak var label_status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
