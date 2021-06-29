//
//  MediclaimListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 29/06/21.
//

import UIKit

protocol MediclaimListTableViewCellDelegate : class {
    func MediclaimListTableViewCellRemoveDidTapAddOrView(_ sender: MediclaimListTableViewCell)
}
class MediclaimListTableViewCell: UITableViewCell {

    @IBOutlet weak var view_parent: UIView!
    @IBOutlet weak var label_mediclaim_no: UILabel!
    @IBOutlet weak var label_mediclaim_date: UILabel!
    @IBOutlet weak var label_mediclaim_status: UILabel!
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

    weak var delegate: MediclaimListTableViewCellDelegate?
    @objc func ViewCustomBtnRemoveTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.MediclaimListTableViewCellRemoveDidTapAddOrView(self)
        
    }
}
