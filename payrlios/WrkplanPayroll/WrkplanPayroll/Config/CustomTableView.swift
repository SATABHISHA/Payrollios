//
//  CustomTableView.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 22/04/24.
//

import Foundation
import UIKit

class CustomTableView: UITableView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }

}
