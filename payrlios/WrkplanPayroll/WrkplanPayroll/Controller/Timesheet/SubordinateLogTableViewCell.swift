//
//  SubordinateLogTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/12/20.
//

import UIKit

class SubordinateLogTableViewCell: UITableViewCell {

    @IBOutlet weak var label_emp_name: UILabel!
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
