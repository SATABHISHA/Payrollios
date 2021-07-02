//
//  UserSingletonModel.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 19/11/20.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserSingletonModel: NSObject {
    static let sharedInstance = UserSingletonModel()
    
    //------variables for user(login)-------
    var user_id:Int?
    var user_type:String?
    var user_name: String?
    
    //------variables for company(login)-------
    var email:String?
    var country: String?
    var logo_path: String?
    var active_yn: String?
    var gst_no: String?
    var company_code: String?
    var tan_no: String?
    var corporate_id: String?
    var state_id: String?
    var cin_no: String?
    var pf_no: String?
    var website: String?
    var phone: String?
    var esic_no: String?
    var company_name: String?
    var company_id: Int?
    var ptax_no: String?
    var business_type: String?
    var address_line2: String?
    var address_line1: String?
    var pin: String?
    
    //------variables for employee(login)-------
    var employeeJson: JSON?
    
    //-----variables for supporting documents page(Mediclaim)
//    var documents: JSON?
}
