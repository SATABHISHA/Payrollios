//
//  OutDoorDutyListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 01/03/21.
//

import UIKit

protocol OutDoorDutyListTableViewCellDelegate : class {
    func OutDoorDutyListTableViewCellAddOrRemoveDidTapAddOrView(_ sender: OutDoorDutyListTableViewCell)
}
class OutDoorDutyListTableViewCell: UITableViewCell {

    @IBOutlet weak var custom_img_btn_delete: UIImageView!
    @IBOutlet weak var view_parent: UIView!
    @IBOutlet weak var label_od_no: UILabel!
    @IBOutlet weak var label_od_date: UILabel!
    @IBOutlet weak var label_od_status: UILabel!
    @IBOutlet weak var label_day_count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewCustomBtnAddOrRemoveTapped(tapGestureRecognizer:)))
        custom_img_btn_delete.isUserInteractionEnabled = true
        custom_img_btn_delete.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: OutDoorDutyListTableViewCellDelegate?
    @objc func ViewCustomBtnAddOrRemoveTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.OutDoorDutyListTableViewCellAddOrRemoveDidTapAddOrView(self)
        
    }

}
