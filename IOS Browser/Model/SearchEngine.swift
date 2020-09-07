//
//  SearchEngine.swift
//  IOS Browser
//
//  Created by Zindal on 03/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import Foundation
import UIKit

class SearchEngineModel: NSObject {
    
    var logoImg : UIImage!
    var engineName: String!
    var engineHomeURL: String!
    var engineCode: String!
    var engineQuery: String!
    
    required init(dict:[String:Any]) {
        logoImg = dict["logoImg"] as? UIImage
        engineName = dict["engineName"] as? String
        engineHomeURL = dict["engineHomeURL"] as? String
        engineCode = dict["engineCode"] as? String
        engineQuery = dict["engineQuery"] as? String
    }
    
}
