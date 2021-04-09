//
//  SubordinateLeaveApplicationTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 09/04/21.
//

import UIKit

class SubordinateLeaveApplicationTableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var ViewContainer: UIView!
    @IBOutlet weak var LabelApplicationCode: UILabel!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelLeaveType: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var LabelLeaveStatus: UILabel!
    @IBOutlet weak var LabelDayCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
