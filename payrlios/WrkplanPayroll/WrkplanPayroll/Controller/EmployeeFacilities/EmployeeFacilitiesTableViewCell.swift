//
//  EmployeeFacilitiesTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 26/11/20.
//

import UIKit

class EmployeeFacilitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var label_employee_service_type: UILabel!
    @IBOutlet weak var label_employee_value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
