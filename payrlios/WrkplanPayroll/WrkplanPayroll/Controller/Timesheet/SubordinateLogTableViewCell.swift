//
//  SubordinateLogTableViewCell.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 07/12/20.
//

import UIKit

protocol SubordinateLogTableViewCellDelegate : class {
    func SubordinateLogTableViewCellDidTapView(_ sender: SubordinateLogTableViewCell)
}

class SubordinateLogTableViewCell: UITableViewCell {

    @IBOutlet weak var label_emp_name: UILabel!
    @IBOutlet weak var label_timein: UILabel!
    @IBOutlet weak var label_timeout: UILabel!
    @IBOutlet weak var label_status: UILabel!
    @IBOutlet weak var img_view_btn_popup: UIImageView!
    
    @IBOutlet weak var img_sub_log_arrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //---view Lat/Long popup
        let tapGestureRecognizerViewLocationDetails = UITapGestureRecognizer(target: self, action: #selector(ViewLocationTapped(tapGestureRecognizer:)))
        img_sub_log_arrow.isUserInteractionEnabled = true
        img_sub_log_arrow.addGestureRecognizer(tapGestureRecognizerViewLocationDetails)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    weak var delegate: SubordinateLogTableViewCellDelegate?
    
    //---task
    @objc func ViewLocationTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.SubordinateLogTableViewCellDidTapView(self)
    }
        
}
