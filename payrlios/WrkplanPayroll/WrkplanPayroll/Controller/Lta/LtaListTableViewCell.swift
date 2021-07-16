//
//  LtaListTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 14/07/21.
//

import UIKit

protocol LtaListTableViewCellDelegate : class {
    func LtaListTableViewCellRemoveDidTapAddOrView(_ sender: LtaListTableViewCell)
}
class LtaListTableViewCell: UITableViewCell {

    @IBOutlet weak var ViewParent: UIView!
    @IBOutlet weak var LabelLtaRequisitionNo: UILabel!
    @IBOutlet weak var LabelLtaDate: UILabel!
    @IBOutlet weak var LabelLtaStatus: UILabel!
    @IBOutlet weak var LabelLtaAmount: UILabel!
    @IBOutlet weak var ImgViewDelete: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewCustomBtnRemoveTapped(tapGestureRecognizer:)))
        ImgViewDelete.isUserInteractionEnabled = true
        ImgViewDelete.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    weak var delegate: LtaListTableViewCellDelegate?
    @objc func ViewCustomBtnRemoveTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.LtaListTableViewCellRemoveDidTapAddOrView(self)
        
    }
}
