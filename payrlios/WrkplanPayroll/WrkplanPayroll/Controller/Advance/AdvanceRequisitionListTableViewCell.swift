//
//  AdvanceRequisitionListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 15/06/21.
//

import UIKit

class AdvanceRequisitionListTableViewCell: UITableViewCell {

    @IBOutlet weak var custom_img_btn_delete: UIImageView!
    @IBOutlet weak var view_parent: UIView!
    @IBOutlet weak var label_od_no: UILabel!
    @IBOutlet weak var label_od_date: UILabel!
    @IBOutlet weak var label_od_status: UILabel!
    @IBOutlet weak var label_amount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
