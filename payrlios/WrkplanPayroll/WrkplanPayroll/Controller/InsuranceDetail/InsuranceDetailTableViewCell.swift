//
//  InsuranceDetailTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 27/11/20.
//

import UIKit

class InsuranceDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var label_member_relationship: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var label_member_name: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
