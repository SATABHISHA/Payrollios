//
//  Connectivity.swift
//  newtimesheetapp
//
//  Created by User on 28/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
