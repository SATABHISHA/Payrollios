//
//  ReportsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/05/21.
//

import UIKit

protocol ReportsTableViewCellDelegate : class {
    func ReportsItemTableViewCellDidTapView(_ sender: ReportsTableViewCell)
}

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var LabelViewItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //---view Item
        let tapGestureRecognizerViewItem = UITapGestureRecognizer(target: self, action: #selector(ViewItemTapped(tapGestureRecognizer:)))
        LabelViewItem.isUserInteractionEnabled = true
        LabelViewItem.addGestureRecognizer(tapGestureRecognizerViewItem)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    weak var delegate: ReportsTableViewCellDelegate?
    //---item
    @objc func ViewItemTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.ReportsItemTableViewCellDidTapView(self)
        
    }
}
