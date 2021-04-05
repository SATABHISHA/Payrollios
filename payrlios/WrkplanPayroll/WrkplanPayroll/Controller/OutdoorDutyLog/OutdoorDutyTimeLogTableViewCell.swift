//
//  OutdoorDutyTimeLogTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 05/04/21.
//

import UIKit

class OutdoorDutyTimeLogTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelStartStop: UILabel!
    @IBOutlet weak var LabelTime: UILabel!
    @IBOutlet weak var LabelLatitude: UILabel!
    @IBOutlet weak var LabelLongitude: UILabel!
    @IBOutlet weak var LabelAddress: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  

}
