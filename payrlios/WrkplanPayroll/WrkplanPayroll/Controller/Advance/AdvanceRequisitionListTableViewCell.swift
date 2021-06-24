//
//  AdvanceRequisitionListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 15/06/21.
//

import UIKit

protocol AdvanceRequisitionListTableViewCellDelegate : class {
    func AdvanceRequisitionListTableViewCellRemoveDidTapAddOrView(_ sender: AdvanceRequisitionListTableViewCell)
}
class AdvanceRequisitionListTableViewCell: UITableViewCell {

    @IBOutlet weak var custom_img_btn_delete: UIImageView!
    @IBOutlet weak var view_parent: UIView!
    @IBOutlet weak var label_od_no: UILabel!
    @IBOutlet weak var label_od_date: UILabel!
    @IBOutlet weak var label_od_status: UILabel!
    @IBOutlet weak var label_amount: UILabel!
    @IBOutlet weak var image_view_delete: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewCustomBtnRemoveTapped(tapGestureRecognizer:)))
        image_view_delete.isUserInteractionEnabled = true
        image_view_delete.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: AdvanceRequisitionListTableViewCellDelegate?
    @objc func ViewCustomBtnRemoveTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.AdvanceRequisitionListTableViewCellRemoveDidTapAddOrView(self)
        
    }
    
}
