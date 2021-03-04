//
//  OutDoorDutyListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 01/03/21.
//

import UIKit

class OutDoorDutyListTableViewCell: UITableViewCell {

    @IBOutlet weak var view_parent: UIView!
    @IBOutlet weak var label_od_no: UILabel!
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
