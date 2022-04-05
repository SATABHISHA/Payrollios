//
//  NotificationHlomeTableViewCell.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 08/03/22.
//

import UIKit

class NotificationHlomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ViewEventId: UIView!
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var LabelEventId: UILabel!
    @IBOutlet weak var ViewContentChild: UIView!
    @IBOutlet weak var ViewContentParent: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
