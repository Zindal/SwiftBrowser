//
//  SearchEngineListTblCell.swift
//  IOS Browser
//
//  Created by Zindal on 03/09/20.
//  Copyright © 2020 zindal. All rights reserved.
//

import Foundation
import UIKit

class SearchEngineListTblCell: UITableViewCell {
    
    @IBOutlet var imgLogoView: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblURL: UILabel!
    @IBOutlet var imgTickView: UIImageView!
    
    func setUpCell(_ model:SearchEngineModel) {
        imgLogoView.image = model.logoImg
        lblName.text = model.engineName
        lblURL.text = model.engineHomeURL
        let value = SearchEngineManager.getDefaultSearchEngingIfSelected()
        if value.status {
            imgTickView.isHidden = !(model.engineCode == value.model?.engineCode)
        }
        else {
            imgTickView.isHidden = true
        }
    }
    
}
