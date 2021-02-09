//
//  CompanyDocumentsTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 27/11/20.
//

import UIKit

protocol downloadCompanyDocumentDelegate : class{
    func downloadCompanyDocumentdidTapTableviewcell(_ sender: CompanyDocumentsTableViewCell)
}
class CompanyDocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var delegate : downloadCompanyDocumentDelegate?
    @IBAction func btn_download(_ sender: Any) {
        delegate?.downloadCompanyDocumentdidTapTableviewcell(self)
    }
}
