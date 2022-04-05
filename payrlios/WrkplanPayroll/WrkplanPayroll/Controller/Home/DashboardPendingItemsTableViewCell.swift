//
//  DashboardPendingItemsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 05/04/22.
//

import UIKit

class DashboardPendingItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var ViewParent: UIView!
    @IBOutlet weak var ViewChild: UIView!
    @IBOutlet weak var ViewEventNameAbbreviation: UIView!
    @IBOutlet weak var LabelEventNameAbbreviation: UILabel!
    @IBOutlet weak var LabelEventStatus: UILabel!
    @IBOutlet weak var LabelEventType: UILabel!
    @IBOutlet weak var LabelEventOwnerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
