//
//  LtaSupportingDocumentsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 20/07/21.
//

import UIKit

protocol LtaSupportingDocumentsTableViewCellDelegate : class {
    func LtaSupportingDocumentsTableViewCellRemoveDidTapAddOrView(_ sender: LtaSupportingDocumentsTableViewCell)
}
class LtaSupportingDocumentsTableViewCell: UITableViewCell {
    @IBOutlet weak var LabelPdfName: UILabel!
    @IBOutlet weak var LabelSerialNo: UILabel!
    @IBOutlet weak var LabelPdfSize: UILabel!
    @IBOutlet weak var BtnRemove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: LtaSupportingDocumentsTableViewCellDelegate?
    @IBAction func BtnRemoveFile(_ sender: Any) {
        delegate?.LtaSupportingDocumentsTableViewCellRemoveDidTapAddOrView(self)
    }

}
