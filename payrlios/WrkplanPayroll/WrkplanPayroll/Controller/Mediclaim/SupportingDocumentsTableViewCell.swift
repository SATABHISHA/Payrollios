//
//  SupportingDocumentsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/06/21.
//

import UIKit

class SupportingDocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelPdfName: UILabel!
    @IBOutlet weak var LabelSerialNo: UILabel!
    @IBOutlet weak var LabelPdfSize: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func BtnRemoveFile(_ sender: Any) {
    }
}