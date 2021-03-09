//
//  SubordinateOutdoorDutyRequestListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 08/03/21.
//

import UIKit

class SubordinateOutdoorDutyRequestListTableViewCell: UITableViewCell {

    @IBOutlet weak var ViewParent: UIView!
    @IBOutlet weak var label_od_duty_no: UILabel!
    @IBOutlet weak var label_subordinate_name: UILabel!
    @IBOutlet weak var label_od_date: UILabel!
    @IBOutlet weak var label_od_status: UILabel!
    @IBOutlet weak var label_day_count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
