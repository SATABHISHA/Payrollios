//
//  HolidayDetailsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/11/20.
//

import UIKit

class HolidayDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var label_holiday_count: UILabel!
    @IBOutlet weak var label_holiday_name: UILabel!
    @IBOutlet weak var label_holiday_date: UILabel!
    @IBOutlet weak var label_total_holiday: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
