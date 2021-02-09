//
//  EmployeeDocumentsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 26/11/20.
//

import UIKit

protocol downloadDelegate : class {
    func downloadTableViewCelldidTap(_ sender : EmployeeDocumentsTableViewCell)
}
class EmployeeDocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var label_document_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    weak var delegate: downloadDelegate?
    @IBAction func btn_download(_ sender: Any) {
        delegate?.downloadTableViewCelldidTap(self)
    }
}
