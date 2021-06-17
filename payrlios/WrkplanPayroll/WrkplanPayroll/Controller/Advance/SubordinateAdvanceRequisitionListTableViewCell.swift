//
//  SubordinateAdvanceRequisitionListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 17/06/21.
//

import UIKit

class SubordinateAdvanceRequisitionListTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var LabelRequisitionNo: UILabel!
    @IBOutlet weak var LabelRequisitionAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
