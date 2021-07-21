//
//  SubordinateLtaTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 21/07/21.
//

import UIKit

class SubordinateLtaTableViewCell: UITableViewCell {
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var LabelLtaNo: UILabel!
    @IBOutlet weak var LabelLtaAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
