//
//  HomeNavigationControllerTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 12/04/21.
//

import UIKit

class HomeNavigationControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var viewNavigationCell: UIView!
    @IBOutlet weak var imageViewMenu: UIImageView!
    @IBOutlet weak var labelMenuItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
